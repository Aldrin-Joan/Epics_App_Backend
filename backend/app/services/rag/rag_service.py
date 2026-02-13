from .embedder import Embedder
from .retriever import Retriever
from .generator import Generator

class RAGService:
    def __init__(self):
        self.embedder = Embedder()
        self.retriever = Retriever()
        self.generator = Generator()

    def query(self, user_query):
        query_embedding = self.embedder.embed(user_query)[0]
        retrieved_chunks = self.retriever.search(query_embedding)

        context = "\n\n".join(retrieved_chunks)
        answer = self.generator.generate(user_query, context)

        return answer
