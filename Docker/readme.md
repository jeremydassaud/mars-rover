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

### Docker cvse

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

## 4. Docker rebuild

On utilisera le conteneur staticHtml-DockerFile

### Modification du fichier et rebuild
On fait une modification sur notre docker et on met la commande :
```bash
docker build -t static-html -f staticHtml-DockerFile .
```

```bash
docker run -p 8080:80 static-html
```

### Modification sans rebuild

Mise de l'image en arrière plan.
```bash
docker run -d --name static-html-container -p 8080:80 static-html
```

```bash
docker exec -it static-html-container sh
echo '<html><body><h1>Hello World Modifier!</h1></body></html>' > /app/index.html
exit
```

### utiliser un volume pour modifier le fichier.

On va utiliser le docker python qui a un fichier externe au docker.

```bash
docker run -d --name python-server-container -p 8888:5000 -v ./site:/app python-server
```
On peut modifier le fichier sur notre machine directement.

## 5. Créer un réseaux docker

Créez un réseau Docker :

```bash
docker network create my-network
```

Lancez deux conteneurs Alpine avec des noms spécifiques sur ce réseau :
```bash
docker run -d --name container1 --network my-network alpine sleep infinity
docker run -d --name container2 --network my-network alpine sleep infinity
```
Ping un container depuis l'autre :

```bash
docker exec -it container1 ping container2
```

## 6. Utiliser docker compose pour créer un conteneur base de données et un serveur verifiant la connexion.
Pour démarrez le docker compose:
```bash
docker compose --d
```

A la fin de l'éxécution de tout les docker mettre cette commande pour supprimer le cache :
```bash
docker system prune -af
```