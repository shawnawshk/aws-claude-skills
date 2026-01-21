---
name: aws-serverless
description: This skill should be used when users ask to build, deploy, or optimize serverless applications on AWS. Trigger phrases include "create a Lambda function", "deploy my SAM app", "help me with serverless", "build an API backend", "set up EventBridge", "create a DynamoDB table", "sam init", "sam build", "sam deploy", "sam local invoke", "review my serverless project", "optimize Lambda performance", "reduce cold starts", "troubleshoot API Gateway", "set up event-driven architecture", "create a REST API", or "help me with AWS serverless development".
keywords:
  - aws
  - sam
  - lambda
  - serverless
  - api-gateway
  - rest-api
  - http-api
  - eventbridge
  - dynamodb
  - step-functions
  - sqs
  - sns
  - cloudformation
  - event-driven
  - infrastructure-as-code
  - deploy
allowed-tools: Read, Bash, Grep, Glob, Write, Edit
---

# AWS Serverless Development

Build production-ready serverless applications on AWS using the Serverless Application Model (SAM) and AWS best practices.

## CRITICAL: Always Verify with AWS Knowledge

**BEFORE providing guidance, ALWAYS verify uncertainty with AWS Knowledge MCP server:**

### When to Use AWS Knowledge MCP Server

**MANDATORY verification for:**
1. **New Features** - Check if service has new capabilities since your knowledge cutoff
2. **Runtime Versions** - Verify current Lambda runtime versions and deprecations
3. **Service Limits** - Confirm current quotas and limitations
4. **Regional Availability** - Check if service/feature is available in user's region
5. **Syntax Changes** - Verify SAM template syntax and CloudFormation resource types
6. **Best Practices** - Confirm current AWS recommendations haven't changed
7. **Service Updates** - Check for recent announcements or changes

**Always verify when:**
- User asks about "latest" or "new" features
- You're uncertain about specific configurations
- Recommending service integrations
- Discussing deprecated features
- Providing version-specific guidance
- User mentions a region other than us-east-1

### How to Verify

**Use AWS Knowledge MCP Server:**
```
Search AWS documentation for [specific topic]
What are the latest Lambda runtime versions?
Is [feature] available in [region]?
What are current best practices for [service]?
```

**Verification workflow:**
1. Receive question about AWS service/feature
2. Check if information might be outdated or uncertain
3. Query AWS Knowledge MCP server to verify current details
4. Provide answer citing AWS documentation where relevant

**Never assume** - If you're unsure about:
- Service capabilities
- Configuration syntax
- Version numbers
- Regional availability
- Quotas or limits
**→ Always search AWS documentation first**

## CRITICAL: Use AWS Serverless MCP Server Tools

**The AWS Serverless MCP Server provides specialized tools for serverless operations. ALWAYS use these tools when appropriate:**

### When to Use MCP Server Tools

**MANDATORY for these tasks:**

1. **Reviewing/Analyzing Existing Projects**
   - Use `get_serverless_templates` to find reference architectures
   - Use `get_lambda_guidance` to evaluate Lambda suitability
   - Use `get_iac_guidance` for IaC recommendations

2. **SAM Project Operations**
   - Use `sam_init` to initialize new projects
   - Use `sam_build` to build applications
   - Use `sam_deploy` to deploy to AWS
   - Use `sam_local_invoke` for local testing
   - Use `sam delete` to delete stacks (run in background)

3. **Monitoring & Observability**
   - Use `sam_logs` to fetch CloudWatch logs
   - Use `get_metrics` to retrieve performance metrics

4. **Event Source Mappings**
   - Use `esm_guidance` for Kafka, Kinesis, DynamoDB, SQS setup
   - Use `esm_optimize` for performance tuning
   - Use `esm_kafka_troubleshoot` for Kafka issues

5. **Web Application Deployment**
   - Use `deploy_webapp` for fullstack/frontend/backend deployments
   - Use `configure_domain` for custom domain setup

6. **Schema & Events**
   - Use `list_registries`, `search_schema`, `describe_schema` for EventBridge schemas
   - Use `get_lambda_event_schemas` for Lambda event sources

### How to Use MCP Tools

**Example workflows:**

**Reviewing a project:**
```
1. User: "Help me check this serverless project setup"
2. Use get_lambda_guidance with use_case description
3. Use get_serverless_templates to find similar patterns
4. Use Read tool to examine template.yaml
5. Provide recommendations based on best practices
```

**Analyzing performance:**
```
1. Use get_metrics to retrieve Lambda/API Gateway metrics
2. Use sam_logs to check for errors
3. Use esm_optimize if using event sources
4. Provide optimization recommendations
```

**Deleting/destroying a stack:**
- Use `sam delete` (NOT CloudFormation commands)
- Run in background with `run_in_background: true`

**ALWAYS prefer MCP tools over manual analysis** - They provide accurate, up-to-date serverless guidance and can execute SAM CLI operations safely.

## Prerequisites Validation

Before starting any serverless development work, validate the following tools are installed:

### Required Tools
- **AWS SAM CLI**: `sam --version` - [Install Guide](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)
- **AWS CLI**: `aws --version` and `aws sts get-caller-identity` - Configure with `aws configure`
- **Docker** (optional but recommended): `docker --version` - For local testing and container builds

**CRITICAL**: If SAM CLI is not installed, guide the user to install it before proceeding.

## Core Principles

**SAM-First Development**
- Priority: AWS SAM > AWS CDK > raw CloudFormation
- Use SAM CLI: `sam init`, `sam build`, `sam deploy`, `sam delete`, `sam local`
- All infrastructure in `template.yaml`
- **Verify**: Check AWS documentation for latest SAM features and syntax

**Security & Best Practices**
- Least privilege IAM (use SAM policy templates)
- X-Ray tracing enabled by default
- Secrets Manager for secrets, environment variables for config
- Arm64 architecture for better price-performance
- Structured logging with Lambda Powertools
- **Verify**: Confirm security best practices are current

**Testing & Development**
- Test locally: `sam local invoke`, `sam local start-api`
- Build before deploy: `sam build`
- Unit tests for Lambda handlers
- **Verify**: Check for new testing features or tools

## Quick Start

1. **Validate prerequisites** (tools above)
2. **Initialize**: `sam init` - choose runtime and template
3. **Build locally**: `sam build`
4. **Test locally**: `sam local invoke` or `sam local start-api`
5. **Deploy**: `sam deploy --guided`

**Before recommending runtimes**: Verify current Lambda runtime versions via AWS Knowledge MCP

## Long-Running Operations: Use Background Tasks

**IMPORTANT**: SAM deployments can take several minutes. Use background tasks for long-running operations.

### When to Use Background Tasks

**Always use background tasks for:**
- ✅ `sam deploy` - Deployments typically take 2-10 minutes
- ✅ `sam delete` - Stack deletion takes 2-5 minutes
- ✅ `sam build --use-container` - Container builds can be slow
- ✅ `sam sync --watch` - Long-running watch mode
- ⚠️ `sam local start-api` - Only if user wants to continue working

**DO NOT use background for:**
- ❌ `sam init` - Quick, needs immediate feedback
- ❌ `sam validate` - Fast validation
- ❌ `sam local invoke` - Quick single invocation

### How to Run Background Tasks

When running `sam deploy` or other long operations:

```bash
# Use run_in_background parameter in Bash tool
sam deploy --guided
```

**Tell the user:**
"I'm running `sam deploy` in the background. This will take a few minutes. You'll be notified when it completes, and you can continue working in the meantime."

**After starting background task:**
- User can continue other work
- Monitor progress if needed
- Will be notified on completion
- Can check output later with task ID

## Reference Documentation

Detailed patterns and best practices organized by topic:

- [SAM Project Initialization](reference/sam-init-workflow.md) - Creating new serverless projects
- [Build & Deploy](reference/sam-build-deploy.md) - Building and deploying applications
- [Lambda Best Practices](reference/lambda-best-practices.md) - Function patterns, performance, handlers
- [Lambda Durable Functions](reference/lambda-durable-functions.md) - Long-running workflows with Step Functions
- [API Gateway Patterns](reference/api-gateway-patterns.md) - REST/HTTP APIs, auth, CORS
- [API Gateway Response Streaming](reference/api-gateway-streaming.md) - Progressive response delivery, large payloads
- [Event-Driven Patterns](reference/event-driven-patterns.md) - EventBridge, SQS, SNS, S3, DynamoDB Streams
- [DynamoDB Integration](reference/dynamodb-patterns.md) - Single-table design, access patterns
- [Local Testing](reference/local-testing.md) - Local development and debugging
- [Security & IAM](reference/security-iam.md) - IAM policies, least privilege, secrets
- [Performance Optimization](reference/performance-optimization.md) - Cold start reduction, memory tuning

**Note**: Reference files contain patterns based on knowledge cutoff. Always verify critical details with AWS Knowledge MCP server for latest information.

## MCP Server Integration

This skill integrates with two MCP servers (configured in `.mcp.json`):

### AWS Serverless MCP Server (`awslabs.aws-serverless-mcp-server`)
**Purpose**: Execute SAM CLI commands via natural language

**Use for:**
- Building applications: "Build my SAM application"
- Deploying: "Deploy with SAM"
- Local testing: "Start local API server"
- Template validation: "Validate my SAM template"

**Capabilities**: Build, deploy, validate templates, local testing orchestration

### AWS Knowledge MCP Server (`aws-knowledge-mcp-server`)
**Purpose**: Search and verify AWS documentation in real-time

See [CRITICAL: Always Verify with AWS Knowledge](#critical-always-verify-with-aws-knowledge) section above for detailed usage guidance.

## Important Reminders

✅ **DO**:
- Verify uncertain information with AWS Knowledge MCP
- Check for new features before recommending solutions
- Confirm regional availability
- Verify runtime versions and deprecations
- Check current best practices
- Search documentation for syntax verification

❌ **DON'T**:
- Assume information is current without verification
- Recommend deprecated features
- Provide version numbers from memory
- Ignore regional availability concerns
- Skip verification when user mentions "latest" or "new"

**When in doubt, search AWS documentation using the MCP server.**
