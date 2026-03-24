import os
import faiss
import pickle
from sentence_transformers import SentenceTransformer

DATA_PATH = "data/legal_docs/"
INDEX_PATH = "data/faiss.index"
META_PATH = "data/metadata.pkl"


model = SentenceTransformer("intfloat/e5-base-v2")

documents = []
for file in os.listdir(DATA_PATH):
    with open(os.path.join(DATA_PATH, file), "r", encoding="utf-8") as f:
        documents.append(f.read())

embeddings = model.encode(documents, normalize_embeddings=True)

dimension = embeddings.shape[1]
index = faiss.IndexFlatIP(dimension)
index.add(embeddings)

faiss.write_index(index, INDEX_PATH)

with open(META_PATH, "wb") as f:
    pickle.dump(documents, f)

print("Index built successfully!")
