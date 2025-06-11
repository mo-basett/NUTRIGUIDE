from llama_index.core import SimpleDirectoryReader
from llama_index.core.node_parser import SentenceSplitter
from llama_index.core import Settings
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.core import  VectorStoreIndex
from langchain_groq import ChatGroq
from langchain.tools import BaseTool, StructuredTool, tool
from pydantic import BaseModel
from langchain_community.tools.tavily_search import TavilySearchResults
from typing import TypedDict ,Annotated
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser
import os
import uuid
from typing import TypedDict ,Annotated
from langchain_core.messages import AnyMessage,SystemMessage,HumanMessage,ToolMessage,AIMessage
import operator
from langgraph.checkpoint.memory import InMemorySaver
from langgraph.graph import StateGraph, END
from fastapi import FastAPI
import json
import shutil
import os
from fastapi import FastAPI, File, UploadFile
import time
import requests
from datetime import datetime
from io import BytesIO
import os

import nltk
nltk.download('stopwords', quiet=True)

cache_dir = "/tmp/tiktoken_cache"  # or "~/tiktoken_cache"
os.makedirs(cache_dir, exist_ok=True)
os.environ["TIKTOKEN_CACHE_DIR"] = cache_dir

os.environ["GROQ_API_KEY"] = "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"
os.environ["TAVILY_API_KEY"] = "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"

app = FastAPI()

@app.get("/")
def read_root():
    app.state.vector_index = None
    # keep_alive()
    return {"message": "Connected"}

def keep_alive(space_url="https://1mr-apigmail.hf.space/ping", interval_hours=5):
    while True:
        try:
            print(f"🔄 Pinging {space_url} at {datetime.now()}")
            response = requests.get(space_url)

            if response.status_code == 200:
                print("")
            else:
                print("")
        except Exception as e:
            print("")
        
        time.sleep(interval_hours * 3600)

# keep_alive()

@tool
def retrieve(query_text):
    """
    Retrieves relevant information from a vector index based on a query from reports.
    Parameters:
    - query_text (str): Query to search for relevant information.
    Returns:
    - str: Retrieved text from the document.
    """
    if not hasattr(app.state, "vector_index") or app.state.vector_index is None:
        return "Vector index not found. Please upload a file first."
    else:
        retriever = app.state.vector_index.as_retriever(similarity_top_k=3)
        result = retriever.retrieve(query_text)
        if result:
            return "\n\n".join([node.node.text for node in result])
        return "No relevant information found."

tavily_search = TavilySearchResults(max_results=4)


@app.post("/uploadpdfs")
async def upload_file(file: UploadFile = File(...)):
    # global vector_index

    # Save uploaded file to a temp directory
    temp_dir = "temp_uploads"
    os.makedirs(temp_dir, exist_ok=True)
    file_id = str(uuid.uuid4())
    file_path = os.path.join(temp_dir, f"{file_id}_{file.filename}")

    with open(file_path, "wb") as f:
        shutil.copyfileobj(file.file, f)

    # Load and parse document
    documents = SimpleDirectoryReader(input_files=[file_path]).load_data()
    parser = SentenceSplitter(chunk_size=300, chunk_overlap=50)
    nodes = parser.get_nodes_from_documents(documents)

    # Create or update vector index
    embed_model = HuggingFaceEmbedding(model_name="WhereIsAI/UAE-Large-V1")
    # if vector_index is None:
    if not hasattr(app.state, "vector_index") or app.state.vector_index is None:
        app.state.vector_index = VectorStoreIndex(nodes, embed_model=embed_model)
        message = "New vector index created and file stored."
    else:
        app.state.vector_index.insert_nodes(nodes)
        message = "File stored and vector index updated."

    return {"message": message, "filename": file.filename}


class QueryRequest(BaseModel):
    message: str
    
class AgentState(TypedDict):
  messages: Annotated[list[AnyMessage], operator.add]

memory = InMemorySaver()

class Agent:
  def __init__(self, model, tools, checkpointer=None, system=""):
    self.system = system
    graph = StateGraph(AgentState)
    graph.add_node('llm',self.call_llm)
    graph.add_node('action',self.take_action)
    graph.add_conditional_edges("llm",self.exists_action,{True :"action",False:END})
    graph.add_edge("action","llm")
    graph.set_entry_point("llm")
    self.graph = graph.compile(checkpointer=checkpointer)
    self.tools = {t.name:t for t in tools}
    self.model = model.bind_tools(tools)

  def call_llm(self, state:AgentState):
    messages = state['messages']
    if self.system :
      messages = [SystemMessage(content=self.system)] + messages
    message = self.model.invoke(messages)
    return {"messages":[message]}

  def exists_action(self, state:AgentState):
    result = state['messages'][-1]
    return len(result.tool_calls) > 0

  def take_action(self, state:AgentState):
    tool_calls = state['messages'][-1].tool_calls
    results = []
    for t in tool_calls:
      result= self.tools[t['name']].invoke(t['args'])
      results.append(ToolMessage(tool_call_id=t['id'],name=t['name'],content=str(result)))
    return {"messages":results}


system_Prompt="""
You are an AI assistant designed to assist users with health benefits, diet, nutrition information, and recipes.
You analyze patient reports to offer guidance on self-care with AI support.
Provide answers directly related to the question, without additional explanation or unrelated information.
"""

tools=[retrieve]

model = ChatGroq(model="qwen-qwq-32b")

agent = Agent(model, tools, memory, system=system_Prompt)

thread = {"configurable": {'thread_id': '1'}}


@app.post("/askbot")
async def ask_question(query: QueryRequest):
    messages = [HumanMessage(content=query.message)]
    final_res = ""

    for event in agent.graph.stream({'messages': messages}, thread):
        for v in event.values():
            if isinstance(v, dict) and 'messages' in v:
                for msg in v['messages']:
                    if hasattr(msg, 'content') and isinstance(msg, AIMessage):
                        final_res += msg.content

    return {"answer": final_res}