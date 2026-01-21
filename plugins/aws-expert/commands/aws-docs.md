---
name: aws-docs
description: Search and explore AWS documentation using the AWS Knowledge MCP server. Use for quick lookups, concept verification, and documentation exploration.
argument-hint: "<query>"
allowed-tools:
  - mcp__plugin_aws-expert_aws-knowledge-mcp-server__aws___search_documentation
  - mcp__plugin_aws-expert_aws-knowledge-mcp-server__aws___read_documentation
  - mcp__plugin_aws-expert_aws-knowledge-mcp-server__aws___get_regional_availability
  - mcp__plugin_aws-expert_aws-knowledge-mcp-server__aws___recommend
  - mcp__plugin_aws-expert_aws-knowledge-mcp-server__aws___list_regions
---

# AWS Documentation Lookup

Search and retrieve AWS documentation for the user's query.

## Process

1. **Parse the query** - Understand what the user wants to look up
2. **Choose appropriate MCP tool(s)**:
   - `aws___search_documentation` - For general searches, best practices, features
   - `aws___read_documentation` - To read a specific documentation page
   - `aws___get_regional_availability` - For checking service/feature availability in regions
   - `aws___recommend` - To get related documentation recommendations
   - `aws___list_regions` - To list all AWS regions

3. **Search documentation** using appropriate topics:
   - `reference_documentation` - API/SDK/CLI specifics
   - `current_awareness` - New features, announcements
   - `troubleshooting` - Errors, debugging
   - `cdk_docs` / `cdk_constructs` - CDK questions
   - `cloudformation` - CloudFormation templates
   - `general` - Architecture, best practices, tutorials

4. **Present results clearly**:
   - Summarize the key findings
   - Include relevant quotes or details
   - Provide documentation links for further reading
   - Note if information might be incomplete

## Output Format

Provide a concise, focused response:

```
## [Topic]

[Key findings in 2-4 bullet points]

**Details:**
[Relevant specifics, configurations, or examples]

**Documentation:** [link]
```

## Examples

**Query:** "Lambda memory limits"
- Search for Lambda quotas and limits
- Return current memory range and recommendations

**Query:** "S3 vs EFS for Lambda"
- Search for Lambda storage options
- Compare the two approaches with trade-offs

**Query:** "Is Bedrock available in eu-west-1"
- Use regional availability check
- Return availability status

## Tips

- For version-specific info, use `current_awareness` topic
- For errors, use `troubleshooting` topic
- If initial search is too broad, narrow with more specific terms
- Always include the documentation URL for reference
