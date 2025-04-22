$projectFiles = Get-ChildItem -Recurse -Filter "*.csproj"
    $projects = @{}
    
    # Collecter tous les projets et leurs références
    foreach ($file in $projectFiles) {
        $projectName = $file.BaseName
        $content = Get-Content $file.FullName
        $references = $content | Where-Object { $_ -match "ProjectReference" } | ForEach-Object {
            if ($_ -match 'Include="(.+?)"') {
                $path = $Matches[1]
                $refName = [System.IO.Path]::GetFileNameWithoutExtension($path)
                $refName
            }
        }
        $projects[$projectName] = $references
    }
    
    # Fonction pour trouver les dépendances circulaires
    function Find-CircularDependency($project, $visited = @(), $path = @()) {
        if ($path -contains $project) {
            Write-Host "🚨 Dépendance circulaire détectée: $($path -join ' -> ') -> $project"
            return $true
        }
        
        if ($visited -contains $project) {
            return $false
        }
        
        $visited += $project
        $newPath = $path + $project
        
        foreach ($ref in $projects[$project]) {
            if (Find-CircularDependency $ref $visited $newPath) {
                return $true
            }
        }
        
        return $false
    }
    
    # Vérifier chaque projet
    $foundCircular = $false
    foreach ($project in $projects.Keys) {
        if (Find-CircularDependency $project) {
            $foundCircular = $true
        }
    }
    
    if (-not $foundCircular) {
        Write-Host "✅ Aucune dépendance circulaire détectée!"
    } else {
        Write-Host "🌀 Des boucles de dépendances pourraient causer des anomalies gravitationnelles!"
        exit 1
    }