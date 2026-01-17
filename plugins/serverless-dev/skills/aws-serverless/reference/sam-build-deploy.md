# SAM Build and Deploy Workflow

> **⚠️ IMPORTANT**: SAM deployments take 2-10 minutes. Always run `sam deploy` as a **background task** so users can continue working. Use the `run_in_background` parameter in the Bash tool.

## Building Applications

### Basic Build
```bash
sam build
```

### Build with Container (Recommended for Dependencies)
```bash
sam build --use-container
```

### Build Specific Function
```bash
sam build MyFunction
```

## Deployment

### ⚠️ CRITICAL: Run Deployments as Background Tasks

**SAM deployments are long-running operations (2-10 minutes).** Always use background tasks:

```bash
# Use run_in_background parameter in Bash tool
sam deploy --guided
```

**Tell the user immediately:**
"I'm running `sam deploy` in the background. This typically takes 5-10 minutes. You'll be notified when the deployment completes, and you can continue working in the meantime."

### Guided Deployment (First Time)
```bash
# ALWAYS run in background with run_in_background=true
sam deploy --guided
```

**Prompts during guided deployment:**
- Stack name
- AWS Region
- Confirm changes before deploy (Y/n)
- Allow SAM CLI IAM role creation (Y/n)
- Function may not have authorization defined (Y/n)
- Save arguments to samconfig.toml (Y/n)

This creates `samconfig.toml` with deployment settings for future deployments.

### Subsequent Deployments
```bash
# ALWAYS run in background
sam deploy
```

Uses saved configuration from `samconfig.toml`.

### Deploy to Specific Environment
```bash
# ALWAYS run in background
sam deploy --config-env prod
```

### Background Task Best Practices

**When to use background tasks:**
- ✅ `sam deploy` (any variant) - ALWAYS
- ✅ `sam delete` - ALWAYS (takes 2-5 minutes)
- ✅ `sam build --use-container` - Takes 2-5 minutes
- ✅ `sam sync --watch` - Long-running watch mode
- ⚠️ `sam local start-api` - If user wants to continue working

**When NOT to use background:**
- ❌ `sam init` - Quick, needs immediate feedback
- ❌ `sam validate` - Fast validation (seconds)
- ❌ `sam local invoke` - Quick single invocation

**Monitoring background tasks:**
- User will be notified automatically on completion
- Output includes deployment status and stack outputs
- Errors will be shown in notification
- Can check task status if needed

## samconfig.toml Structure

```toml
version = 0.1

[default.deploy.parameters]
stack_name = "my-app"
s3_bucket = "aws-sam-cli-managed-default-samclisourcebucket"
s3_prefix = "my-app"
region = "us-east-1"
capabilities = "CAPABILITY_IAM"
parameter_overrides = "Environment=dev"

[prod.deploy.parameters]
stack_name = "my-app-prod"
region = "us-east-1"
capabilities = "CAPABILITY_IAM"
parameter_overrides = "Environment=prod"
```

## Deployment Best Practices

### Use Stack Outputs
```yaml
Outputs:
  ApiUrl:
    Description: API Gateway endpoint URL
    Value: !Sub "https://${ServerlessRestApi}.execute-api.${AWS::Region}.amazonaws.com/Prod/"
  FunctionArn:
    Description: Lambda Function ARN
    Value: !GetAtt MyFunction.Arn
```

### Enable Rollback Configuration
```yaml
DeploymentPreference:
  Type: Canary10Percent5Minutes
  Alarms:
    - !Ref CanaryErrorsAlarm
```

### Tag Resources
```yaml
Tags:
  Environment: !Ref Environment
  Application: my-app
  ManagedBy: SAM
```

## Validation Before Deploy

Always validate template:
```bash
sam validate
```

## Typical Deployment Timeline

Understanding deployment duration helps set user expectations:

**`sam build`:**
- Without container: 10-60 seconds (depends on dependencies)
- With `--use-container`: 2-5 minutes (first build), 30-120 seconds (subsequent)
- **Recommendation**: Run in background only if using `--use-container`

**`sam deploy`:**
- First deployment: 5-10 minutes
  - Creates S3 bucket
  - Uploads artifacts
  - Creates CloudFormation stack
  - Provisions all resources (Lambda, API Gateway, etc.)
- Subsequent deployments: 2-5 minutes
  - Uploads changed artifacts only
  - Updates stack with changes
- **Recommendation**: ALWAYS run in background

**`sam sync`:**
- Initial sync: Similar to first deploy (5-10 minutes)
- Watch mode updates: 30-60 seconds per change
- **Recommendation**: Run in background for watch mode

**`sam delete`:**
- Stack deletion: 2-5 minutes
  - Deletes resources in reverse dependency order
  - Removes Lambda, API Gateway, DynamoDB, etc.
  - Cleans up IAM roles
  - Deletes CloudFormation stack
- **Recommendation**: ALWAYS run in background

## Example: Complete Deployment Workflow with Background Tasks

```bash
# Step 1: Build (quick, no background needed)
sam build

# Step 2: Validate (quick, no background needed)
sam validate

# Step 3: Deploy (LONG - use background!)
# Tell user: "Running deployment in background, takes ~5 minutes"
sam deploy --guided
```

**Expected output notification (when complete):**
```
Successfully created/updated stack my-app in us-east-1

Stack Outputs:
- ApiUrl: https://abc123.execute-api.us-east-1.amazonaws.com/Prod/
- FunctionArn: arn:aws:lambda:us-east-1:123456789012:function:my-app-MyFunction-ABC123
```

## Cleanup

### ⚠️ CRITICAL: Run Stack Deletion as Background Task

**Stack deletion takes 2-5 minutes to delete all resources.** Always use background tasks:

```bash
# ALWAYS run in background with run_in_background=true
sam delete
```

**Tell the user immediately:**
"I'm running `sam delete` in the background. This will delete the CloudFormation stack and all associated resources. This typically takes 2-5 minutes. You'll be notified when the deletion completes."

**What happens during deletion:**
- CloudFormation deletes resources in reverse dependency order
- Lambda functions, API Gateway, DynamoDB tables removed
- S3 buckets (if not empty, may require manual cleanup)
- IAM roles and policies cleaned up
- Final stack deletion

**Monitoring deletion:**
- User will be notified automatically on completion
- Errors shown if resources can't be deleted (e.g., non-empty S3 buckets)
- Can check stack status if needed

**Example workflow:**
```bash
# User requests: "Delete this serverless application"

# Claude runs in background:
sam delete --stack-name my-app --region us-east-1 --no-prompts

# User message: "Deleting stack in background, takes ~3 minutes"
# [User continues working...]
# [3 minutes later] ✓ Stack deleted successfully
```
