# GitHub Actions Terraform plan permissions

The GitHub Actions workflows assume the IAM role shown in your job logs (e.g. `innovate-mart-github-oidc/GitHubActions`). Your plan failed due to missing read-only permissions for AWS APIs that Terraform uses during `plan`.

This folder includes a least-privilege policy `terraform-plan-readonly-policy.json` to attach to that role.

## What the policy allows

- Read-only access to: EC2 Describe*, EKS Describe/List, IAM Get/List, RDS Describe*, CloudWatch Logs/Metrics read
- Secrets Manager Describe/List for secrets under the `retail/*` path
- DynamoDB Describe/List and DescribeContinuousBackups for the `carts` table and its GSIs
- ACM and Route53 read-only

It does not allow any write/mutate operations.

## How to attach

1. Find the role name/ARN from a failed workflow log: look for `Assumed role` line or the error string like:
   `User: arn:aws:sts::ACCOUNT:assumed-role/innovate-mart-github-oidc/GitHubActions ...`
   In this example, the role name is `innovate-mart-github-oidc` and the session name is `GitHubActions`.

2. Create the policy once:

   ```bash
   aws iam create-policy \
     --policy-name InnovateMartTerraformPlanReadOnly \
     --policy-document file://terraform-plan-readonly-policy.json
   ```

   Save the returned `Policy.Arn` (e.g. `arn:aws:iam::123456789012:policy/InnovateMartTerraformPlanReadOnly`).

3. Attach to the assumed role (replace ROLE_NAME and POLICY_ARN):

   ```bash
   ROLE_NAME=innovate-mart-github-oidc
   POLICY_ARN=arn:aws:iam::123456789012:policy/InnovateMartTerraformPlanReadOnly
   aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$POLICY_ARN"
   ```

If your CI uses a different role name, adjust `ROLE_NAME` accordingly.

## Re-run the plan

After attaching, re-run the "Terraform plan (sandbox and operators)" workflow from GitHub Actions. It should pass the AWS reads that previously failed.

If you later see new read denials, add the specific read action to this policy and re-attach; keep it read-only.
