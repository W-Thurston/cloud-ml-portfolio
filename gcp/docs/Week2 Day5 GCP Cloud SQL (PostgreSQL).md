## 🚀 Deployment Plan – GCP Cloud SQL (PostgreSQL)

### ✅ Step 1: Provision the Cloud SQL instance (PostgreSQL)

```bash
# Set your project and region
gcloud config set project <your_project_id>
gcloud config set compute/region us-central1

# Create Cloud SQL instance (PostgreSQL)
gcloud sql instances create <your_project_id>-postgres \
  --database-version=POSTGRES_14 \
  --cpu=1 \
  --memory=4GiB \
  --region=us-central1 \
  --root-password=YourStrongPassword123 \
  --no-assign-ip
```

### ✅ Step 2: Create the Titanic database & user

```bash
# Create a database inside the instance
gcloud sql databases create titanic_db --instance=<your_project_id>-postgres

# Create a custom user (optional)
gcloud sql users create ml_user \
  --instance=<your_project_id>-postgres \
  --password=MLuserSecurePwd2024
```

> 💡 Use the **Cloud SQL Auth Proxy** instead of public IPs to keep things secure.

---

## 🔐 Step 3: Install & Run Cloud SQL Auth Proxy (locally)

**Install it** if not already:

```bash
# Download proxy binary (Linux/macOS)
curl -o cloud-sql-proxy https://dl.google.com/cloudsql/cloud-sql-proxy.linux.amd64
chmod +x cloud-sql-proxy
sudo mv cloud-sql-proxy /usr/local/bin/
```

**Run it with your service account key:**

```bash
cloud-sql-proxy \
  --credentials-file=gcp/<your_project_id>-service-account.json \
  <your_project_id>:us-central1:<your_project_id>-postgres
```

This exposes your DB at `localhost:5432`.

---

## 📦 Step 4: Upload Titanic Dataset via Python

📄 Save this as `gcp/databases/load_titanic_cloudsql.py`:

```python
import pandas as pd
import psycopg2
from sqlalchemy import create_engine

# Define DB credentials
db_user = "ml_user"
db_password = "MLuserSecurePwd2024"
db_name = "titanic_db"
db_host = "127.0.0.1"
db_port = "5432"

# Load Titanic dataset
df = pd.read_csv("shared/datasets/titanic.csv")

# Connect using SQLAlchemy
engine = create_engine(f"postgresql+psycopg2://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}")

# Write to SQL (replace if exists)
df.to_sql("passengers", engine, if_exists="replace", index=False)

print("✅ Data uploaded to Cloud SQL")
```

> 🧪 Tip: You can query it in a notebook later using the same credentials via `%sql` or SQLAlchemy.

---

## 🧪 Step 5: Test a SELECT Query (Optional Notebook)

In a new notebook `gcp/databases/query_titanic_cloudsql.ipynb`:

```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("postgresql+psycopg2://ml_user:MLuserSecurePwd2024@127.0.0.1:5432/titanic_db")

# Simple query
df = pd.read_sql("SELECT survived, COUNT(*) FROM passengers GROUP BY survived", engine)
df.head()
```

---

## ✅ Cleanup (When Done)

```bash
gcloud sql instances delete <your_project_id>-postgres
```

---
