# Terraform state bootstrap

This tiny stack creates the S3 bucket and DynamoDB table required by the S3 backend used in `envs/sandbox/backend.tf`.

Defaults match `eu-west-1`, bucket `innovatemart-terraform-state`, and DynamoDB table `terraform-locks`.

## Usage

From this folder:

```bash
terraform init
terraform apply -auto-approve
```

You can override defaults:

```bash
terraform apply -auto-approve \
  -var aws_region=eu-west-1 \
  -var state_bucket_name=innovatemart-terraform-state \
  -var lock_table_name=terraform-locks
```

After this, go back to `envs/sandbox` and run:

```bash
terraform init -upgrade
```

Note: The S3 backend shows a warning that `dynamodb_table` is deprecated in favor of `use_lockfile`. The existing env uses `dynamodb_table` for locking; keeping it is fine for now. If you want to update, switch to `use_lockfile = true` (but then you don’t need the DynamoDB table).