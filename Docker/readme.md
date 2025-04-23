## 1. curl-DockerFile

Construire le docker
```bash
docker build -t curl-image -f curl-dockerfile .
```

Démarrer est supprimer lorsque l'image a terminé son éxécution
```bash
docker run --rm curl-image
```

## 2. staticHtml-DockerFile

Construire le docker 
```bash
docker build -t static-html -f staticHtml-DockerFile .
```

executer le docker
```bash
docker run -p 8080:80 static-html
```

résultat sur un navigateur
![alt text](image.png)

## 3. Python-DockerFile

```bash
docker build -t python-server -f ./python/DockerFile .
```

```bash
docker run -p 8888:5000 python-server
```

## 4. Docker cvse

Commande :
```bash
docker scout cves python-server
```

Output avant modifcation :
```bash
34 vulnerabilities found in 17 packages
  CRITICAL  0
  HIGH      2   
  MEDIUM    2
  LOW       30
```

Output après modifcations de version de python en 3.14:
```bash
## Packages and Vulnerabilities

  No vulnerable packages detected
```

## 4.

A la fin de l'éxécution de tout les docker mettre cette commande pour supprimer le cache :
```bash
docker system prune -af
```