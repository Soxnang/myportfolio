#!/bin/bash

PROJECT=$1

if [ -d "$PROJECT" ]; then
  echo "ERREUR : le dossier $PROJECT existe déjà !"
  exit 1
fi

echo "=> Création du projet : $PROJECT"
mkdir -p $PROJECT/{src,assets/css,assets/images,scripts,docs}
touch $PROJECT/src/index.html
touch $PROJECT/assets/css/style.css
touch $PROJECT/README.md
echo "✓ $PROJECT créé avec succès !"
ls -R $PROJECT
