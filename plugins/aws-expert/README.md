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

### Quick Documentation Lookup

Use the `/aws-docs` command for quick AWS documentation searches:

```
/aws-docs Lambda memory limits
/aws-docs S3 bucket policy examples
/aws-docs Is Bedrock available in eu-west-1
/aws-docs EventBridge vs SNS comparison
```

### Conversational AWS Help

The plugin provides an `aws-knowledge` agent that automatically activates for AWS-related questions:

```
Which regions support x8g EC2 instance types?
What are S3 bucket security best practices?
Is EventBridge Scheduler available in eu-west-1?
Why is my Lambda function timing out when connecting to RDS?
```

### When to Use Each

| Use Case | Recommended |
|----------|-------------|
| Quick fact lookup | `/aws-docs` command |
| Concept verification | `/aws-docs` command |
| Architecture discussion | Agent (automatic) |
| Troubleshooting help | Agent (automatic) |
| Regional availability | Either |

## MCP Server

This plugin uses the AWS Knowledge MCP server (`aws-knowledge-mcp-server`) to:
- Search AWS documentation in real-time
- Verify current service capabilities
- Check regional availability
- Retrieve best practices and troubleshooting guides

The MCP server is hosted by AWS at `https://knowledge-mcp.global.api.aws` - no local installation required.

## License

MIT
