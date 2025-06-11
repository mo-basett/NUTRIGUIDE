from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import tensorflow as tf
import numpy as np
import shutil
import os
from huggingface_hub import InferenceClient
import json
import requests
from langchain_groq import ChatGroq
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import chain
from langchain_huggingface import HuggingFaceEndpoint,ChatHuggingFace
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnableParallel
from PIL import Image
import json
import requests
import os
import time
from datetime import datetime
os.environ["GROQ_API_KEY"] = "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"
# os.environ["HUGGINGFACEHUB_API_TOKEN"]="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1"

# Initialize FastAPI app
app = FastAPI()

chat_nutrition_prompt = ChatPromptTemplate.from_template(
    '''
    Provide the nutrition information (Calories, Protein, Carbohydrates, Dietary Fiber, Sugars, Fat, Sodium, Potassium, Vitamin C, Vitamin B6) for {prediction} per 100 grams, Output the information as a concise, formatted list without repetition.
    '''
)

chat_health_benefits_prompt = ChatPromptTemplate.from_template(
    '''
    Provide the health benefits and considerations for {prediction}. Additionally, include practical tips for making {prediction} healthier. Keep the response focused on these two aspects only.
    '''
)
chat_recipes_prompt = ChatPromptTemplate.from_template(
    '''
    Tell me about the two most famous recipes for {prediction}. Include the ingredients only.
    '''
)

def load_and_prep_image(uploaded_file, img_shape=224):
    img = Image.open(uploaded_file)  # Open uploaded image
    img = img.resize((img_shape, img_shape))  # Resize image
    img = tf.convert_to_tensor(img, dtype=tf.float32)  # Convert to tensor
    return img
@chain
def predict_label(uploaded_file):
    img = load_and_prep_image(uploaded_file, img_shape=224)  # Preprocess image
    img = tf.expand_dims(img, axis=0)  # Add batch dimension
    
    pred = model.predict(img)  # Model prediction
    pred_class_index = np.argmax(pred, axis=1)[0]  # Get highest probability index
    pred_class_name = class_labels[pred_class_index]  # Convert index to class name
    return pred_class_name
    
model = tf.keras.models.load_model("NewVersionModelOptimized40V2.keras")
class_labels = {0: 'Baked Potato',1: 'Burger',2: 'Cake',3: 'Chips',4: 'Crispy Chicken',5: 'Croissant',
 6: 'Dount',7: 'Dragon Fruit',8: 'Frise',9: 'Hot Dog',10: 'Jalapeno',11: 'Kiwi',12: 'Lemon',13: 'Lettuce',
 14: 'Mango',15: 'Onion',16: 'Orange',17: 'Pizza',18: 'Taquito',19: 'apple',20: 'banana',21: 'beetroot',
 22: 'bell pepper',23: 'bread',24: 'cabbage',25: 'carrot',26: 'cauliflower',27: 'cheese',28: 'chilli pepper',
 29: 'corn',30: 'crab',31: 'cucumber',32: 'eggplant',33: 'eggs',34: 'garlic',36: 'grapes',37: 'milk',
 38: 'salamon',39: 'yogurt'}

# api_key='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00'
# llm = HuggingFaceEndpoint(
#     repo_id="Qwen/Qwen2.5-72B-Instruct",
#     task="text-generation",
#     max_new_tokens=512,
#     do_sample=False,
#     repetition_penalty=1.03,
# )

# chat= ChatHuggingFace(llm=llm)

chat= ChatGroq(model="meta-llama/llama-4-scout-17b-16e-instruct")

str_output_parser = StrOutputParser()

chain_label = predict_label
chain1=  chat_nutrition_prompt | chat | str_output_parser
chain2=  chat_health_benefits_prompt | chat | str_output_parser
chain3=  chat_recipes_prompt | chat | str_output_parser

chain_parallel = RunnableParallel({'chat_nutrition_prompt':chain1,
                                   'chat_health_benefits_prompt':chain2,
                                   'chat_recipes_prompt':chain3})

@app.get("/")
def read_root():
    return {"message": "This is My Nutrionguid App FAST"}
    # keep_alive()

@app.get("/ping")
def ping():
    return {"status": "alive"}
    
def keep_alive(space_url="https://1mb1-nutritionguide.hf.space/ping", interval_hours=5):
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
        
@app.post("/predictNUT")
async def predict_image_and_nutrition(file: UploadFile = File(...)):
    try:
        # Save the uploaded file
        file_location = f"./temp_{file.filename}"
        with open(file_location, "wb") as f:
            shutil.copyfileobj(file.file, f)
        
        # Predict the label using the same prediction logic
        with open(file_location, "rb") as image_file:
            prediction = predict_label.invoke(image_file)
        
        # Remove the temporary file
        # os.remove(file_location)

        result = chain_parallel.invoke(prediction)

        return {
            "Predicted_label": prediction, 
            "Nutrition_info": result['chat_nutrition_prompt'],
            "Information": result['chat_health_benefits_prompt'],
            "Recipes":result['chat_recipes_prompt']
        }
    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"error": f"An error occurred: {str(e)}"}
        )