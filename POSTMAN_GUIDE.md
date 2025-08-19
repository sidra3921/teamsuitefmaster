# Using TeamSuite Postman Collection

This guide explains how to use the provided Postman collection and environment to test the TeamSuite API endpoints.

## Prerequisites

- [Postman](https://www.postman.com/downloads/) application installed
- TeamSuite Postman collection and environment files

## Files

1. `POSTMAN_COLLECTION.json` - Contains the API requests
2. `POSTMAN_ENVIRONMENT.json` - Contains environment variables

## Import the Collection and Environment

### Step 1: Open Postman

Launch the Postman application on your computer.

### Step 2: Import the Collection

1. Click on the "Import" button in the top left corner
2. Select "File" tab
3. Click "Upload Files"
4. Navigate to and select `POSTMAN_COLLECTION.json`
5. Click "Import"

### Step 3: Import the Environment

1. Click on the "Import" button in the top left corner again
2. Select "File" tab
3. Click "Upload Files"
4. Navigate to and select `POSTMAN_ENVIRONMENT.json`
5. Click "Import"

### Step 4: Select the Environment

1. Look for the environment dropdown in the top right corner of Postman
2. Select "TeamsuiteEnvironment" from the dropdown

## Using the Collection

### Environment Variables

The collection uses the following environment variables:

- `CORN_EndPoint`: Base URL for the API (https://17dx7l6cz8.execute-api.ap-south-1.amazonaws.com/Prod/)
- `xConn`: Connection header value for authentication

### Available Requests

#### 1. MultiTenant

This request retrieves client information for a specific PIN.

**Request Details:**
- Method: GET
- URL: {{CORN_EndPoint}}MultiTenant/GetClientInfo?Pin=demo

To run this request:
1. Open the "Team Suite" collection
2. Click on "MultiTenant" request
3. Click "Send"

#### 2. Login

This request authenticates a user and returns an access token.

**Request Details:**
- Method: POST
- URL: {{CORN_EndPoint}}Token
- Headers:
  - x-conn: {{xConn}}
- Body (raw JSON):
  ```json
  {
      "Grant_Type": "password",
      "Username": "manager",
      "Password": "FSDEMO123"
  }
  ```

To run this request:
1. Open the "Team Suite" collection
2. Click on "Login" request
3. Click "Send"

## Testing Additional Endpoints

To test additional endpoints, you can create new requests based on the existing ones:

1. Right-click on an existing request
2. Select "Duplicate"
3. Modify the duplicated request as needed
4. Save the request

## Troubleshooting

If you encounter issues with the requests:

1. **Verify Environment Selection**:
   - Make sure "TeamsuiteEnvironment" is selected in the environment dropdown

2. **Check Environment Variables**:
   - Click the "eye" icon next to the environment dropdown
   - Verify that CORN_EndPoint and xConn have the correct values

3. **Inspect Request Headers**:
   - Make sure the x-conn header is being sent with requests
   - Check for any additional required headers

4. **Examine Response**:
   - Check the response body for any error messages
   - Verify HTTP status code in the response

## Extending the Collection

To add more endpoints to the collection:

1. Create a new request in the "Team Suite" collection
2. Set the request method (GET, POST, etc.)
3. Enter the URL, using the {{CORN_EndPoint}} variable
4. Add necessary headers, including x-conn: {{xConn}}
5. Add any required body content
6. Save the request

## Authentication Flow

The typical authentication flow:

1. Run the "MultiTenant" request to verify connection
2. Run the "Login" request to get an authentication token
3. For subsequent authenticated requests, add the token in the Authorization header:
   - Key: Authorization
   - Value: Bearer [token from login response]

## API Documentation

Refer to the `API_INTEGRATION_SUMMARY.md` for more details on the API endpoints, request formats, and response structures.
