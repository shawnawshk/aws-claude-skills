# AWS Serverless Development - Claude Plugin

A comprehensive Claude Code plugin for building production-ready serverless applications on AWS using SAM (Serverless Application Model).

## What This Plugin Provides

This plugin gives Claude instant expertise in:

- **AWS SAM** - Initialize, build, and deploy serverless applications
- **Lambda Functions** - Best practices for handlers, performance, and error handling
- **API Gateway** - REST and HTTP APIs with authentication, CORS, and response streaming
- **Event-Driven Architecture** - EventBridge, SQS, SNS, S3 events, DynamoDB Streams
- **DynamoDB** - Single-table design, access patterns, and optimization
- **Lambda Durable Functions** - Long-running workflows with AWS Step Functions integration
- **Local Testing** - SAM local invoke and API testing
- **Security & IAM** - Least privilege policies, secrets management, encryption
- **Performance Optimization** - Cold start reduction, memory tuning, cost optimization

## Prerequisites

This plugin requires the following tools to be installed:

- **AWS SAM CLI** - Install from https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html
- **AWS CLI** - Configured with valid credentials (`aws configure`)
- **Docker** (optional but recommended) - For local testing and container builds

The plugin will validate these dependencies when first used.

## Installation

### Local Development (Testing This Plugin)

If you're testing this plugin locally:

```bash
# Add as local marketplace
claude plugin marketplace add /home/coder/serverless-dev

# Install from local marketplace
claude plugin install aws-serverless-dev@local-dev
```

### Production Installation (From GitHub)

Once published:

```bash
claude plugin install aws-serverless-dev
```

## Usage

Once installed, Claude will automatically use this plugin when you mention serverless-related topics:

- "Create a Lambda function"
- "Build a serverless API"
- "Set up DynamoDB table"
- "Deploy with SAM"
- "Add EventBridge rule"
- "Configure API Gateway response streaming"
- "Set up Lambda Durable Functions workflow"

## Example Prompts

**Initialize a new project:**
```
Create a new serverless API with Python Lambda functions and DynamoDB
```

**Add functionality:**
```
Add an EventBridge rule that triggers a Lambda function when orders are placed
```

**Configure response streaming:**
```
Set up API Gateway response streaming for this Lambda function to handle large AI responses
```

**Build a workflow:**
```
Create a long-running order processing workflow using Lambda Durable Functions
```

**Optimize performance:**
```
Optimize this Lambda function for better cold start performance
```

**Deploy:**
```
Build and deploy this application using SAM
```

## Plugin Structure

```
aws-serverless-dev/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   └── marketplace.json         # Local marketplace config (for development)
├── skills/
│   └── aws-serverless/
│       ├── SKILL.md             # Main skill with core guidance
│       └── reference/           # Detailed reference documentation
│           ├── sam-init-workflow.md
│           ├── sam-build-deploy.md
│           ├── lambda-best-practices.md
│           ├── lambda-durable-functions.md
│           ├── api-gateway-patterns.md
│           ├── api-gateway-streaming.md
│           ├── event-driven-patterns.md
│           ├── dynamodb-patterns.md
│           ├── local-testing.md
│           ├── security-iam.md
│           └── performance-optimization.md
├── .mcp.json                    # MCP server configuration
├── INSTALL.sh                   # Installation helper script
└── README.md                    # This file
```

## MCP Servers

This plugin integrates with two MCP servers for enhanced capabilities:

### 1. AWS Serverless MCP Server
(`awslabs.aws-serverless-mcp-server`)

- Provides tools for SAM CLI operations
- Enables natural language serverless deployments
- Requires: `uvx` (installed via `pip install uv`)

### 2. AWS Knowledge MCP Server
(`aws-knowledge-mcp-server`)

- Search and read AWS documentation in real-time
- Verify current runtime versions and features
- Check regional availability
- Get latest best practice recommendations
- Hosted by AWS, no installation required

The MCP servers are configured in `.mcp.json` and will be automatically used by Claude Code.

## Key Features

### AWS Knowledge Verification
The plugin automatically verifies uncertain information with AWS documentation:
- Runtime versions and deprecations
- New features and capabilities
- Regional availability
- Service limits and quotas
- Best practices updates

### Background Task Management
Long-running operations run in the background:
- `sam deploy` - Deployments take 2-10 minutes
- `sam delete` - Stack deletion takes 2-5 minutes
- `sam build --use-container` - Container builds
- `sam sync --watch` - Long-running watch mode

Users can continue working while deployments complete.

## Reference Documentation

The plugin includes detailed reference documentation:

| Topic | Description |
|-------|-------------|
| **sam-init-workflow.md** | Project initialization patterns |
| **sam-build-deploy.md** | Build and deployment workflows (with background tasks) |
| **lambda-best-practices.md** | Lambda function patterns and optimization |
| **lambda-durable-functions.md** | Long-running workflows with Step Functions |
| **api-gateway-patterns.md** | API Gateway REST/HTTP API configuration |
| **api-gateway-streaming.md** | Response streaming for large payloads and real-time data |
| **event-driven-patterns.md** | Event-driven architectures (EventBridge, SQS, SNS) |
| **dynamodb-patterns.md** | DynamoDB integration patterns |
| **local-testing.md** | Local development and testing |
| **security-iam.md** | Security and IAM best practices |
| **performance-optimization.md** | Performance tuning and cost optimization |

## Best Practices Included

- **Security**: SAM policy templates for least privilege, secrets management
- **Performance**: Arm64 architecture for 20% cost savings, cold start optimization
- **Observability**: X-Ray tracing, structured logging with Lambda Powertools
- **Reliability**: Error handling and retry strategies, Lambda Durable Functions
- **Cost Optimization**: Memory tuning, appropriate timeout configuration
- **Modern Patterns**: Response streaming, event-driven architectures

## Development

### Testing Changes Locally

1. Make your changes to skill files or reference documentation
2. Reinstall the plugin:
   ```bash
   claude plugin uninstall aws-serverless-dev@local-dev
   claude plugin install aws-serverless-dev@local-dev
   ```
3. Test with Claude Code

### Adding New Reference Documentation

1. Create new file in `skills/aws-serverless/reference/`
2. Add verification warning at the top
3. Update `SKILL.md` to reference the new file
4. Reinstall plugin to test

## License

MIT License - See LICENSE file for details

## Support

For issues or questions:
- Open an issue in this repository
- Check AWS SAM documentation: https://docs.aws.amazon.com/serverless-application-model/
- Review AWS Lambda best practices: https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html
