function GenerateEndpointFiles {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    # Constantes
    $namespacePrefix = "Application.Features"
    $commandsFolderName = "Commands"
    $queriesFolderName = "Queries"

    $currentDir = Get-Item .
    $folderName = $currentDir.Name
    $parentDir = $currentDir.Parent.Name
    $isSubFolder = $false

    # Vérifier si le dossier courant est "Commands" ou "Queries"
    if ($folderName -eq $commandsFolderName -or $folderName -eq $queriesFolderName) {
        $isSubFolder = $true
    }

    # Créer le dossier
    $folderPath = Join-Path -Path (Get-Location) -ChildPath $Name
    $isAllFilesCreated = $true
    if (-not (Test-Path -Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath | Out-Null
        Write-Host "Dossier '$Name' créé avec succès."
    } else {
        Write-Host "Le dossier '$Name' existe déjà." -ForegroundColor Yellow
        $isAllFilesCreated = $false
    }

    if ($isSubFolder) {
        $namespacePrefix += ".$parentDir.$folderName"
    } else {
        $namespacePrefix += ".$folderName"
    }

    # Définir les fichiers et leur contenu
    $filesWithContent = @{
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
        "${Name}Response.cs" = @"
namespace ${namespacePrefix}.${Name};

public record ${Name}Response();
"@;
        "${Name}Request.cs" = @"
using MediatR;

namespace ${namespacePrefix}.${Name};

public record ${Name}Request() : IRequest<${Name}Response>;
"@;
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

    # Créer les fichiers avec le contenu défini
    foreach ($file in $filesWithContent.Keys) {
        $filePath = Join-Path -Path $folderPath -ChildPath $file
        if (-not (Test-Path -Path $filePath)) {
            $content = $filesWithContent[$file] -replace '\${Name}', $Name
            Set-Content -Path $filePath -Value $content
            Write-Host "Fichier '$file' créé avec son squelette."
        } else {
            Write-Host "Le fichier '$file' existe déjà." -ForegroundColor Yellow
            $isAllFilesCreated = $false
        }
    }

    if ($isAllFilesCreated) {
        Write-Host "Tous les fichiers ont été créés dans le dossier '$folderPath'." -ForegroundColor Green
    } else {
        Write-Host "Certains fichiers n'ont pas été créés." -ForegroundColor Yellow
    }
}
Set-Alias -Name generate-endpoint -Value GenerateEndpointFiles
