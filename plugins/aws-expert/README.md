# AWS Expert Plugin

AWS specialist plugin providing expert-level AWS guidance using the AWS Knowledge MCP server.

## Features

- **AWS Documentation Search** - Search and retrieve official AWS documentation
- **Regional Availability** - Check which AWS regions support specific services and features
- **Solution Evaluation** - Assess AWS architectures for feasibility, security, cost, and performance
- **Best Practices** - Get AWS Well-Architected Framework recommendations
- **Troubleshooting** - Debug AWS issues with documentation-backed solutions

## Installation

```bash
# Add the marketplace
/plugin marketplace add shawnawshk/aws-claude-skills

# Install this plugin
/plugin install aws-expert
```

## Usage

The plugin provides an `aws-knowledge` agent that automatically activates for AWS-related questions:

```
Which regions support x8g EC2 instance types?
What are S3 bucket security best practices?
Is EventBridge Scheduler available in eu-west-1?
Why is my Lambda function timing out when connecting to RDS?
```

You can also explicitly invoke the agent:

```
@"aws-expert:aws-knowledge (agent)" What are the current Lambda runtime versions?
```

## MCP Server

This plugin uses the AWS Knowledge MCP server (`aws-knowledge-mcp-server`) to:
- Search AWS documentation in real-time
- Verify current service capabilities
- Check regional availability
- Retrieve best practices and troubleshooting guides

The MCP server is hosted by AWS at `https://knowledge-mcp.global.api.aws` - no local installation required.

## License

MIT
