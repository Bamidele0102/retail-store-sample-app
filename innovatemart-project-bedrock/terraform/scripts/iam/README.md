# GitHub Actions Terraform Plan IAM Policy

This folder contains a least-privilege IAM policy that lets the GitHub Actions OIDC role run `terraform plan` successfully, including reading Secrets Manager values used in the plan...

## Files

- `terraform-plan-readonly-policy.json` – Grants read-only access to infrastructure metadata and Secrets Manager values under `retail/*` in `us-east-1`.

## How to attach to your OIDC role

1. Create the policy:

   - Console: IAM → Policies → Create policy → JSON → paste the file contents → Name e.g. `InnovateMartTerraformPlanReadOnly`
   - Or CLI:

```bash
aws iam create-policy \
  --policy-name InnovateMartTerraformPlanReadOnly \
  --policy-document file://innovatemart-project-bedrock/terraform/scripts/iam/terraform-plan-readonly-policy.json
```

2. Attach policy to your GitHub OIDC role used by Actions (example role name `innovate-mart-github-oidc`):

```bash
ROLE_NAME=innovate-mart-github-oidc
POLICY_ARN=$(aws iam list-policies --query "Policies[?PolicyName=='InnovateMartTerraformPlanReadOnly'].Arn|[0]" --output text)
ROLE_ARN=$(aws iam get-role --role-name "$ROLE_NAME" --query Role.Arn --output text)
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$POLICY_ARN"
echo "Attached $POLICY_ARN to $ROLE_ARN"
```

3. Confirm the trust policy on the role allows your repo and branches/PRs.

4. Re-run the failing plan/apply workflow.

## Notes

- The Secrets Manager resource scope is limited to `arn:aws:secretsmanager:us-east-1:474422890464:secret:retail/*`. Adjust the account/region/prefix if you changed them.
- If you add more secret names or regions, update the Resource accordingly.
