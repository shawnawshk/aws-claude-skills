# API Gateway Response Streaming

> **⚠️ VERIFICATION REQUIRED**: Before implementing response streaming, verify current runtime support, regional availability, and configuration requirements via AWS Knowledge MCP server.

## Overview

Response streaming enables Lambda functions to progressively send response data to clients through API Gateway, improving time-to-first-byte (TTFB) and supporting larger payloads up to 200 MB.

**Key Benefits:**
- Reduced latency - Start sending data before processing completes
- Larger responses - Up to 200 MB vs 6 MB buffered limit
- Progressive delivery - Stream results as they're generated
- Better user experience - Real-time feedback for long operations

## Use Cases

### Ideal Scenarios

**LLM/AI Streaming:**
- Stream AI model responses token-by-token
- Progressive text generation
- Real-time translations

**Large Data Processing:**
- Export large datasets incrementally
- Database query results streaming
- Log aggregation and streaming

**Long-Running Operations:**
- Real-time progress updates
- Build/deployment status
- Batch processing results

**Media Processing:**
- Transcoding progress
- Image processing pipelines
- Video analysis results

### Not Recommended For

- **Small responses** - < 6 MB (buffering is simpler)
- **Quick operations** - < 1 second (no latency benefit)
- **Binary data** - Use S3 presigned URLs instead
- **Bidirectional communication** - Consider WebSockets

## Prerequisites

Before implementing response streaming, verify:

1. **API Type** - Must use REST API (not HTTP API)
2. **Runtime Support** - Check current Lambda runtime capabilities
3. **Regional Availability** - Verify feature availability in target region
4. **IAM Permissions** - Ensure proper invoke permissions configured

## API Gateway Configuration

### REST API Requirement

**Critical:** Response streaming only works with REST APIs, not HTTP APIs.

```yaml
# ✅ CORRECT - REST API
StreamingApi:
  Type: AWS::Serverless::Api
  Properties:
    StageName: prod

# ❌ WRONG - HTTP API (no streaming support)
StreamingApi:
  Type: AWS::Serverless::HttpApi
```

### Integration Configuration

Enable streaming in the Lambda integration:

```yaml
x-amazon-apigateway-integration:
  type: aws_proxy
  httpMethod: POST
  # Use streaming-specific invocation path
  uri: !Sub "arn:aws:apigateway:${AWS::Region}:lambda:path/2021-11-15/functions/${Function.Arn}/response-streaming-invocations"
  responseTransferMode: STREAM  # Required
  timeoutInMillis: 30000
  credentials: !GetAtt ApiGatewayRole.Arn
```

**Key Configuration Elements:**
- **API Version** - Use `2021-11-15` (not older versions)
- **Path Suffix** - Must end with `/response-streaming-invocations`
- **Transfer Mode** - Explicitly set `STREAM` (not default buffered)
- **Credentials** - IAM role with streaming invoke permissions

### IAM Permissions

API Gateway needs special permission to invoke with streaming:

```yaml
StreamingApiRole:
  Type: AWS::IAM::Role
  Properties:
    AssumeRolePolicyDocument:
      Version: '2012-10-17'
      Statement:
        - Effect: Allow
          Principal:
            Service: apigateway.amazonaws.com
          Action: sts:AssumeRole
    Policies:
      - PolicyName: InvokeLambdaStreaming
        PolicyDocument:
          Version: '2012-10-17'
          Statement:
            - Effect: Allow
              Action:
                - lambda:InvokeFunction
                - lambda:InvokeWithResponseStream
              Resource: !GetAtt StreamingFunction.Arn
```

## Lambda Function Implementation

### Runtime Options

**Native Support:**
- Node.js managed runtimes have built-in streaming support

**Other Languages:**
- Python, Java, Go, etc. - Use Lambda Web Adapter or custom runtime
- Custom runtimes must support chunked transfer encoding

**Verify current runtime support via AWS Knowledge MCP before implementation.**

### Response Format Requirements

Lambda functions must return:
1. **Metadata** - Status code, headers (as JSON)
2. **Delimiter** - Separator between metadata and payload
3. **Payload** - Streaming response body

### Conceptual Implementation Pattern

```
1. Set up streaming handler wrapper
2. Define response metadata (status, headers)
3. Create response stream
4. Generate and write data chunks progressively
5. Close stream when complete
```

### Runtime-Specific Implementations

#### Node.js Pattern

```javascript
// Wrap handler with streaming decorator
export const handler = awslambda.streamifyResponse(
  async (event, responseStream, context) => {
    // Define metadata
    const metadata = {
      statusCode: 200,
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache'
      }
    };

    // Create response stream with metadata
    responseStream = awslambda.HttpResponseStream.from(
      responseStream,
      metadata
    );

    // Stream data progressively
    for (let i = 0; i < count; i++) {
      responseStream.write(`data: ${JSON.stringify({id: i})}\n\n`);
      await sleep(delay);
    }

    responseStream.end();
  }
);
```

#### Other Runtimes (Lambda Web Adapter)

For Python, Go, Java, etc., use Lambda Web Adapter:

```yaml
StreamingFunction:
  Type: AWS::Serverless::Function
  Properties:
    Runtime: python3.x  # or your preferred runtime
    Layers:
      - !Sub arn:aws:lambda:${AWS::Region}:753240598075:layer:LambdaAdapterLayerX86:latest
    Environment:
      Variables:
        AWS_LAMBDA_EXEC_WRAPPER: /opt/bootstrap
        PORT: 8080
```

Then implement standard HTTP streaming in your application code.

## Response Formats

### Server-Sent Events (SSE)

**Use Case:** Browser EventSource API, real-time updates

**Format:**
```
data: {"message": "First chunk"}\n\n
data: {"message": "Second chunk"}\n\n
data: {"message": "Complete"}\n\n
```

**Headers:**
- `Content-Type: text/event-stream`
- `Cache-Control: no-cache`
- `X-Accel-Buffering: no`

### JSON Lines (JSONL/NDJSON)

**Use Case:** Log streaming, batch results

**Format:**
```
{"id": 1, "message": "First"}\n
{"id": 2, "message": "Second"}\n
{"id": 3, "message": "Third"}\n
```

**Headers:**
- `Content-Type: application/x-ndjson`
- `Cache-Control: no-cache`

### Plain Text

**Use Case:** Progress indicators, terminal output

**Format:**
```
Starting process...\n
[1/10] Processing item 1\n
[2/10] Processing item 2\n
Complete!\n
```

**Headers:**
- `Content-Type: text/plain`

## Performance Considerations

### Bandwidth Limits

- **First 6 MB:** Uncapped bandwidth
- **After 6 MB:** 2 MBps maximum rate
- **Max Response:** 200 MB total
- **Max Duration:** 15 minutes

### Optimization Strategies

1. **Right-size chunks** - Not too large, not too frequent
2. **Use arm64 architecture** - Better price-performance
3. **Appropriate memory allocation** - Balance cost and speed
4. **Match timeout to duration** - Set reasonable Lambda timeout
5. **Minimize cold starts** - Use provisioned concurrency if needed

### Streaming Rate Guidelines

```
Good: Small chunks every 100-500ms
Acceptable: Medium chunks every 1-2 seconds
Poor: Large chunks every 5+ seconds (defeats streaming purpose)
```

## Testing

### Command-Line Testing

**Use `-N` flag to disable buffering:**

```bash
# ✅ CORRECT - See streaming in real-time
curl -N "https://api.example.com/stream"

# ❌ WRONG - May buffer entire response
curl "https://api.example.com/stream"
```

### Verify Progressive Delivery

Add timestamps to confirm true streaming:

```javascript
// Include timestamp in each chunk
yield JSON.stringify({
  message: `Chunk ${i}`,
  timestamp: new Date().toISOString()
});
```

Watch for progressive timestamps, not all at once (which indicates buffering).

### Test Different Formats

```bash
# SSE format
curl -N "https://api/stream?format=sse"

# JSONL format
curl -N "https://api/stream?format=jsonl"

# Plain text
curl -N "https://api/stream?format=text"
```

## Common Patterns

### Pattern: Progress Updates

Stream progress as long-running operation executes:

```
1. Send "Starting" message
2. For each item:
   - Process item
   - Stream progress (e.g., "10/100 complete")
3. Send "Complete" message
```

### Pattern: Incremental Results

Stream results as they're generated:

```
1. Start query/operation
2. For each result:
   - Generate result
   - Immediately stream to client
3. Close stream when done
```

### Pattern: AI/LLM Streaming

Stream AI model output token-by-token:

```
1. Send initial metadata
2. For each token from model:
   - Stream token immediately
3. Send completion marker
```

## Common Anti-Patterns

### ❌ Anti-Pattern: Buffering Before Streaming

```javascript
// WRONG - Defeats streaming purpose
const allData = await generateAllData();
for (const chunk of allData) {
  responseStream.write(chunk);
}
```

**Fix:** Generate and stream incrementally:

```javascript
// CORRECT - True streaming
for (let i = 0; i < count; i++) {
  const chunk = await generateChunk(i);
  responseStream.write(chunk);
}
```

### ❌ Anti-Pattern: Large Infrequent Chunks

```javascript
// WRONG - Poor streaming experience
await sleep(5000);
responseStream.write(largeChunk);
```

**Fix:** Small frequent chunks:

```javascript
// CORRECT - Better user experience
for (const piece of chunks) {
  responseStream.write(piece);
  await sleep(100);
}
```

### ❌ Anti-Pattern: Using HTTP API

```yaml
# WRONG - No streaming support
Type: AWS::Serverless::HttpApi
```

**Fix:** Use REST API:

```yaml
# CORRECT
Type: AWS::Serverless::Api
```

## CORS Configuration

Enable CORS for browser access:

```yaml
StreamingApi:
  Type: AWS::Serverless::Api
  Properties:
    Cors:
      AllowOrigin: "'*'"
      AllowMethods: "'GET,POST,OPTIONS'"
      AllowHeaders: "'*'"
```

Add OPTIONS method for preflight requests.

## Monitoring

### Enable X-Ray Tracing

```yaml
Globals:
  Function:
    Tracing: Active
```

### CloudWatch Logs

```yaml
StreamingApi:
  Type: AWS::Serverless::Api
  Properties:
    AccessLogSetting:
      DestinationArn: !GetAtt ApiLogGroup.Arn
      Format: '$context.requestId $context.httpMethod $context.path $context.status'
```

### Key Metrics to Monitor

- Duration
- Memory utilization
- Streaming bandwidth
- Error rates
- Cold start frequency

## Troubleshooting

### Problem: Response is Buffered (Not Streaming)

**Possible Causes:**
- Using HTTP API instead of REST API
- Missing `responseTransferMode: STREAM`
- Wrong Lambda invocation path
- Testing without `-N` flag in curl

**Solution:** Verify all streaming requirements configured correctly.

### Problem: 500 Internal Server Error

**Possible Causes:**
- Lambda function not using streaming wrapper
- Missing IAM permission (`InvokeWithResponseStream`)
- Runtime doesn't support streaming

**Solution:** Check CloudWatch logs, verify function implementation.

### Problem: CORS Errors in Browser

**Possible Causes:**
- Missing CORS configuration
- No OPTIONS method

**Solution:** Add CORS to API Gateway, implement OPTIONS handler.

### Problem: Timeout Errors

**Possible Causes:**
- API Gateway timeout too low (max 30 seconds)
- Lambda timeout too low
- Function taking too long between chunks

**Solution:** Increase timeouts, reduce chunk generation time.

## Security Best Practices

### Least Privilege IAM

```yaml
# ✅ GOOD - Specific resource
Resource: !GetAtt StreamingFunction.Arn

# ❌ BAD - Wildcard
Resource: "*"
```

### API Authorization

**Options:**
- IAM authorization
- Cognito User Pools
- Lambda authorizers
- API Keys

```yaml
StreamingApi:
  Type: AWS::Serverless::Api
  Properties:
    Auth:
      DefaultAuthorizer: AWS_IAM
```

### Rate Limiting

```yaml
StreamingApi:
  Type: AWS::Serverless::Api
  Properties:
    MethodSettings:
      - ResourcePath: /stream
        HttpMethod: GET
        ThrottlingBurstLimit: 100
        ThrottlingRateLimit: 50
```

## Client Implementation Examples

### JavaScript (Browser - SSE)

```javascript
const eventSource = new EventSource('https://api.example.com/stream');

eventSource.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Received:', data);
};

eventSource.onerror = () => {
  eventSource.close();
};
```

### Python (JSONL)

```python
import requests
import json

with requests.get(url, stream=True) as response:
    for line in response.iter_lines():
        if line:
            data = json.loads(line)
            print(f"Received: {data}")
```

### Node.js (Fetch API)

```javascript
const response = await fetch(url);
const reader = response.body.getReader();
const decoder = new TextDecoder();

while (true) {
  const { done, value } = await reader.read();
  if (done) break;

  const chunk = decoder.decode(value);
  console.log('Chunk:', chunk);
}
```

## Quick Reference Checklist

### Configuration Checklist

- [ ] Using REST API (not HTTP API)
- [ ] Lambda invocation path uses `2021-11-15` API version
- [ ] Path ends with `/response-streaming-invocations`
- [ ] `responseTransferMode: STREAM` set explicitly
- [ ] IAM role has `lambda:InvokeWithResponseStream` permission
- [ ] CORS configured if browser access needed
- [ ] Appropriate timeout values set

### Implementation Checklist

- [ ] Verified runtime support for streaming
- [ ] Function uses streaming wrapper/adapter
- [ ] Response metadata defined correctly
- [ ] Data streamed progressively (not buffered)
- [ ] Appropriate Content-Type header set
- [ ] Stream closed properly
- [ ] Error handling implemented

### Testing Checklist

- [ ] Tested with `curl -N` flag
- [ ] Verified progressive delivery (timestamps)
- [ ] Tested with actual client code
- [ ] CORS headers verified
- [ ] CloudWatch logs checked
- [ ] Performance metrics reviewed

## References

**Before implementation, verify current information via AWS Knowledge MCP:**
- Runtime support and versions
- Regional availability
- Configuration syntax
- Best practices updates

**AWS Documentation:**
- Lambda Response Streaming
- API Gateway Lambda Proxy Integration
- Writing Response Streaming Functions
- Lambda Web Adapter (for non-Node.js runtimes)

## Summary

Response streaming enables progressive response delivery for improved latency and larger payloads. Key requirements:

1. **REST API only** - HTTP APIs don't support streaming
2. **Special invocation path** - Use streaming-specific Lambda ARN
3. **Explicit configuration** - Set `responseTransferMode: STREAM`
4. **Runtime support** - Native Node.js or use Lambda Web Adapter
5. **Proper permissions** - Include `InvokeWithResponseStream` action
6. **Progressive generation** - Stream data as it's created, don't buffer

**Always verify current runtime support, regional availability, and configuration requirements before implementation.**
