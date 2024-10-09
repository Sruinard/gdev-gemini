import os
import vertexai
from vertexai.generative_models import GenerativeModel

from fastapi import FastAPI
from pydantic import BaseModel

class ChatMessage(BaseModel):
    message: str

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/messages")
async def invoke(message: ChatMessage) -> str:
    pid = ""
    if 'GCP_PROJECT' in os.environ:
        pid = os.environ['GCP_PROJECT']
    print(f"Project ID: {pid}")
    vertexai.init(project=pid, location="us-central1")

    model = GenerativeModel("gemini-1.5-flash-002")

    response = model.generate_content(
        message.message
    )

    return response.text