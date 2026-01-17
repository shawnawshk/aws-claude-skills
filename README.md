# AWS Claude Skills

Claude Code plugins for AWS expertise and serverless development.

## Installation

### 1. Add the Marketplace

```bash
/plugin marketplace add shawnawshk/aws-claude-skills
```

### 2. Install Plugins

```bash
# AWS expert plugin
/plugin install aws-expert

# Serverless development plugin
/plugin install serverless-dev
```

## Plugins

### aws-expert

AWS specialist plugin providing expert-level AWS guidance using the AWS Knowledge MCP server.

**Features:**
- **AWS Documentation Search** - Search and retrieve official AWS documentation
- **Regional Availability** - Check which AWS regions support specific services and features
- **Solution Evaluation** - Assess AWS architectures for feasibility, security, cost, and performance
- **Best Practices** - Get AWS Well-Architected Framework recommendations
- **Troubleshooting** - Debug AWS issues with documentation-backed solutions

**Usage:**
```
@"aws-expert:aws-knowledge (agent)" Which regions support x8g EC2 instance types?
@"aws-expert:aws-knowledge (agent)" What are S3 bucket security best practices?
```

### serverless-dev

Build production-ready serverless applications on AWS using AWS SAM, Lambda, API Gateway, EventBridge, DynamoDB, and other serverless services.

**Prerequisites:**
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)
- AWS CLI configured with credentials (`aws configure`)
- Docker (optional, for local testing)

**Features:**
- **AWS SAM** - Initialize, build, and deploy serverless applications
- **Lambda Functions** - Best practices, performance optimization, and durable workflows
- **API Gateway** - REST/HTTP APIs with authentication, CORS, and response streaming
- **Event-Driven Architecture** - EventBridge, SQS, SNS, S3 events, DynamoDB Streams
- **DynamoDB** - Integration patterns and single-table design
- **Local Testing** - SAM local invoke and API testing
- **Security & IAM** - Least privilege policies and secrets management
- **Performance** - Cold start reduction, memory tuning, cost optimization

**Usage:**
```
Create a serverless API with Python Lambda and DynamoDB
Add an EventBridge rule that triggers a Lambda function when orders are placed
Set up API Gateway response streaming for this Lambda function
Build and deploy this application using SAM
```

## Requirements

- Claude Code v2.0+
- For serverless-dev: AWS SAM CLI and AWS CLI with configured credentials

## License

MIT - Shawn Zhang
