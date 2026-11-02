# 🛒 BE-MARKET Bénin

**Plateforme de marketplace inspirée d'Avito.ru pour le marché béninois**

[![Deployed on Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-black?logo=vercel)](https://bemarket-benin.vercel.app)
[![GitHub Pages](https://img.shields.io/badge/GitHub-Pages-brightgreen?logo=github)](https://newgentrade01-web.github.io/bemarket/)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase)](https://supabase.com)

---

## 🌟 Fonctionnalités

### ✅ Version Actuelle (V1)
- 🎨 Design moderne avec Tailwind CSS 4
- 🇧🇯 Thème couleurs Bénin (Vert, Jaune, Rouge)
- 🔍 Barre de recherche IA sémantique
- 📱 Responsive (mobile-first)
- 🌙 Support dark mode natif
- 🛍️ Catalogue produits avec filtres
- 📍 Sélecteur de ville (Cotonou, Calavi, Porto-Novo)
- 💬 WhatsApp intégration directe
- 🎯 Section Best-Sellers

### 🚧 En développement (V2 - Avito-inspired)
- 🔐 Authentification utilisateurs (Supabase Auth)
- ❤️ Système de favoris
- 💼 Dashboard vendeur
- 💬 Chat temps réel
- 📊 Analytics produits (vues, clics)
- 🔔 Notifications
- 📸 Upload multi-images
- 🔍 Recherche full-text avancée
- ⭐ Système de notation

---

## 🚀 URLs de déploiement

- **Production (Vercel)** : [bemarket-benin.vercel.app](https://bemarket-benin.vercel.app) *(à configurer)*
- **GitHub Pages** : [newgentrade01-web.github.io/bemarket](https://newgentrade01-web.github.io/bemarket/) ✅ **LIVE**

---

## 📁 Structure du projet

```
BeMarket/
├── index.html                           # Page principale
├── js/
│   └── supabase-client.js              # Client Supabase (API)
├── supabase/
│   ├── config.toml                     # Config Supabase
│   └── migrations/
│       └── 001_initial_schema.sql      # Schema BDD
├── vercel.json                          # Config Vercel
├── .env.example                         # Template variables d'env
├── DEPLOYMENT_GUIDE.md                  # 📖 Guide déploiement complet
├── AVITO_IMPROVEMENTS.md                # 🎯 Roadmap améliorations
└── README.md                            # Ce fichier

```

---

## 🛠️ Stack Technique

| Catégorie | Technologie |
|-----------|-------------|
| **Frontend** | HTML5, Tailwind CSS 4, Vanilla JS |
| **Backend** | Supabase (PostgreSQL, Auth, Storage, Realtime) |
| **Déploiement** | Vercel + GitHub Pages |
| **Fonts** | Plus Jakarta Sans, Cabinet Grotesk |
| **Icons** | FontAwesome 6 |
| **Paiements** | MoMo, Celtiis, Cash (à la livraison) |

---

## 🏗️ Installation locale

```bash
# 1. Cloner le repo
git clone https://github.com/newgentrade01-web/BeMarket.git
cd BeMarket

# 2. Installer un serveur local (optionnel)
npx serve .
# ou
python -m http.server 5173

# 3. Ouvrir dans le navigateur
open http://localhost:5173
```

### Configuration Supabase (pour V2) :
```bash
# 1. Copier le template
cp .env.example .env

# 2. Éditer .env avec vos clés Supabase
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbG...

# 3. Exécuter la migration SQL
# → Copier `supabase/migrations/001_initial_schema.sql` dans Supabase SQL Editor
```

Voir **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** pour le guide complet.

---

## 📖 Documentation

- **[DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md)** : Guide de déploiement Vercel + Supabase
- **[AVITO_IMPROVEMENTS.md](./AVITO_IMPROVEMENTS.md)** : Analyse Avito.ru + Roadmap V2
- **[supabase/migrations/](./supabase/migrations/)** : Schéma base de données

---

## 🎨 Design System

### Couleurs
```css
--bj-green:  #008751   /* Drapeau Bénin */
--bj-yellow: #FCD116   /* Drapeau Bénin */
--bj-red:    #E8112D   /* Drapeau Bénin */
--dark-bg:   #070b14   /* Fond principal */
```

### Polices
- **Display** : Cabinet Grotesk (titres)
- **Body** : Plus Jakarta Sans (texte)

---

## 🌍 Localisation

- 🇧🇯 **Pays** : Bénin
- 🏙️ **Villes couvertes** : 
  - Cotonou (livraison 24h)
  - Abomey-Calavi (livraison 24h)
  - Porto-Novo (livraison 24-48h)
- 💰 **Devise** : Franc CFA (XOF)
- 📞 **Support** : [+229 01 99 00 11](https://wa.me/22901990011)

---

## 📊 Analytics

- ✅ GitHub Pages deployment : **ACTIF**
- ⏳ Vercel deployment : **En attente**
- 🔜 Google Analytics : **À configurer**
- 🔜 Supabase Analytics : **À activer**

---

## 🤝 Contribution

Ce projet est privé. Pour contribuer :
1. Créer une branche : `git checkout -b feature/nom-feature`
2. Commit : `git commit -m "feat: description"`
3. Push : `git push origin feature/nom-feature`
4. Créer une Pull Request

---

## 📄 Licence

© 2026 BE-MARKET Bénin. Tous droits réservés.

---

## 🔗 Liens utiles

- **GitHub** : [newgentrade01-web/bemarket](https://github.com/newgentrade01-web/bemarket)
- **Supabase** : [Dashboard](https://supabase.com/dashboard)
- **Vercel** : [Dashboard](https://vercel.com/dashboard)
- **Design Inspiration** : [Avito.ru](https://www.avito.ru)

---

## 📞 Contact

- **WhatsApp** : +229 01 99 00 11
- **Email** : contact@bemarket.bj *(à configurer)*
- **GitHub** : [@newgentrade01-web](https://github.com/newgentrade01-web)