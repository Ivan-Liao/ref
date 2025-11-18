# Access Control
1. Privileges assigned to Roles assigned to Users (RBAC)
   1. privileges
2. Discretionary Access Control (DAC)
   1. objects have an role owner
   2. owners can grant other roles access to that object 
3. Object hierarchy requires access to parent objects before child objects are accessible

## Authentication
1. Username and password
2. Multi-factor Authentication (MFA) via Duo Security
   1. Activated per user basis and only via the UI
   2. Recommended all ACCOUNTADMIN users use MFA
   3. Duo
      1. Approve push notification (default)
      2. Answer a call
   4. ALTER USER SET Parameters
      1. MIN_TO_BYPASS_MFA (temporarily disables MFA)
      2. DISABLE_MFA (must re-enroll to use MFA after disabling)
      3. ALLOW_CLIENT_MFA_CACHING
         1. reduces number of prompts for multiple logins
3. Federated Authentication ... Okta
   1.  Login options
       1.  Click SSO Button > Enter idP (identity provider) credentials 
       2.  Click on Snowflake application in idP App
   2.  CREATE SECURITY INTEGRATION
       1.  Properties
           1.  SAML2_x509_CERT
           2.  SAML2_SSO_URL
           3.  SAML2_PROVIDER
           4.  TYPE (like Okta, ADFS)
           5.  SAML2_ISSUER
           6.  ENABLED
4.  Key Pair Authentication
    1.  Generate Key-Pair using OpenSSL (like 2048-bit RSA key pair)
    2.  Assign Public Key to user, user keeps private key safe on local machine
    3.  Configure Snowflake Client
        1.  SnowSQL
        2.  Python connector
        3.  Kafka connector
        4.  Others (Go, JDBC, ODBC, .NET, Node.js, SPark)
    4.  Optional Configure Key-Pair Rotation
5.  OAuth 2.0
6.  SCIM (system for cross-domain identity management), manages user and groups using RESTful APIs



## Network Policies
1. Additional layer of security, allows or denies acess to Snowflake account based on single IP or list of IPs
2. Steps
   1. Create Network Rules 
   2. Create Network Policies
      1. Can be in ALLOWED_NETWORK_RULE_LIST or BLOCKED_NETWORK_RULE_LIST
   3. Apply Network Policies
      1. ALTER ACCOUNT SET NETWORK_POLICY = <POLICY_HERE>
3. One network policy object per account or per user

## Privileges
1. Global privileges
   1. MANAGE GRANTS
2. Account Objects privileges
3. Schemas privileges
4. Schema Objects privileges ... Procedures, Tables, Tasks, Views, etc.
5. Verbs
   1. GRANT and REVOKE keywords
   2. MODIFY
   3. MONITOR
   4. OWNERSHIP
   5. SELECT
   6. USAGE
6. Future grants
   1. Examples
      1. grant select on future tables in database <DB_HERE>
      2. grant select on future view in schema <SCHEMA_HERE>
      3. grant usage on future schemas in database <DB_HERE>

## Roles
1. Definition ... entity to which privileges on securable objects can be granted or revoked
2. Role hierarchies are a common paradigm
3. Preset roles
   1. ORGADMIN 
      1. manage operations at organization level
      2. Can create account in an organization
      3. Can view all accounts in an organization
      4. Can view usage information across an organization
   2. ACCOUNTADMIN
      1. Top level role for an account
      2. encapsulates SYSADMIN and SECURITYADMIN
      3. Configure account-level parameters
      4. View and operate on all objects in account
      5. View and manage Snowflake billing and credit data
      6. Stop any running SQL statements
   3. SYSADMIN
      1. Create warhouses, databases, schemas, and other objects in an account
   4. SECURITYADMIN
      1. Create, monitor, and manage users and roles
   5. USERADMIN
      1. User and Role management via CREATE USER and CREATE ROLE privileges
   6. PUBLIC
      1. Granted to every user and other role by default
   7. CUSTOM ROLES
      1. Must be assigned to SYSADMIN or SYSADMIN will not be able to manage

# Security

## Encryption
1. AES-256 strong encryption on Table data and internal stage data