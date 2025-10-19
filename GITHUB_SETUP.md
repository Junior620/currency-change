# 🚀 GUIDE : Pousser le Projet sur GitHub

Ce guide vous accompagne étape par étape pour publier votre projet FXNow sur GitHub.

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir :

- ✅ Un compte GitHub (https://github.com)
- ✅ Git installé sur votre machine
  ```bash
  git --version  # Vérifier l'installation
  ```
- ✅ Git configuré avec votre identité
  ```bash
  git config --global user.name "Votre Nom"
  git config --global user.email "votre.email@example.com"
  ```

## 🎯 Étapes pour Publier sur GitHub

### Étape 1 : Créer le Repository sur GitHub

1. **Allez sur GitHub** : https://github.com
2. **Cliquez sur le bouton `+`** en haut à droite
3. **Sélectionnez `New repository`**
4. **Remplissez les informations** :
   - **Repository name** : `currency-change` (ou `fxnow-currency-converter`)
   - **Description** : `Application mobile Flutter de conversion de devises en temps réel avec support de 32+ devises`
   - **Visibilité** : `Public` (pour partager) ou `Private` (pour garder privé)
   - ⚠️ **NE cochez PAS** "Add a README file" (on l'a déjà)
   - ⚠️ **NE cochez PAS** "Add .gitignore" (on l'a déjà)
   - ⚠️ **NE cochez PAS** "Choose a license" (on l'a déjà)
5. **Cliquez sur `Create repository`**

### Étape 2 : Initialiser Git Localement

Ouvrez le terminal dans le dossier du projet et exécutez :

```bash
# Se placer dans le dossier du projet
cd C:\Users\junio\StudioProjects\untitled

# Initialiser Git (si pas déjà fait)
git init

# Vérifier le statut
git status
```

### Étape 3 : Ajouter les Fichiers au Staging

```bash
# Ajouter tous les fichiers
git add .

# Vérifier ce qui va être commité
git status
```

### Étape 4 : Créer le Premier Commit

```bash
# Créer le commit initial
git commit -m "Initial commit: FXNow - Currency Converter App

- Add complete Flutter project structure
- Implement currency conversion feature with 32+ currencies
- Add Material Design 3 UI with light/dark themes
- Implement i18n (EN/FR)
- Add offline cache support
- Complete documentation (README, LICENSE, docs)"
```

### Étape 5 : Configurer la Branche Main

```bash
# Renommer la branche en 'main' (standard GitHub)
git branch -M main
```

### Étape 6 : Connecter au Repository GitHub

Remplacez `Junior620` par votre nom d'utilisateur GitHub :

```bash
# Ajouter l'origine distante
git remote add origin https://github.com/Junior620/currency-change.git

# Vérifier
git remote -v
```

### Étape 7 : Pousser le Code

```bash
# Pousser vers GitHub
git push -u origin main
```

**Si vous avez une erreur d'authentification**, utilisez un Personal Access Token :
1. Allez sur GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. Cochez `repo` et générez
4. Utilisez ce token comme mot de passe lors du push

## ✅ Vérification

Après le push, vérifiez sur GitHub :
- Votre code est visible
- Le README s'affiche correctement
- La LICENSE est présente
- Les fichiers sont bien organisés

## 🎨 Améliorer le Repository (Optionnel)

### Ajouter des Screenshots

1. Créez un dossier `screenshots/` à la racine
2. Ajoutez vos captures d'écran
3. Commitez et pushez :
   ```bash
   git add screenshots/
   git commit -m "Docs: Add app screenshots"
   git push
   ```

### Ajouter des Topics (Tags)

Sur GitHub, dans votre repository :
1. Cliquez sur ⚙️ à côté de "About"
2. Ajoutez des topics : `flutter`, `dart`, `currency-converter`, `mobile-app`, `material-design`

### Activer GitHub Pages (pour la documentation)

1. Allez dans Settings → Pages
2. Source : Deploy from a branch
3. Branch : main → /docs (ou /root)
4. Save

## 🔄 Commandes Git Utiles pour la Suite

### Ajouter des Modifications

```bash
# Voir les changements
git status

# Ajouter des fichiers spécifiques
git add chemin/vers/fichier.dart

# Ou ajouter tous les changements
git add .

# Commiter
git commit -m "Type: Description du changement"

# Pousser
git push
```

### Types de Commits Recommandés

- `Add:` Nouvelle fonctionnalité
- `Fix:` Correction de bug
- `Refactor:` Refactoring du code
- `Docs:` Documentation
- `Style:` Formatage du code
- `Test:` Ajout de tests
- `Chore:` Maintenance

### Créer une Nouvelle Branche

```bash
# Créer et basculer sur une nouvelle branche
git checkout -b feature/nouvelle-fonctionnalite

# Travailler sur la branche...

# Pousser la branche
git push -u origin feature/nouvelle-fonctionnalite
```

### Fusionner une Branche

```bash
# Retourner sur main
git checkout main

# Mettre à jour
git pull

# Fusionner la branche
git merge feature/nouvelle-fonctionnalite

# Pousser
git push
```

## 🐛 Résolution de Problèmes

### Erreur : "Authentication failed"

**Solution** : Utilisez un Personal Access Token au lieu du mot de passe.

### Erreur : "Repository not found"

**Solution** : Vérifiez l'URL du repository :
```bash
git remote -v
git remote set-url origin https://github.com/VOTRE_USERNAME/VOTRE_REPO.git
```

### Erreur : "failed to push some refs"

**Solution** : Synchronisez d'abord avec le distant :
```bash
git pull origin main --rebase
git push origin main
```

### Fichiers trop volumineux

**Solution** : Utilisez Git LFS pour les gros fichiers :
```bash
git lfs install
git lfs track "*.apk"
git add .gitattributes
git commit -m "Add: Git LFS tracking"
```

## 📞 Besoin d'Aide ?

- 📚 [Documentation Git](https://git-scm.com/doc)
- 📚 [Guide GitHub](https://docs.github.com)
- 💬 [Stack Overflow](https://stackoverflow.com/questions/tagged/git)

---

**🎉 Félicitations ! Votre projet est maintenant sur GitHub !**

