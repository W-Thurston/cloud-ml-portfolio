init:
	@echo "Bootstrapping environment..."
	python3 -m venv 7clouds-env
	source 7clouds-env/bin/activate && pip install -r requirements.txt

clean:
	@echo "Cleaning up resources..."
	cd shared/terraform && terraform destroy -auto-approve

tf-plan:
	cd shared/terraform && terraform plan

tf-apply:
	cd shared/terraform && terraform apply -auto-approve
