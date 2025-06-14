# Use the official Python 3.9 image
FROM python:3.9
 
# Set the working directory to /code
WORKDIR /code
 
# Copy the requirements file
COPY ./requirements.txt /code/requirements.txt
 
# Install dependencies from requirements.txt
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
 
# Set up a new user named "user" with user ID 1000
RUN useradd -m -u 1000 user

# Switch to the "user" user
USER user

# Set environment variables
ENV HOME=/home/user
ENV PATH=$HOME/.local/bin:$PATH
 
# Set the working directory to the user's home directory
WORKDIR $HOME/app
 
# Copy the application code and set ownership to the user
COPY --chown=user . $HOME/app
 
# Start the FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
