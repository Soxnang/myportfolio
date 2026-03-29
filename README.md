# MyPortfolio — Projet DevOps

Site portfolio déployé sur AWS avec pipeline CI/CD complet.

## Architecture
```
Code local (WSL2)
      ↓
Git push → GitHub
      ↓
GitHub Actions (CI/CD)
      ↓
AWS S3 (hébergement statique)
```

## Stack technique

- Linux / WSL2
- Git & GitHub
- Docker & Docker Compose
- AWS S3 + IAM + CLI
- GitHub Actions (CI/CD)
- Terraform (Infrastructure as Code)

## Déploiement
```bash
# Déploiement manuel
ENV="production" ./scripts/deploy.sh

# Déploiement automatique
git push  # déclenche GitHub Actions
```

## URL du site

http://myportfolio-soxnang-2026.s3-website.eu-west-3.amazonaws.com

## Auteur

Soxnang — Parcours DevOps 12 semaines
