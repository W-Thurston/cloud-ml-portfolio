## 📅 Week 1, Day 1 – **Cloud AI/ML Setup (AWS Focus)**

### 🧠 Goal:

By the end of today, you'll have:

- ✅ Set up AWS CLI + authenticated
- ✅ Provisioned an **S3 bucket** for ML data
- ✅ Launched a **SageMaker Studio notebook**
- ✅ Connected to it via browser
- ✅ Loaded the **Titanic dataset** into S3
- ✅ Run a **cloud-hosted Jupyter notebook** for basic EDA
- ✅ Set up Terraform to do this automatically in the future
- ✅ Committed progress to GitHub & Kanban

---

## 🚀 Step 1 – AWS CLI Auth + Environment Setup

### ✅ Check AWS CLI

```bash
aws --version
```

### ✅ Configure Credentials

```bash
aws configure
```

You'll need:

- **Access Key ID**
- **Secret Access Key**
- **Default region** (use `us-east-1` unless you prefer another)
- **Output format** → `json`

Test:

```bash
aws sts get-caller-identity
```

---

## 📦 Step 2 – Create an S3 Bucket for ML Data

```bash
aws s3 mb s3://ml-titanic-w1d1-wthurston --region us-east-1
```

📁 Upload Titanic CSV (you can get it from [Kaggle](https://www.kaggle.com/c/titanic/data) or use a cleaned version I can provide):

```bash
aws s3 cp titanic.csv s3://ml-titanic-w1d1-wthurston/data/
```

---

## 📓 Step 3 – Launch SageMaker Studio

> We’ll use **SageMaker Studio** (not SageMaker Notebook Instances — it’s the modern way)

### 🛠️ A. Create an execution role

```bash
aws iam create-role \
  --role-name sagemaker-execution-role \
  --assume-role-policy-document file://shared/terraform/iam-trust-policy.json
```

> I can generate this policy file if you like

### 🛠️ B. Launch Studio via Console

(SageMaker Studio is easiest to launch via AWS Console, but you can automate it later with Terraform.)

1. Go to **SageMaker → Studio → Domain**
2. Choose **“Quick setup”**
3. Pick your **IAM role** and region
4. Wait 5–10 mins while it boots up

---

## 📊 Step 4 – Run Your First Cloud Notebook

Inside SageMaker Studio:

```python
# s3_test_load.ipynb

import boto3
import pandas as pd
from io import StringIO

s3 = boto3.client('s3')
bucket = 'ml-titanic-w1d1-wthurston'
obj = s3.get_object(Bucket=bucket, Key='data/titanic.csv')

df = pd.read_csv(obj['Body'])
df.head()
```

That’s it — your notebook is now **running on AWS**, using cloud storage!

---

## 🧱 Step 5 – (Optional) Terraform Starter for S3 Bucket

If you want to try deploying the S3 bucket with Terraform:

```hcl
# shared/terraform/aws-s3-bucket.tf
resource "aws_s3_bucket" "ml_bucket" {
  bucket = "ml-titanic-w1d1-wthurston"
  force_destroy = true
}
```

Then:

```bash
cd shared/terraform
terraform init
terraform plan
terraform apply
```

---

## 🧪 Exercises for Today

1. ✅ Launch SageMaker Studio in `us-east-1`
2. ✅ Upload Titanic dataset to S3 (`aws s3 cp`)
3. ✅ Load S3 file in SageMaker notebook using `boto3`
4. ✅ Commit notebook to `aws/ingestion/`
5. ✅ Run `pre-commit run --all-files`
6. ✅ Mark Kanban card "Run basic EDA notebook" as ✅ Done

---
