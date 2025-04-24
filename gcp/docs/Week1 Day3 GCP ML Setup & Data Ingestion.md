**Let’s go!** 🚀
Welcome to **Week 1, Day 3**: today is all about **Google Cloud Platform (GCP)** and getting hands-on with:

- ✅ Google Cloud Storage (GCS)
- ✅ Vertex AI Workbench (JupyterLab)
- ✅ Python SDK for data ingestion
- ✅ GCP IAM permissions
- ✅ Dataset upload, notebook access, cleanup

---

## 📅 Week 1, Day 3 – GCP ML Setup & Data Ingestion

### 🧠 Goal:

By the end of today, you will:

- Upload Titanic dataset to **Google Cloud Storage**
- Set up a **Vertex AI Workbench instance**
- Launch a notebook and load the dataset
- Commit your notebook to GitHub
- Clean up all GCP resources

---

## 🛠️ Step 1: Check GCP CLI & Auth

### ✅ Verify `gcloud` CLI:

```bash
gcloud version
```

### ✅ Log In:

```bash
gcloud auth login
```

### ✅ Set Project (if needed):

```bash
gcloud config set project YOUR_PROJECT_ID
```

---

## 📦 Step 2: Create a GCS Bucket + Upload Titanic Dataset

### ✅ Create Bucket:

```bash
gsutil mb -p YOUR_PROJECT_ID -l us-central1 gs://ml-titanic-w1d3-yourname/
```

### ✅ Upload Titanic Dataset:

```bash
gsutil cp shared/datasets/titanic.csv gs://ml-titanic-w1d3-yourname/data/
```

---

### 🧭 **Create a Managed Workbench Notebook**

1. Go to: [Vertex AI → Workbench](https://console.cloud.google.com/vertex-ai/workbench)
2. Click: **“New Notebook → Managed notebooks”**
3. Choose:
   - **Region**: `us-central1`
   - **Environment**: `Python (3.10)` or latest
   - **Machine type**: `e2-standard-2` or similar
   - Auto-pause: `Idle for 20 minutes`
4. Click **Create**

Then click **“Open JupyterLab”** when it’s ready.

---

## 📔 Step 4: Load Titanic Data in Python

Inside your Vertex AI JupyterLab notebook:

```python
from google.cloud import storage
import pandas as pd

client = storage.Client()
bucket = client.bucket('ml-titanic-w1d3-yourname')
blob = bucket.blob('data/titanic.csv')

content = blob.download_as_text()
df = pd.read_csv(pd.compat.StringIO(content))
df.head()
```

> 💡 If this throws an error, try enabling the API or installing the SDK:
> `!pip install google-cloud-storage`

---

## 🧪 Day 3 Exercises

1. ✅ Create GCS bucket
2. ✅ Upload Titanic dataset
3. ✅ Launch Vertex notebook
4. ✅ Load dataset using `google-cloud-storage`
5. ✅ Save notebook as `gcp/ingestion/load_titanic_gcs.ipynb`
6. ✅ Commit + push to GitHub
7. ✅ Clean up GCP resources

---

## 🔥 Cleanup (to avoid charges)

```bash
gsutil rm -r gs://ml-titanic-w1d3-yourname
gcloud notebooks instances delete w1d3-notebook --location=us-central1
```

---
