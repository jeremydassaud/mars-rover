# Trouver tous les fichiers .cs récursivement
$csFiles = Get-ChildItem -Recurse -Filter "*.cs"
$files = @{}

# Fonction pour extraire les namespaces et classes utilisés
function Get-FileReferences($fileContent) {
    $references = @()
    
    # Extraction des using statements
    $usings = $fileContent | Where-Object { $_ -match "^using\s+([^;]+);" } | ForEach-Object {
        if ($_ -match "^using\s+([^;]+);") {
            $Matches[1].Trim()
        }
    }
    
    # Détecter les noms de classes utilisées dans le fichier
    $classPattern = "(?<!\w)([\w\.]+)(?=\s+\w+\s*[=;)\]}]|\.|\s*<)"
    $potentialClassRefs = [regex]::Matches($fileContent, $classPattern) | ForEach-Object { $_.Value } | Sort-Object -Unique
    
    # Combiner les deux sources de référence
    $references = $usings + $potentialClassRefs | Sort-Object -Unique
    
    return $references
}

# Fonction pour extraire le namespace et les classes définies dans un fichier
function Get-FileDefined($fileContent) {
    $defined = @()
    
    # Extraction du namespace
    $namespaceMatch = $fileContent | Where-Object { $_ -match "namespace\s+([^;{\s]+)" }
    if ($namespaceMatch -and $namespaceMatch -match "namespace\s+([^;{\s]+)") {
        $namespace = $Matches[1].Trim()
        $defined += $namespace
    }
    
    # Extraction des classes/records/interfaces définies
    $typeDefinitions = $fileContent | Where-Object { $_ -match "^\s*(public|internal|private)?\s*(class|record|interface|struct|enum)\s+(\w+)" }
    foreach ($def in $typeDefinitions) {
        if ($def -match "^\s*(public|internal|private)?\s*(class|record|interface|struct|enum)\s+(\w+)") {
            $className = $Matches[3].Trim()
            if ($namespace) {
                $defined += "$namespace.$className"
            } else {
                $defined += $className
            }
        }
    }
    
    return $defined
}

# Collecter tous les fichiers et leurs références
foreach ($file in $csFiles) {
    $fileName = $file.Name
    $filePath = $file.FullName
    $content = Get-Content $filePath -Raw
    $contentLines = Get-Content $filePath
    
    $defined = Get-FileDefined $contentLines
    $references = Get-FileReferences $contentLines
    
    $files[$fileName] = @{
        "Path" = $filePath
        "Defined" = $defined
        "References" = $references
    }
}

# Construire le graphe de dépendances
$dependencyGraph = @{}

foreach ($file in $files.Keys) {
    $dependsOn = @()
    
    $definedInFile = $files[$file].Defined
    
    foreach ($otherFile in $files.Keys) {
        if ($file -eq $otherFile) { continue }
        
        $definedInOtherFile = $files[$otherFile].Defined
        
        # Vérifier si ce fichier dépend de l'autre fichier
        $hasDependency = $false
        foreach ($ref in $files[$file].References) {
            foreach ($def in $definedInOtherFile) {
                if ($ref -eq $def -or $ref.StartsWith("$def.")) {
                    $hasDependency = $true
                    break
                }
            }
            if ($hasDependency) { break }
        }
        
        if ($hasDependency) {
            $dependsOn += $otherFile
        }
    }
    
    $dependencyGraph[$file] = $dependsOn
}

# Fonction pour trouver les dépendances circulaires
function Find-CircularDependency($file, $visited = @(), $path = @()) {
    if ($path -contains $file) {
        Write-Host "🚨 Dépendance circulaire détectée: $($path -join ' -> ') -> $file"
        return $true
    }
    
    if ($visited -contains $file) {
        return $false
    }
    
    $visited += $file
    $newPath = $path + $file
    
    foreach ($dep in $dependencyGraph[$file]) {
        if (Find-CircularDependency $dep $visited $newPath) {
            return $true
        }
    }
    
    return $false
}

# Afficher le graphe de dépendances
Write-Host "Graphe de dépendances:"
foreach ($file in $dependencyGraph.Keys | Sort-Object) {
    Write-Host "$file dépend de: $($dependencyGraph[$file] -join ', ')"
}

# Vérifier chaque fichier
$foundCircular = $false
foreach ($file in $dependencyGraph.Keys) {
    if (Find-CircularDependency $file) {
        $foundCircular = $true
    }
}

if (-not $foundCircular) {
    Write-Host "✅ Aucune dépendance circulaire détectée au niveau des fichiers .cs!"
} else {
    Write-Host "🌀 Des boucles de dépendances entre fichiers .cs pourraient causer des anomalies gravitationnelles!"
    exit 1
}