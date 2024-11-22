# Dotnet helpers 💾

## [Generate Endpoint](./generate-endpoint.ps1) 🪄
This helper is used to create your MediatR endpoints files (Handler, Response, Request, Validator)  
Go in ``Application/Features/<SuperFeature>/(<CommandsOrQueries>)``  
>Commands/Queries folder is not mandatory, but the script will take it in account for namespace generation  
If in Commands or Queries folder, namespace will be ``Application.Features.<SuperFeature>.CommandsOrQueries.<GetSuperEndpoint>``  
If not in Commands or Queries folder, namespace will be ``Application.Features.<SuperFeature>.<GetSuperEndpoint>``

Using it with ``generate-endpoint <GetSuperEndpoint>`` will generates all four files:
- \<GetSuperEndpoint\>Handler
- \<GetSuperEndpoint\>Request
- \<GetSuperEndpoint\>Response
- \<GetSuperEndpoint\>Validator

With all skeleton code, with proper 
- usings
- namespace
- class/record name
- interface implementation
- constructor
- default method (for example Handle for the Handler) 
