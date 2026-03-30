# Documentation Complète — Parcours DevOps & AWS
## Projet MyPortfolio — De zéro à la production

**Auteur** : Soxnang  
**Période** : 23 Mars — 29 Mars 2026  
**GitHub** : github.com/Soxnang/myportfolio  

---

## Résumé du parcours

| Compétence | Statut | Livrable |
|------------|--------|----------|
| Linux & Terminal (WSL2) | ✅ Validé | Script create-myportfolio.sh |
| Git & GitHub | ✅ Validé | 17 commits sur GitHub |
| Docker & Docker Compose | ✅ Validé | Conteneur Nginx |
| AWS S3 & IAM | ✅ Validé | Site live sur AWS |
| CI/CD GitHub Actions | ✅ Validé | Pipeline automatique |
| Terraform (IaC) | ✅ Validé | Infrastructure en 1 commande |

---

## Chapitre 1 — Installation de l'environnement

### 1.1 Installation WSL2 sur Windows
```powershell
wsl --install
```
> Redémarre le PC après installation.

### 1.2 Réinitialiser le mot de passe Ubuntu
```powershell
wsl --shutdown
wsl -u root
passwd snac
exit
```

---

## Chapitre 2 — Linux & Terminal

### 2.1 Navigation
```bash
pwd                    # Dossier actuel
ls -la                 # Liste détaillée
cd ~/myportfolio       # Naviguer
mkdir -p projet/{src,docs}  # Créer dossiers
```

### 2.2 Fichiers
```bash
touch fichier.txt              # Créer
echo 'texte' > fichier.txt     # Écrire (écrase)
echo 'texte' >> fichier.txt    # Ajouter
cat fichier.txt                # Lire
cp source dest                 # Copier
mv source dest                 # Déplacer
rm -rf dossier/                # Supprimer
```

### 2.3 Permissions
```bash
chmod +x scripts/deploy.sh    # Rendre exécutable
chmod 644 fichier.txt          # Lecture seule
ls -la                         # Voir permissions
```

### 2.4 Variables d'environnement
```bash
export PROJECT_NAME='myportfolio'
echo $PROJECT_NAME
echo 'export VAR=valeur' >> ~/.bashrc
source ~/.bashrc
```

### 2.5 Pipes
```bash
ls -la | grep .sh
history | grep git
cat fichier | grep 'mot'
```

---

## Chapitre 3 — Git & GitHub

### 3.1 Configuration
```bash
git config --global user.name 'Soxnang'
git config --global user.email 'snac2214@gmail.com'
git config --global init.defaultBranch main
git config --global credential.helper store
```

### 3.2 Cycle de travail
```bash
git init                        # Dans le dossier projet
git branch -m main
git status
git add .
git commit -m 'feat: description'
git log --oneline
git remote add origin https://github.com/Soxnang/myportfolio.git
git push -u origin main
```

### 3.3 .gitignore
```
.env
aws/
*.tfstate
.terraform/
awscliv2.zip
```

---

## Chapitre 4 — Docker

### 4.1 Dockerfile
```dockerfile
FROM nginx:alpine
COPY src/index.html /usr/share/nginx/html/index.html
COPY assets/css/style.css /usr/share/nginx/html/assets/css/style.css
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 4.2 Commandes Docker
```bash
docker build -t myportfolio:v1 .
docker run -d -p 80:80 --name mon-portfolio myportfolio:v1
docker ps
docker logs mon-portfolio
docker stop mon-portfolio
docker rm mon-portfolio
```

### 4.3 docker-compose.yml
```yaml
services:
  portfolio:
    build: .
    container_name: mon-portfolio
    ports:
      - "80:80"
    restart: always
    volumes:
      - ./src:/usr/share/nginx/html
      - ./assets:/usr/share/nginx/html/assets
```
```bash
docker compose up -d
docker compose ps
docker compose down
```

---

## Chapitre 5 — AWS

### 5.1 Installation AWS CLI
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### 5.2 Configuration
```bash
aws configure
# AWS Access Key ID : AKIA...
# AWS Secret Access Key : ...
# Default region name : eu-west-3
# Default output format : json

aws sts get-caller-identity
```

### 5.3 Déploiement S3
```bash
aws s3 mb s3://myportfolio-soxnang-2026 --region eu-west-3
aws s3 website s3://myportfolio-soxnang-2026 --index-document index.html
aws s3api put-public-access-block \
  --bucket myportfolio-soxnang-2026 \
  --public-access-block-configuration \
  "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
aws s3 sync src/ s3://myportfolio-soxnang-2026/
aws s3 sync assets/ s3://myportfolio-soxnang-2026/assets/
```

---

## Chapitre 6 — CI/CD GitHub Actions

### 6.1 Secrets GitHub
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 6.2 .github/workflows/deploy.yml
```yaml
name: Deploy MyPortfolio to AWS S3

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Récupérer le code
        uses: actions/checkout@v3

      - name: Configurer AWS CLI
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-west-3

      - name: Déployer sur S3
        run: |
          aws s3 sync src/ s3://myportfolio-soxnang-2026/
          aws s3 sync assets/ s3://myportfolio-soxnang-2026/assets/
```

---

## Chapitre 7 — Terraform

### 7.1 Installation
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor \
  -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform -y
terraform --version
```

### 7.2 terraform/main.tf
```hcl
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = "eu-west-3" }

resource "aws_s3_bucket" "portfolio" {
  bucket = "myportfolio-soxnang-terraform"
}

resource "aws_s3_bucket_website_configuration" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id
  index_document { suffix = "index.html" }
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.portfolio.website_endpoint
}
```

### 7.3 Commandes
```bash
terraform init     # Initialiser
terraform plan     # Prévisualiser
terraform apply    # Appliquer
terraform destroy  # Supprimer
```

---

## Chapitre 8 — Erreurs & Solutions

| Erreur | Cause | Solution |
|--------|-------|----------|
| `ls-la: not found` | Espace manquant | `ls -la` |
| `git init` dans /home | Mauvais dossier | `cd myportfolio` puis `git init` |
| Permission denied S3 | BlockPublicPolicy | Lancer `put-public-access-block` d'abord |
| workflow scope error | Token sans permission | Nouveau token avec `repo` + `workflow` |
| aws: path not exist | Hors de myportfolio/ | `cd ~/myportfolio` d'abord |
| E_UNEXPECTED WSL2 | WSL2 planté | `wsl --shutdown` puis `wsl` |

---

## Chapitre 9 — Architecture du projet
```
Code local (WSL2)
      ↓
git push → GitHub
      ↓
GitHub Actions (CI/CD)
      ↓
AWS S3 (hébergement statique)
```

### Structure des fichiers
```
myportfolio/
├── .github/workflows/deploy.yml
├── assets/css/style.css
├── docs/DOCUMENTATION.md
├── scripts/
│   ├── create-myportfolio.sh
│   └── deploy.sh
├── src/index.html
├── terraform/main.tf
├── .gitignore
├── docker-compose.yml
├── Dockerfile
└── README.md
```

### URLs
| Ressource | URL |
|-----------|-----|
| Code source | github.com/Soxnang/myportfolio |
| Site S3 | myportfolio-soxnang-2026.s3-website.eu-west-3.amazonaws.com |
| Site Terraform | myportfolio-soxnang-terraform.s3-website.eu-west-3.amazonaws.com |

---

*Soxnang — Parcours DevOps 12 semaines — Mars 2026*
