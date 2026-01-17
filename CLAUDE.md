# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **aws-claude-skills** marketplace for Claude Code plugins. It provides AWS-related plugins including:
- **aws-expert**: An AWS specialist agent that answers AWS-related questions using the AWS Knowledge MCP server
- **serverless-dev**: Build production-ready serverless applications using AWS SAM, Lambda, API Gateway, and other AWS serverless services

## Architecture

```
aws-claude-skills/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace manifest listing all plugins
├── .mcp.json                # Shared MCP server configuration
├── plugins/
│   ├── aws-expert/          # AWS Expert plugin
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json  # Plugin manifest
│   │   └── agents/
│   │       └── aws-knowledge.md  # Agent definition
│   └── serverless-dev/      # Serverless Development plugin
│       ├── .claude-plugin/
│       │   └── plugin.json  # Plugin manifest
│       ├── skills/
│       │   └── aws-serverless/  # Serverless skill with reference docs
│       ├── README.md        # Plugin documentation
│       └── INSTALL.sh       # Installation helper
├── CLAUDE.md                # This file
└── README.md                # User-facing documentation
```

## Installing This Marketplace

```bash
/plugin marketplace add shawnawshk/aws-claude-skills
```

Then install the plugins you need:
```bash
# Install AWS expert plugin
/plugin install aws-expert

# Install serverless development plugin
/plugin install serverless-dev
```

## Plugin: aws-expert

### Features
- Uses AWS Knowledge MCP server to search and retrieve AWS documentation
- Answers AWS service questions and checks regional availability
- Evaluates solution feasibility (security, cost, performance)
- Finds AWS best practices and troubleshoots issues

### MCP Server Dependencies
- `aws-knowledge-mcp-server` - AWS documentation search and retrieval

## Plugin: serverless-dev

### Features
- Initialize, build, and deploy SAM applications
- Lambda function best practices and patterns
- API Gateway REST/HTTP API configuration with response streaming
- Event-driven architecture with EventBridge, SQS, SNS, DynamoDB Streams
- DynamoDB integration and patterns
- Lambda Durable Functions for long-running workflows
- Local testing with SAM CLI
- Security and IAM best practices
- Performance optimization and cost management

### Prerequisites
- AWS SAM CLI installed and configured
- AWS CLI configured with valid credentials
- Docker (optional, for container builds and local testing)

### MCP Server Dependencies
- `awslabs.aws-serverless-mcp-server` - SAM CLI operations and serverless deployments
- `aws-knowledge-mcp-server` - AWS documentation verification

## MCP Servers

Both plugins share MCP server configurations defined in `.mcp.json`:

### aws-knowledge-mcp-server
- Type: HTTP
- URL: `https://knowledge-mcp.global.api.aws`
- Used by: aws-expert, serverless-dev
- Purpose: Search and retrieve AWS documentation

### awslabs.aws-serverless-mcp-server
- Type: Command
- Command: `uvx awslabs.aws-serverless-mcp-server@latest`
- Used by: serverless-dev
- Purpose: SAM CLI operations and serverless application management
