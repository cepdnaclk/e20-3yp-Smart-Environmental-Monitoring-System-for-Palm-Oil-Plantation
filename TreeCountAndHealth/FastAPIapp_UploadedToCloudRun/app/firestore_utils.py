from google.cloud import firestore
import os

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "app/gcp-key.json"
db = firestore.Client()

def save_to_firestore(data: dict, collection: str = "tree_detection"):
    doc_ref = db.collection(collection).document()
    doc_ref.set(data)
