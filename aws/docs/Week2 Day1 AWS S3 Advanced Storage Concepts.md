# 📅 Week 2, Day 1 – AWS S3 Advanced Storage Concepts

---

## 🧠 Goal:

By the end of today you will:

- ✅ Work with **advanced S3** features (object lifecycle, versioning, permissions)
- ✅ Upload a _larger_ dataset using CLI
- ✅ Explore **S3 Storage Classes** (Standard vs Infrequent Access vs Glacier)
- ✅ Configure an **S3 lifecycle policy**
- ✅ Enable **bucket versioning** and test restoring files
- ✅ Set up a **basic S3 event notification** (previewing serverless concepts)
- ✅ Clean up everything to avoid storage charges

---

## 🛠️ Tools You'll Use:

- AWS CLI (`aws s3api`, `aws s3`)
- AWS S3 Console
- Python SDK (boto3)
- JSON IAM Policies & S3 Lifecycle configs

---

# 🚀 Step-by-Step Plan

---

## 📦 Step 1: Create a New S3 Bucket

```bash
aws s3api create-bucket \
  --bucket ml-storage-w2d1-yourname \
  --region us-east-1
```

---

## 📤 Step 2: Upload Files

Use a slightly bigger dataset (or upload Titanic again multiple times to simulate).

```bash
aws s3 cp shared/datasets/titanic.csv s3://ml-storage-w2d1-yourname/data/titanic-v1.csv
aws s3 cp shared/datasets/titanic.csv s3://ml-storage-w2d1-yourname/data/titanic-v2.csv
```

---

## ♻️ Step 3: Enable Bucket Versioning

```bash
aws s3api put-bucket-versioning \
  --bucket ml-storage-w2d1-yourname \
  --versioning-configuration Status=Enabled
```

### ✅ Test Versioning:

Re-upload the same file:

```bash
aws s3 cp shared/datasets/titanic.csv s3://ml-storage-w2d1-yourname/data/titanic-v1.csv
```

Then list object versions:

```bash
aws s3api list-object-versions --bucket ml-storage-w2d1-yourname
```

---

## 🧹 Step 4: Set Lifecycle Rules (Auto-Transition + Expiry)

Create a file `lifecycle.json`:

```json
{
  "Rules": [
    {
      "ID": "Move to Glacier after 30 days",
      "Prefix": "",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "GLACIER"
        }
      ],
      "Expiration": {
        "Days": 365
      }
    }
  ]
}
```

Then apply:

```bash
aws s3api put-bucket-lifecycle-configuration \
  --bucket ml-storage-w2d1-yourname \
  --lifecycle-configuration file://lifecycle.json
```

---

## 📣 Step 5 (Bonus): Setup S3 Event Notification

Optional (for bonus points), configure an S3 event to trigger a basic notification (like an SNS topic or EventBridge) when an object is uploaded.

## 📦 1. Create SNS Topic

```bash
aws sns create-topic --name s3-event-topic
```

Save the returned ARN — it will look like:

```plaintext
arn:aws:sns:us-east-1:123456789012:s3-event-topic
```

---

## 👤 2. Subscribe Your Email to the Topic (for Testing)

```bash
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:123456789012:s3-event-topic \
  --protocol email \
  --notification-endpoint your-email@example.com
```

🔔 **Check your email**: you’ll get a confirmation link you MUST click to activate the subscription.

---

## 🪣 3. Grant S3 Permission to Publish to SNS

You need to attach a **topic policy** to the SNS topic.

Create a `sns-topic-policy.json` file:

```json
{
  "Version": "2008-10-17",
  "Id": "PolicyForS3Publish",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "s3.amazonaws.com" },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-east-1:123456789012:s3-event-topic",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:::ml-storage-w2d1-yourname"
        }
      }
    }
  ]
}
```

Attach it:

```bash
aws sns set-topic-attributes \
  --topic-arn arn:aws:sns:us-east-1:123456789012:s3-event-topic \
  --attribute-name Policy \
  --attribute-value file://sns-topic-policy.json
```

---

## ⚡ 4. Create the S3 Event Notification

Now, tell S3 to trigger that SNS topic when a new object is uploaded.

Create a `s3-event-config.json`:

```json
{
  "TopicConfigurations": [
    {
      "Id": "UploadEventToSNS",
      "TopicArn": "arn:aws:sns:us-east-1:123456789012:s3-event-topic",
      "Events": ["s3:ObjectCreated:*"]
    }
  ]
}
```

Apply it:

```bash
aws s3api put-bucket-notification-configuration \
  --bucket ml-storage-w2d1-yourname \
  --notification-configuration file://s3-event-config.json
```

---

# 🧪 Test It!

Now upload a file:

```bash
aws s3 cp shared/datasets/titanic.csv s3://ml-storage-w2d1-yourname/data/test-upload.csv
```

✅ You should receive an email notification about the new object being created!

---

# 🧹 Cleanup Later

- Delete the SNS topic:
  ```bash
  aws sns delete-topic --topic-arn <ARN>
  ```
- Remove the S3 bucket notification (if needed).

---

## 🧹 Cleanup

```bash
aws s3 rb s3://ml-storage-w2d1-yourname --force
```

Delete any event notifications or test SNS topics if created.

---

# 🏁 Summary: Today’s Learning Outcomes

- Deep understanding of **S3 object lifecycle management**
- Hands-on **versioning**, **transition policies**, and **expiration rules**
- Real-world practice moving objects between **storage classes** to save cost
- Prepped for serverless event-driven architecture with basic triggers

---
