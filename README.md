# AWS Claude Skills

Claude Code plugins for AWS expertise and serverless development.

## Installation

```bash
/plugin marketplace add shawnawshk/aws-claude-skills
/plugin install aws-expert
/plugin install serverless-dev
```

## Plugins

### aws-expert

AWS specialist for documentation search, regional availability checks, and architecture evaluation.

**Usage:**
```
@"aws-expert:aws-knowledge (agent)" What are S3 bucket security best practices?
```

### serverless-dev

Build serverless applications with AWS SAM, Lambda, API Gateway, EventBridge, and DynamoDB.

**Prerequisites:** [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) and AWS CLI configured

**Usage:**
```
Create a serverless API with Python Lambda and DynamoDB
Deploy my SAM application
Optimize Lambda cold start performance
```

**Features:**
- SAM project initialization, build, and deployment
- Lambda best practices and performance optimization
- API Gateway with authentication and response streaming
- Event-driven architecture (EventBridge, SQS, SNS, DynamoDB Streams)
- Local testing and debugging
- Security and IAM guidance

## Requirements

- Claude Code v2.0+
- Internet access

**For serverless-dev:** AWS SAM CLI and AWS CLI with configured credentials

## License

MIT - Shawn Zhang
