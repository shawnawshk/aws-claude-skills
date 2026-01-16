# AWS Claude Skills

A Claude Code plugin marketplace providing AWS expertise through the AWS Knowledge MCP server.

## Installation

### 1. Add the Marketplace

```bash
/plugin marketplace add shawnawshk/aws-claude-skills
```

### 2. Install the Plugin

```bash
/plugin install aws-expert
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
@"aws-expert:aws-knowledge (agent)" Evaluate this architecture: Lambda + API Gateway + DynamoDB for a serverless API
```

#### MCP Server

This plugin uses the AWS Knowledge MCP server:
- **URL:** `https://knowledge-mcp.global.api.aws`
- **Tools:** `aws___search_documentation`, `aws___read_documentation`, `aws___get_regional_availability`

## Plugin Structure

```
aws-claude-skills/
├── .claude-plugin/
│   └── marketplace.json      # Marketplace manifest
├── plugins/
│   └── aws-expert/           # AWS Expert plugin
│       ├── .claude-plugin/
│       │   └── plugin.json   # Plugin manifest
│       ├── .mcp.json         # MCP server configuration
│       └── agents/
│           └── aws-knowledge.md  # Agent definition
├── CLAUDE.md
└── README.md
```

## Requirements

- Claude Code v2.0+
- Internet access (for AWS Knowledge MCP server)

## License

MIT

## Author

Shawn Zhang
