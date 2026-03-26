import faiss
import numpy as np
import json
from sentence_transformers import SentenceTransformer


class Retriever:
    def __init__(self,
                 index_path="data/faiss_index.index",
                 metadata_path="data/faiss_metadata.json"):

        print("Loading FAISS index...")
        self.index = faiss.read_index(index_path)

        print("Loading metadata...")
        with open(metadata_path, "r", encoding="utf-8") as f:
            self.metadata = json.load(f)

        print("Loading embedding model...")
        self.model = SentenceTransformer("intfloat/e5-base-v2")

    def search(self, query, top_k=8):
        query_embedding = self.model.encode(
            f"query: {query}",
            convert_to_numpy=True,
            normalize_embeddings=True
        )

        D, I = self.index.search(np.array([query_embedding]), top_k)

        results = [self.metadata[i] for i in I[0]]
        return results
