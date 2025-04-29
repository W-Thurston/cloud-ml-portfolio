# 📅 Week 2, Day 3 – Azure Cosmos DB (MongoDB API)

---

## 🧠 Goal:

By the end of today you will:

- ✅ Provision a **Cosmos DB** database using the **MongoDB API**
- ✅ Create a collection (like a MongoDB collection)
- ✅ Insert Titanic-style documents
- ✅ Query documents with Python (`pymongo`)
- ✅ Learn about partition keys, throughput, and cost-saving options
- ✅ Clean up everything to avoid Azure billing!

---

# 🛠️ Tools You'll Use:

- Azure CLI (`az cosmosdb`)
- Azure Portal (optional)
- Python (`pymongo`)
- Jupyter or standalone Python scripts

---

# 🚀 Step-by-Step Plan

---

## 📦 Step 1: Create a Cosmos DB Account (MongoDB API)

```bash
az group create --name rg-ml-w2d3 --location eastus
```

```bash
az cosmosdb create \
  --name mlcosmosw2d3yourname \
  --resource-group rg-ml-w2d3 \
  --kind MongoDB \
  --locations regionName=eastus failoverPriority=0 isZoneRedundant=False
  --server-version 4.0
```

✅ Replace `yourname` to ensure global uniqueness.
✅ Cosmos DB requires globally unique names!

This creates the database account.

---

## 📋 Step 2: Create a Database + Collection

```bash
az cosmosdb mongodb database create \
  --account-name mlcosmosw2d3yourname \
  --name titanicdb \
  --resource-group rg-ml-w2d3
```

```bash
az cosmosdb mongodb collection create \
  --account-name mlcosmosw2d3yourname \
  --database-name titanicdb \
  --name passengers \
  --resource-group rg-ml-w2d3 \
  --throughput 400
```

> 400 RU/s = minimum serverless throughput (free-tier eligible if your account is eligible).

---

## 🔐 Step 3: Get Connection String

```bash
az cosmosdb keys list \
  --name mlcosmosw2d3yourname \
  --resource-group rg-ml-w2d3 \
  --type connection-strings \
  --query connectionStrings[0].connectionString \
  --output tsv
```

✅ Save this connection string — we’ll use it in Python.

---

## 📓 Step 4: Connect via Python and Insert Titanic Data

Install `pymongo` if needed:

```bash
pip install pymongo
```

Python sample:

```python
from pymongo import MongoClient

client = MongoClient("your-connection-string-here")
db = client["titanicdb"]
collection = db["passengers"]

# Insert documents
collection.insert_many([
    {"name": "John Doe", "survived": 0, "pclass": 3, "sex": "male", "age": 35},
    {"name": "Jane Doe", "survived": 1, "pclass": 1, "sex": "female", "age": 28}
])

# Query documents
for doc in collection.find({"survived": 1}):
    print(doc)
```

✅ If you see matching documents printed, your CosmosDB connection works!

---

## 📄 Deliverable

Save your notebook under:

```bash
azure/databases/load_titanic_cosmosdb.ipynb
```

or

```bash
azure/databases/load_titanic_cosmosdb.py
```

✅ Push everything to GitHub once verified.

---

## 🧹 Cleanup

```bash
az group delete --name rg-ml-w2d3 --yes --no-wait
```

✅ This deletes the Cosmos DB account, database, collection, and resource group all at once.

---

# 🏁 Summary: Today’s Learning Outcomes

- Working with Azure Cosmos DB using MongoDB API
- Understanding partition keys, indexing, and throughput units
- Cloud-native NoSQL access from Python
- Fast data ingestion and querying workflows

---

# 📣 Notes:

- Cosmos DB is **multi-region by design** (you'll notice the high-availability setup)
- Costs are **mostly tied to provisioned throughput (RU/s)** and storage
