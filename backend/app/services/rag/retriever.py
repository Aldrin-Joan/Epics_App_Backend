import faiss
import numpy as np
import os
import pickle

class Retriever:
    def __init__(self, index_path="data/faiss.index", metadata_path="data/metadata.pkl"):
        self.index = faiss.read_index(index_path)
        with open(metadata_path, "rb") as f:
            self.metadata = pickle.load(f)

    def search(self, query_embedding, top_k=5):
        D, I = self.index.search(np.array([query_embedding]), top_k)
        results = [self.metadata[i] for i in I[0]]
        return results
