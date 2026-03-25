#!/bin/bash

echo "================================"
echo " Déploiement de $PROJECT_NAME"
echo " Environnement : $ENV"
echo " Auteur : $AUTHOR"
echo " Version : $VERSION"
echo "================================"

if [ "$ENV" = "production" ]; then
  echo "🚀 Déploiement en PRODUCTION sur AWS..."
elif [ "$ENV" = "development" ]; then
  echo "🛠  Mode développement — pas de déploiement AWS"
else
  echo "❌ Environnement inconnu : $ENV"
  exit 1
fi
