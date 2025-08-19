# Backend Configuration Guide for TeamSuite API

## Server-Side Issues to Fix:

### 1. **IIS/ASP.NET Permissions Issue**
The error shows: "ASP.NET is not authorized to access the requested resource"

**Fix on Server:**
```powershell
# Run as Administrator on the server
# Grant ASP.NET permissions to the application folder
icacls "C:\inetpub\wwwroot\YourAPIFolder" /grant "IIS_IUSRS:(OI)(CI)F"
icacls "C:\inetpub\wwwroot\YourAPIFolder" /grant "NETWORK SERVICE:(OI)(CI)F"
```

### 2. **CORS Configuration**
Add to `web.config`:
```xml
<system.webServer>
  <httpProtocol>
    <customHeaders>
      <add name="Access-Control-Allow-Origin" value="*" />
      <add name="Access-Control-Allow-Headers" value="Content-Type,Authorization" />
      <add name="Access-Control-Allow-Methods" value="GET,POST,PUT,DELETE,OPTIONS" />
    </customHeaders>
  </httpProtocol>
</system.webServer>
```

### 3. **OAuth Configuration**
In your API's `Startup.cs` or OAuth configuration:
```csharp
public void ConfigureAuth(IAppBuilder app)
{
    app.UseOAuthAuthorizationServer(new OAuthAuthorizationServerOptions
    {
        TokenEndpointPath = new PathString("/Api/token"),
        Provider = new ApplicationOAuthProvider(),
        AccessTokenExpireTimeSpan = TimeSpan.FromHours(24),
        AllowInsecureHttp = true, // For development only
        AuthorizeEndpointPath = new PathString("/Api/authorize")
    });
}
```

### 4. **Database Connection**
Check if the API can connect to the database:
```sql
-- Test stored procedures exist
SELECT * FROM sys.procedures WHERE name LIKE '%GET_LEAVE%'
SELECT * FROM sys.procedures WHERE name LIKE '%POST_LEAVE%'
```

### 5. **Authentication Provider**
In `ApplicationOAuthProvider.cs`:
```csharp
public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
{
    try 
    {
        // Your authentication logic here
        var user = await ValidateUser(context.UserName, context.Password);
        if (user != null)
        {
            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            identity.AddClaim(new Claim(ClaimTypes.Name, context.UserName));
            context.Validated(identity);
        }
        else
        {
            context.SetError("invalid_grant", "Invalid credentials");
        }
    }
    catch (Exception ex)
    {
        context.SetError("server_error", ex.Message);
    }
}
```
