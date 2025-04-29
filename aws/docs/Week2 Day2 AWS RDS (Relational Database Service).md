# 📅 Week 2, Day 2 – AWS RDS (Relational Database Service)

---

## 🧠 Goal:

By the end of today you will:

- ✅ Deploy an **RDS** instance (PostgreSQL)
- ✅ Connect to the database using a local or cloud-based client
- ✅ Create tables + insert Titanic data (or a subset)
- ✅ Perform basic queries from a Jupyter notebook
- ✅ Understand cost optimization (serverless vs provisioned)
- ✅ Clean up everything to avoid database billing!

---

# 🛠️ Tools You'll Use:

- AWS CLI (`aws rds`)
- AWS Console (optional)
- `psycopg2` (Python PostgreSQL driver)
- Jupyter Notebook or standalone Python scripts
- SQL Basics (`CREATE TABLE`, `INSERT`, `SELECT`)

---

# 🚀 Step-by-Step Plan

---

## 📦 Step 1: Create an RDS PostgreSQL Database (Free Tier)

If you're staying within **AWS Free Tier**, we'll configure a very small db.t3.micro.

CLI:

```bash
aws rds create-db-instance \
  --db-instance-identifier ml-w2d2-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --allocated-storage 20 \
  --master-username adminuser \
  --master-user-password YourSecurePassword123 \
  --backup-retention-period 1 \
  --publicly-accessible \
  --region us-east-2
```

✅ Make sure you replace the `--master-user-password` with a strong password (and save it).

This will take about **5 minutes** to become available.

---

## 🧱 Step 2: Configure Security (Public Access)

If needed, go into:

> AWS Console → RDS → Databases → ml-w2d2-db → Connectivity & Security

✅ Make sure:

- Public access: **Yes**
- VPC security group allows PostgreSQL traffic (port 5432)

---

## 🧠 Step 3: Connect to Database via Python

Install the Python driver:

```bash
pip install psycopg2-binary
```

Python snippet (replace your endpoint):

```python
import psycopg2

conn = psycopg2.connect(
    host="your-db-endpoint.rds.amazonaws.com",
    port=5432,
    database="postgres",
    user="adminuser",
    password="YourSecurePassword123"
)

cur = conn.cursor()
cur.execute("SELECT version();")
print(cur.fetchone())
cur.close()
conn.close()
```

✅ If this prints the PostgreSQL version, your connection is live!

---

## 📝 Step 4: Create a Table + Insert Some Titanic Data

Create a table:

```sql
CREATE TABLE passengers (
    id SERIAL PRIMARY KEY,
    name TEXT,
    survived INT,
    pclass INT,
    sex TEXT,
    age FLOAT
);
```

Insert sample records (via Python or direct SQL):

```python
cur.execute("""
    INSERT INTO passengers (name, survived, pclass, sex, age) VALUES
    ('Mr. John Doe', 0, 3, 'male', 35),
    ('Mrs. Jane Doe', 1, 1, 'female', 28);
""")
conn.commit()
```

---

## 📄 Deliverable

Save your work under:

```bash
aws/databases/load_titanic_postgres.ipynb
```

or

```bash
aws/databases/load_titanic_postgres.py
```

✅ Push everything to GitHub once verified.

---

## 🧹 Cleanup

When done, **delete the database** to avoid charges:

```bash
aws rds delete-db-instance \
  --db-instance-identifier ml-w2d2-db \
  --skip-final-snapshot
```

✅ Database deletion takes ~5 minutes.

---

# 🏁 Summary: Today’s Learning Outcomes

- Deploying cloud-managed PostgreSQL
- Understanding free-tier RDS settings
- Practicing secure cloud database access
- Querying and loading basic datasets into cloud databases
- Cost-aware creation and deletion

---

# 📣 Notes:

- You won't use RDS for production ML directly, but you will often stage data there before ingestion into ML pipelines (ETL / feature engineering).
