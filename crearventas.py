import random
import json
from datetime import datetime, timedelta

# Helper functions
def random_date_2025():
    start = datetime(2025, 1, 1)
    end = datetime(2025, 12, 31)
    random_days = random.randint(0, (end - start).days)
    return (start + timedelta(days=random_days)).isoformat()

def random_productos():
    productos = []
    num_productos = random.randint(1, 5)  # Each venta can have 1 to 5 productos
    for _ in range(num_productos):
        productos.append({
            "producto_id": str(random.randint(1, 4)),
            "cantidad": random.randint(1, 10)
        })
    return productos

# Generate 100 documents
documents = []
for _ in range(100):
    doc = {
        "cliente_id": str(random.randint(1, 10)),
        "fecha": random_date_2025(),
        "productos": random_productos()
    }
    documents.append(doc)

# Write to a JSON file
with open("ventas.json", "w", encoding="utf-8") as f:
    for doc in documents:
        json.dump(doc, f)
        f.write("\n")  # Each document on a new line (for mongoimport compatibility)

print("ventas.json created with 100 documents.")
