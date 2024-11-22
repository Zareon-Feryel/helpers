function GenerateEndpointFiles {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    # Constants
    $namespacePrefix = "Application.Features"
    $categorySubFolders = @("Commands", "Queries") # This is an array of potential subfolders in your features folder (e.g. Commands, Queries)

    $currentDir = Get-Item .
    $folderName = $currentDir.Name
    $parentDir = $currentDir.Parent.Name
    $isSubFolder = $false

    # Check if the current folder is a /Features subfolder
    if ($categorySubFolders -contains $folderName) {
        $isSubFolder = $true
    }

    # Create the folder if it doesn't exist
    $folderPath = Join-Path -Path (Get-Location) -ChildPath $Name
    $isAllFilesCreated = $true
    if (-not (Test-Path -Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
        Write-Host "Folder '$Name' successfully created."
    } else {
        Write-Host "Folder '$Name' already exists." -ForegroundColor Yellow
        $isAllFilesCreated = $false
    }

    if ($isSubFolder) {
        $namespacePrefix += ".$parentDir.$folderName"
    } else {
        $namespacePrefix += ".$folderName"
    }

    # Define files and their content
    $filesWithContent = @{
        # Handler file
        "${Name}Handler.cs" = @"
using MediatR;

namespace ${namespacePrefix}.${Name};

public class ${Name}Handler : IRequestHandler<${Name}Request, ${Name}Response>
{
    public ${Name}Handler()
    {
    }
    
    public Task<${Name}Response> Handle(${Name}Request request, CancellationToken cancellationToken)
    {
        throw new NotImplementedException();
    }
}
"@;

        # Response file
        "${Name}Response.cs" = @"
namespace ${namespacePrefix}.${Name};

public record ${Name}Response();
"@;

        # Request file
        "${Name}Request.cs" = @"
using MediatR;

namespace ${namespacePrefix}.${Name};

public record ${Name}Request() : IRequest<${Name}Response>;
"@;

        # Validator file
        "${Name}Validator.cs" = @"
using FluentValidation;

namespace ${namespacePrefix}.${Name};

public class ${Name}Validator : AbstractValidator<${Name}Request>
{
    public ${Name}Validator()
    {
    }
}
"@
    }

    # Create files with their content in the folder
    foreach ($file in $filesWithContent.Keys) {
        $filePath = Join-Path -Path $folderPath -ChildPath $file
        if (-not (Test-Path -Path $filePath)) {
            $content = $filesWithContent[$file] -replace '\${Name}', $Name
            Set-Content -Path $filePath -Value $content
            Write-Host "File '$file' successfully created."
        } else {
            Write-Host "File '$file' already exists." -ForegroundColor Yellow
            $isAllFilesCreated = $false
        }
    }

    if ($isAllFilesCreated) {
        Write-Host "All files have been created in the folder '$folderPath'." -ForegroundColor Green
    } else {
        Write-Host "Some files have not been created." -ForegroundColor Yellow
    }
}
Set-Alias -Name generate-endpoint -Value GenerateEndpointFiles
