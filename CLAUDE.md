# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **aws-claude-skills** marketplace for Claude Code plugins. It provides AWS-related plugins including:
- **aws-expert:aws-knowledge**: An AWS specialist agent that answers AWS-related questions using the AWS Knowledge MCP server

## Architecture

```
aws-claude-skills/
├── .claude-plugin/
│   └── marketplace.json     # Marketplace manifest listing all plugins
├── plugins/
│   └── aws-expert/          # AWS Expert plugin
│       ├── .claude-plugin/
│       │   └── plugin.json  # Plugin manifest
│       ├── .mcp.json        # MCP server configuration
│       ├── agents/
│       │   └── aws-knowledge.md  # Agent definition
│       └── CLAUDE.md        # Plugin documentation
├── CLAUDE.md                # This file
└── README.md                # User-facing documentation
```

## Installing This Marketplace

```bash
/plugin marketplace add shawnawshk/aws-claude-skills

```

Then install the aws-expert plugin:
```bash
/plugin install aws-expert
```

## Plugin: aws-expert

### Features
- Uses AWS Knowledge MCP server to search and retrieve AWS documentation
- Answers AWS service questions and checks regional availability
- Evaluates solution feasibility (security, cost, performance)
- Finds AWS best practices and troubleshoots issues

### MCP Server Dependency
- Server: `aws-knowledge-mcp-server`
- URL: `https://knowledge-mcp.global.api.aws`
