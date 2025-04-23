## 📅 Week 1, Day 2 – Azure ML Setup & Data Ingestion

### 🧠 Goal:

By the end of today, you will:

- ✅ Upload the Titanic dataset to **Azure Blob Storage**
- ✅ Set up an **Azure Machine Learning Workspace**
- ✅ Launch a **cloud-hosted Jupyter notebook**
- ✅ Load the Titanic data from Blob Storage into a notebook
- ✅ Save and commit the notebook to GitHub
- ✅ Clean up Azure resources to avoid charges

---

### 🧰 Tools You’ll Use Today

- az CLI (Azure CLI)
- Azure Portal
- Azure Storage Account (Blob)
- Azure Machine Learning Studio (Notebooks)
- azure-storage-blob Python SDK

---

### 🚀 Step 1: Check Azure CLI Setup

### ✅ Verify CLI

```bash
az version
```

### ✅ Log In

```bash
az login
```

If you have multiple subscriptions:

```bash
az account set --subscription "YOUR-SUBSCRIPTION-NAME"
```

### 📦 Step 2: Create a Storage Account + Upload Titanic

### ✅ Create Resource Group

```bash
az group create \
 --name rg-ml-w1d2 \
 --location eastus
```

### ✅ Create Storage Account

```bash
az storage account create \
 --name mlw1d2storage \
 --resource-group rg-ml-w1d2 \
 --location eastus \
 --sku Standard_LRS
```

### ✅ Create Blob Container

```bash
az storage container create \
 --account-name mlw1d2storage \
 --name titanic-data \
 --auth-mode login
```

### ✅ Upload Titanic Dataset

```bash
az storage blob upload \
 --account-name mlw1d2storage \
 --container-name titanic-data \
 --name titanic.csv \
 --file shared/datasets/titanic.csv \
 --auth-mode login
```

### 📓 Step 3: Set Up Azure ML Studio Workspace

> Azure ML is easiest to launch via the portal:

1. Go to Azure ML Studio
2. Create a new Machine Learning Workspace

   - Subscription: your current one
   - Resource group: rg-ml-w1d2
   - Workspace name: ml-w1d2-ws
   - Region: East US

3. Click Create and wait ~2 minutes

### 📔 Step 4: Launch Notebook & Load Titanic

Once inside the ML workspace:

- Go to Notebooks on the left nav
- Create a new file: load_titanic_blob.ipynb
- Use this Python code:

```python
from azure.storage.blob import BlobClient
import pandas as pd

blob = BlobClient.from_connection_string(
conn_str="DefaultEndpointsProtocol=https;AccountName=mlw1d2storage;...",
container_name="titanic-data",
blob_name="titanic.csv"
)

stream = blob.download_blob()
df = pd.read_csv(stream)
df.head()
```

```bash
az storage account show-connection-string \
  --name mlw1d2storage \
  --resource-group rg-ml-w1d2 \
  --query connectionString \
  --output tsv
```

### 🧪 Exercises for Today

1. ✅ Upload Titanic dataset to Azure Blob
2. ✅ Launch Azure ML Studio + notebook
3. ✅ Load CSV from Blob using azure-storage-blob
4. ✅ Save notebook to azure/ingestion/load_titanic_blob.ipynb
5. ✅ Push to GitHub
6. ✅ Clean up all Azure resources

---

### 🔥 Cleanup Command

```bash
az group delete --name rg-ml-w1d2 --yes --no-wait
```

This deletes all resources you created today in one go.
