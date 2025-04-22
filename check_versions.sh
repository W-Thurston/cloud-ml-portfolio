#!/bin/bash

echo "🔍 Checking Cloud CLI & Tool Versions..."

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

check_version() {
    local cmd=$1
    local name=$2

    if command -v $cmd &> /dev/null
    then
        echo -e "${GREEN}✔ $name installed:${NC}"
        $cmd --version 2>/dev/null || $cmd version
    else
        echo -e "${RED}✘ $name not installed.${NC} Please install it before continuing."
    fi
    echo ""
}

# Check Python & virtualenv
echo -e "${GREEN}✔ Python version:${NC}"
python3 --version
echo ""

# Check cloud CLIs
check_version aws "AWS CLI"
check_version az "Azure CLI"
check_version gcloud "GCP CLI"
check_version terraform "Terraform"
check_version docker "Docker (optional)"
