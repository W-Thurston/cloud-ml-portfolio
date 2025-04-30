# 📅 Week 2, Day 4 – GCP Firestore (NoSQL Document DB)

---

## 🧠 Goal:

By the end of today, you will:

- ✅ Provision a Firestore database (Native mode)
- ✅ Insert Titanic-style documents from Python
- ✅ Query using filters (survived, class, gender)
- ✅ Understand Firestore’s billing model (reads/writes/storage)
- ✅ Clean up everything from the project to avoid charges

---

# 🛠️ Tools You'll Use

- GCP CLI (`gcloud`)
- Firestore in Native mode
- Python (`google-cloud-firestore`)
- Jupyter notebook or `.py` script

---

# 🚀 Step-by-Step Plan

---

## 🔧 Step 1: Enable Firestore in Your Project

Make sure Firestore API is enabled:

```bash
gcloud services enable firestore.googleapis.com
```

Then create the Firestore DB in **Native mode**:

```bash
gcloud firestore databases create \
  --region=us-central \
  --database=default
```

> ⚠️ Firestore must use `default` as the primary database name.
> This is a one-time, region-locked setting per GCP project.

---

## 📦 Step 2: Install the Python Client

Install the Firestore SDK:

```bash
pip install google-cloud-firestore
```

---

## 🧪 Step 3: Connect & Insert Titanic Data

Create this notebook or script:

```python
from google.cloud import firestore

# Automatically uses GOOGLE_APPLICATION_CREDENTIALS if set
db = firestore.Client()

collection = db.collection("passengers")

# Insert documents
collection.add({
    "name": "John Doe",
    "survived": 0,
    "pclass": 3,
    "sex": "male",
    "age": 35
})

collection.add({
    "name": "Jane Doe",
    "survived": 1,
    "pclass": 1,
    "sex": "female",
    "age": 28
})
```

---

## 🔍 Step 4: Query the Data

```python
docs = collection.where("survived", "==", 1).stream()
for doc in docs:
    print(doc.to_dict())
```

✅ You should see the matching documents printed.

---

## 📁 Save Your Work

Save the final notebook as:

```
gcp/databases/load_titanic_firestore.ipynb
```

Push to GitHub when complete.

---

## 🧹 Cleanup (Important!)

Firestore doesn’t charge for the database itself, but charges for storage and operations.

To clean up:

1. Delete all documents in your collection:

```python
docs = db.collection("passengers").stream()
for doc in docs:
    doc.reference.delete()
```

2. Disable Firestore (optional, if you won’t reuse it soon):

```bash
gcloud firestore databases delete --database=default
```

> Note: Deletion might not be instant — it enters a scheduled removal state.

---

# 🧠 Firestore Billing Basics

| Cost Category | Details                             |
| ------------- | ----------------------------------- |
| **Reads**     | $0.06 per 100,000                   |
| **Writes**    | $0.18 per 100,000                   |
| **Deletes**   | $0.02 per 100,000                   |
| **Storage**   | $0.18 per GB/month                  |
| **Free Tier** | 50K reads, 20K writes, 1 GB storage |

---

# 🏁 Summary: Today’s Learning Outcomes

- Firestore basics: document storage, collections, filters
- GCP SDK usage for NoSQL access
- Data modeling and querying using document fields
- Cleanup process and billing awareness
