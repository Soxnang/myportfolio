#!/bin/bash

echo "================================"
echo " Déploiement de $PROJECT_NAME"
echo " Environnement : $ENV"
echo " Auteur : $AUTHOR"
echo " Version : $VERSION"
echo "================================"

if [ "$ENV" = "production" ]; then
  echo "🚀 Déploiement en PRODUCTION sur AWS S3..."
  aws s3 sync src/ s3://myportfolio-soxnang-2026/
  aws s3 sync assets/ s3://myportfolio-soxnang-2026/assets/
  echo "✅ Site déployé sur AWS !"
  echo "🌍 URL : http://myportfolio-soxnang-2026.s3-website.eu-west-3.amazonaws.com"
elif [ "$ENV" = "development" ]; then
  echo "🛠  Mode développement — déploiement local uniquement"
  docker compose up -d
  echo "✅ Site disponible sur http://localhost"
else
  echo "❌ Environnement inconnu : $ENV"
  exit 1
fi
