# AWS Claude Skills

A Claude Code plugin marketplace providing comprehensive AWS expertise and serverless development capabilities.

## Installation

### 1. Add the Marketplace

```bash
/plugin marketplace add shawnawshk/aws-claude-skills
```

### 2. Install Plugins

Install the plugins you need:

```bash
# AWS expert plugin
/plugin install aws-expert

# Serverless development plugin
/plugin install serverless-dev
```

### 3. Restart Claude Code

Restart Claude Code to load the new plugin.

## Available Plugins

### aws-expert

An AWS specialist plugin that provides expert-level AWS guidance using the AWS Knowledge MCP server.

**Agent:** `aws-expert:aws-knowledge`

#### Features

- **AWS Documentation Search** - Search and retrieve official AWS documentation
- **Regional Availability** - Check which AWS regions support specific services and features
- **Solution Evaluation** - Assess AWS architectures for feasibility, security, cost, and performance
- **Best Practices** - Get AWS Well-Architected Framework recommendations
- **Troubleshooting** - Debug AWS issues with documentation-backed solutions

#### Usage

```bash
@"aws-expert:aws-knowledge (agent)" Which regions support x8aedz EC2 instance type?
```

```bash
@"aws-expert:aws-knowledge (agent)" What are the best practices for S3 bucket security?
```

```bash
@"aws-expert:aws-knowledge (agent)" What's Lambda durable functions?
```

#### MCP Server

This plugin uses the AWS Knowledge MCP server:
- **URL:** `https://knowledge-mcp.global.api.aws`
- **Tools:** `aws___search_documentation`, `aws___read_documentation`, `aws___get_regional_availability`

### serverless-dev

Build production-ready serverless applications on AWS using AWS SAM, Lambda, API Gateway, EventBridge, DynamoDB, and other serverless services.

**Skill:** `aws-serverless-dev:aws-serverless`

#### Features

- **AWS SAM** - Initialize, build, and deploy serverless applications
- **Lambda Functions** - Best practices, performance optimization, and durable workflows
- **API Gateway** - REST/HTTP APIs with authentication, CORS, and response streaming
- **Event-Driven Architecture** - EventBridge, SQS, SNS, S3 events, DynamoDB Streams
- **DynamoDB** - Integration patterns and single-table design
- **Local Testing** - SAM local invoke and API testing
- **Security & IAM** - Least privilege policies and secrets management
- **Performance** - Cold start reduction, memory tuning, cost optimization

#### Prerequisites

- **AWS SAM CLI** - Install from [AWS SAM CLI documentation](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)
- **AWS CLI** - Configured with valid credentials (`aws configure`)
- **Docker** (optional) - For local testing and container builds

#### Usage Examples

```bash
Create a new serverless API with Python Lambda functions and DynamoDB
```

```bash
Add an EventBridge rule that triggers a Lambda function when orders are placed
```

```bash
Set up API Gateway response streaming for this Lambda function
```

```bash
Build and deploy this application using SAM
```

#### MCP Servers

This plugin uses two MCP servers:
- **awslabs.aws-serverless-mcp-server** - SAM CLI operations and deployments
- **aws-knowledge-mcp-server** - AWS documentation verification

## Plugin Structure

```
aws-claude-skills/
├── .claude-plugin/
│   └── marketplace.json           # Marketplace manifest
├── .mcp.json                      # Shared MCP server configuration
├── plugins/
│   ├── aws-expert/                # AWS Expert plugin
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json        # Plugin manifest
│   │   └── agents/
│   │       └── aws-knowledge.md   # Agent definition
│   └── serverless-dev/            # Serverless Development plugin
│       ├── .claude-plugin/
│       │   └── plugin.json        # Plugin manifest
│       ├── skills/
│       │   └── aws-serverless/    # Serverless skill with reference docs
│       ├── README.md              # Plugin documentation
│       └── INSTALL.sh             # Installation helper
├── CLAUDE.md
└── README.md
```

## Requirements

### For all plugins
- Claude Code v2.0+
- Internet access (for AWS Knowledge MCP server)

### For serverless-dev plugin
- AWS SAM CLI (install from [AWS docs](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html))
- AWS CLI with configured credentials
- Docker (optional, for local testing)

## License

MIT

## Author

Shawn Zhang
