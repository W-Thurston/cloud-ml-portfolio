#!/bin/bash

# Shared config
MILESTONE="Week 1 – Cloud Setup"
LABEL="Week 1"

# Create issues
gh issue create --title "Scaffold cloud-ml-portfolio repo directory" \
  --body "Set up aws/, gcp/, azure/ folders, shared/, virtualenv, and .gitignore. Add README.md and Makefile." \
  --label "$LABEL" --milestone "$MILESTONE"

gh issue create --title "Install and verify CLI tools" \
  --body "Install and run version checks for: AWS CLI, Azure CLI, GCP CLI, Terraform, Docker, Python." \
  --label "$LABEL" --milestone "$MILESTONE"

gh issue create --title "Setup Python virtualenv + install core packages" \
  --body "Create 7clouds-env, install boto3, azure-storage-blob, google-cloud-storage, pandas, scikit-learn, etc." \
  --label "$LABEL" --milestone "$MILESTONE"

gh issue create --title "Configure GitHub Actions and pre-commit hooks" \
  --body "Add .pre-commit-config.yaml, pyproject.toml, .flake8, and install hooks. Verify auto-formatting works." \
  --label "$LABEL" --milestone "$MILESTONE"

gh issue create --title "Provision cloud notebooks (Terraform)" \
  --body "Deploy SageMaker Studio, Azure ML Workspace, and Vertex AI Workbench with Terraform modules." \
  --label "$LABEL" --milestone "$MILESTONE"

gh issue create --title "Load Titanic dataset into cloud object storage" \
  --body "Push Titanic dataset to S3, Azure Blob, and GCS buckets." \
  --label "$LABEL" --milestone "$MILESTONE"

gh issue create --title "Run basic EDA notebook in each platform" \
  --body "Launch cloud notebook and run a first-pass analysis: nulls, value counts, basic visualization." \
  --label "$LABEL" --milestone "$MILESTONE"

gh issue create --title "Automate cleanup for provisioned resources" \
  --body "Use Terraform destroy or CLI scripts to remove cloud resources daily to avoid cost leaks." \
  --label "$LABEL" --milestone "$MILESTONE"

gh issue create --title "Complete Week 1 wrap-up quiz + Markdown progress tracker" \
  --body "Answer quiz questions, generate progress map (`week_1_day_5_progress_map.md`) and commit to GitHub." \
  --label "$LABEL" --milestone "$MILESTONE"
