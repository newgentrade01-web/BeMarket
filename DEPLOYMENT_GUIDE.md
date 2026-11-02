# 🚀 Guide de Déploiement BeMarket

## 📋 Prérequis

- Compte [Supabase](https://supabase.com) (gratuit)
- Compte [Vercel](https://vercel.com) (gratuit)
- Node.js 18+ installé localement

---

## 🗄️ Étape 1 : Configuration Supabase

### 1.1 Créer le projet
1. Aller sur [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Cliquer sur "New Project"
3. Nom : `bemarket-benin`
4. Database Password : *générer un mot de passe fort*
5. Region : *choisir la plus proche (ex: Frankfurt)*
6. Cliquer "Create new project"

### 1.2 Exécuter les migrations SQL
1. Dans le dashboard Supabase, aller dans **SQL Editor**
2. Cliquer "New query"
3. Copier-coller le contenu de `supabase/migrations/001_initial_schema.sql`
4. Cliquer "Run" ou `Ctrl+Enter`
5. Vérifier qu'il n'y a pas d'erreurs

### 1.3 Configurer Storage
1. Aller dans **Storage** dans la sidebar
2. Créer un nouveau bucket : `products`
3. Public : **OUI** (pour afficher les images)
4. Allowed MIME types : `image/jpeg, image/png, image/webp`
5. Max file size : `5MB`

### 1.4 Récupérer les clés API
1. Aller dans **Settings** → **API**
2. Copier :
   - **Project URL** : `https://xxxxx.supabase.co`
   - **anon public key** : `eyJhbG...`

---

## ⚡ Étape 2 : Déploiement Vercel

### Option A : Déploiement via CLI (Recommandé)

```bash
# 1. Se connecter à Vercel
vercel login

# 2. Déployer depuis le dossier BeMarket
cd BeMarket
vercel

# 3. Suivre les prompts :
#    - Set up and deploy? Yes
#    - Which scope? [Votre compte]
#    - Link to existing project? No
#    - Project name? bemarket-benin
#    - Directory? ./ (laisser par défaut)
#    - Override settings? No

# 4. Ajouter les variables d'environnement
vercel env add VITE_SUPABASE_URL
# Coller : https://xxxxx.supabase.co

vercel env add VITE_SUPABASE_ANON_KEY
# Coller : eyJhbG...

# 5. Redéployer avec les env vars
vercel --prod
```

### Option B : Déploiement via GitHub (UI)

1. **Push sur GitHub** (déjà fait ✅)
2. Aller sur [https://vercel.com/new](https://vercel.com/new)
3. **Import Git Repository** → Sélectionner `newgentrade01-web/BeMarket`
4. **Configure Project** :
   - Framework Preset : `Other`
   - Build Command : *laisser vide*
   - Output Directory : `.`
5. **Environment Variables** :
   ```
   VITE_SUPABASE_URL = https://xxxxx.supabase.co
   VITE_SUPABASE_ANON_KEY = eyJhbG...
   ```
6. Cliquer **Deploy**

---

## 🔗 Étape 3 : Configurer le domaine (Optionnel)

### Sur Vercel :
1. Aller dans **Project Settings** → **Domains**
2. Ajouter un domaine :
   - `bemarket.bj` (si vous en avez un)
   - Ou utiliser : `bemarket-benin.vercel.app` (gratuit)

### Configurer DNS (si domaine custom) :
```
Type    Name    Value
A       @       76.76.21.21
CNAME   www     cname.vercel-dns.com
```

---

## ✅ Étape 4 : Vérification Post-Déploiement

### Tester l'URL de production :
```
https://bemarket-benin.vercel.app (ou votre domaine)
```

### Checklist :
- [ ] Site accessible en HTTPS
- [ ] Images chargent correctement
- [ ] Console browser sans erreurs Supabase
- [ ] Test création compte utilisateur
- [ ] Test favoris (nécessite connexion)
- [ ] Recherche fonctionne

---

## 🛠️ Maintenance & Mises à jour

### Déployer une mise à jour :
```bash
# Depuis le dossier BeMarket
git add .
git commit -m "feat: nouvelle fonctionnalité"
git push origin main

# Vercel déploie automatiquement !
# Ou manuellement :
vercel --prod
```

### Voir les logs :
```bash
vercel logs [deployment-url]
```

---

## 🔐 Sécurité

### Variables sensibles à NE JAMAIS commit :
- ❌ `.env` (déjà dans `.gitignore`)
- ❌ Clés Supabase `service_role` key
- ❌ Tokens d'API tiers

### Row Level Security (RLS) :
Les tables Supabase ont RLS activé par défaut :
- `products` : lecture publique, écriture propriétaire
- `favorites` : lecture/écriture utilisateur uniquement
- `users` : lecture/écriture profil utilisateur

---

## 📊 Analytics (Optionnel)

### Vercel Analytics :
```bash
vercel analytics enable
```

### Google Analytics :
Ajouter dans `<head>` du `index.html` :
```html
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

---

## 🐛 Troubleshooting

### Erreur "Supabase URL not defined" :
```bash
# Vérifier les env vars sur Vercel
vercel env ls

# Re-ajouter si manquantes
vercel env add VITE_SUPABASE_URL production
```

### Build failed sur Vercel :
- Vérifier que `vercel.json` est bien présent
- S'assurer qu'il n'y a pas de fichiers JS avec erreurs de syntaxe

### Images ne s'affichent pas :
- Vérifier que le bucket `products` est **public**
- Tester l'URL directement : `https://xxxxx.supabase.co/storage/v1/object/public/products/test.jpg`

---

## 📚 Ressources

- [Supabase Docs](https://supabase.com/docs)
- [Vercel Docs](https://vercel.com/docs)
- [GitHub Repo](https://github.com/newgentrade01-web/BeMarket)
- [Avito Design System](https://medium.com/avitotech/how-the-avito-design-system-library-in-figma-works-375499235612)

---

## 🎯 Prochaines étapes

Voir `AVITO_IMPROVEMENTS.md` pour :
- [ ] Système d'authentification complet
- [ ] Dashboard utilisateur
- [ ] Chat temps réel
- [ ] Notifications push
- [ ] PWA (Progressive Web App)
- [ ] SEO avancé
