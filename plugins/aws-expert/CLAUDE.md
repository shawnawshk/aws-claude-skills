# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an AWS Expert plugin for Claude Code that provides:
- **aws-expert agent**: An AWS specialist that answers AWS-related questions using the AWS Knowledge MCP server

## Architecture

```
aws-expert-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest (name, version, description, author)
├── .mcp.json                 # MCP server configuration (aws-knowledge)
├── agents/
│   └── aws-expert.md        # Agent definition with YAML frontmatter and system prompt
└── CLAUDE.md
```

## Key Components

### AWS Expert Agent (`agents/aws-expert.md`)
- Markdown file with YAML frontmatter defining agent metadata
- Uses AWS Knowledge MCP server to search and retrieve AWS documentation
- Answers AWS service questions, checks regional availability, finds best practices
- Evaluates solution feasibility considering security, cost, and performance

### MCP Server Configuration (`.mcp.json`)
- Configures `aws-knowledge` MCP server using `awslabs.aws-documentation-mcp-server`
- Requires `uvx` (Python package runner) to be available

## Usage

1. Install the plugin via symlink or copy to `~/.claude/plugins/aws-expert`
2. Restart Claude Code to load the plugin
3. The `aws-expert` agent becomes available for AWS-related questions

## MCP Server Dependency

The plugin relies on AWS Labs' AWS Documentation MCP Server:
- Package: `awslabs.aws-documentation-mcp-server`
- Runner: `uvx` (install via `pip install uv`)
