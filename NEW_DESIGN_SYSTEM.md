# 🎨 BeMarket V2 - Modern Design System

## 🎨 Palette de couleurs (3 couleurs professionnelles)

### Primaire : Indigo électrique
```css
--primary-50:  #EEF2FF
--primary-100: #E0E7FF
--primary-500: #6366F1  /* Couleur principale */
--primary-600: #4F46E5
--primary-700: #4338CA
--primary-900: #312E81
```

### Secondaire : Cyan moderne
```css
--secondary-300: #67E8F9
--secondary-500: #06B6D4  /* Accent */
--secondary-600: #0891B2
--secondary-700: #0E7490
```

### Neutre : Slate premium
```css
--neutral-50:  #F8FAFC
--neutral-100: #F1F5F9
--neutral-200: #E2E8F0
--neutral-300: #CBD5E1
--neutral-400: #94A3B8
--neutral-500: #64748B
--neutral-600: #475569
--neutral-700: #334155
--neutral-800: #1E293B
--neutral-900: #0F172A
```

### Dark mode backgrounds
```css
--bg-dark-primary:   #0B1120
--bg-dark-secondary: #151B2B
--bg-dark-card:      rgba(30, 41, 59, 0.6)
```

---

## ✨ 3 Animations principales

### 1. Float Animation (cards hover)
```css
@keyframes float {
  0%, 100% { transform: translateY(0px) scale(1); }
  50% { transform: translateY(-8px) scale(1.02); }
}
```

### 2. Shimmer Loading
```css
@keyframes shimmer {
  0% { background-position: -1000px 0; }
  100% { background-position: 1000px 0; }
}
```

### 3. Fade Slide In (elements entry)
```css
@keyframes fadeSlideIn {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

---

## 💎 Glassmorphisme

### Glass Card (light mode)
```css
.glass-card-light {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 
    0 8px 32px rgba(31, 38, 135, 0.1),
    inset 0 0 20px rgba(255, 255, 255, 0.4);
}
```

### Glass Card (dark mode)
```css
.glass-card-dark {
  background: rgba(30, 41, 59, 0.4);
  backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.08);
  box-shadow: 
    0 8px 32px rgba(0, 0, 0, 0.3),
    inset 0 1px 1px rgba(255, 255, 255, 0.05);
}
```

---

## 🛍️ Product Card Style Avito

```
┌──────────────────────────────────┐
│  [Image with gradient overlay]   │ ← Hover: Scale 1.05
│  💎 Badge: Neuf                  │
│  ❤️ Favorite (absolute)          │
├──────────────────────────────────┤
│ 📦 Titre du produit              │ ← Truncate 2 lines
│ 📍 Cotonou • Il y a 2h          │ ← Small gray text
├──────────────────────────────────┤
│ 25,000 FCFA                      │ ← Bold primary color
│ ❤️ 12  👁️ 234                  │ ← Icons inline
└──────────────────────────────────┘
```

---

## 📱 Responsive Breakpoints

```css
/* Mobile first */
xs: 0px      → Mobile portrait
sm: 640px    → Mobile landscape
md: 768px    → Tablet portrait
lg: 1024px   → Tablet landscape / Desktop
xl: 1280px   → Desktop HD
2xl: 1536px  → Desktop Full HD
```

---

## 🔍 SEO Optimization

### Meta Tags essentiels
```html
<!-- Primary -->
<title>BeMarket Bénin - Marketplace #1 | Acheter & Vendre</title>
<meta name="description" content="BeMarket : marketplace leader au Bénin. Achetez et vendez facilement. Électronique, mode, immobilier, véhicules. Livraison rapide à Cotonou, Calavi, Porto-Novo.">
<meta name="keywords" content="marketplace bénin, achat vente bénin, bemarket, cotonou, calavi">

<!-- Open Graph (Facebook) -->
<meta property="og:title" content="BeMarket Bénin - Marketplace #1">
<meta property="og:description" content="Achetez et vendez facilement au Bénin">
<meta property="og:image" content="https://bemarket-benin.vercel.app/og-image.jpg">
<meta property="og:url" content="https://bemarket-benin.vercel.app">
<meta property="og:type" content="website">

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="BeMarket Bénin">
<meta name="twitter:description" content="Marketplace leader au Bénin">
<meta name="twitter:image" content="https://bemarket-benin.vercel.app/twitter-image.jpg">

<!-- Geo Tags -->
<meta name="geo.region" content="BJ">
<meta name="geo.placename" content="Cotonou">
<meta name="geo.position" content="6.3703;2.3912">
```

### Structured Data (JSON-LD)
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "BeMarket Bénin",
  "url": "https://bemarket-benin.vercel.app",
  "potentialAction": {
    "@type": "SearchAction",
    "target": "https://bemarket-benin.vercel.app/search?q={search_term_string}",
    "query-input": "required name=search_term_string"
  }
}
</script>
```

---

## 🌍 Géolocalisation

### Détection automatique
```javascript
// Geolocation API
navigator.geolocation.getCurrentPosition(
  (position) => {
    const { latitude, longitude } = position.coords;
    // Reverse geocoding pour obtenir la ville
    fetchCityFromCoords(latitude, longitude);
  },
  (error) => {
    // Fallback: IP Geolocation
    fetch('https://ipapi.co/json/')
      .then(res => res.json())
      .then(data => setCity(data.city));
  }
);
```

### Villes supportées
- Cotonou (6.3703, 2.3912)
- Abomey-Calavi (6.4485, 2.3556)
- Porto-Novo (6.4969, 2.6289)
- Parakou (9.3372, 2.6103)

---

## 🎯 Components Library

### Buttons
```css
/* Primary Button */
.btn-primary {
  background: linear-gradient(135deg, #6366F1 0%, #4F46E5 100%);
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 0.75rem;
  font-weight: 600;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 14px rgba(99, 102, 241, 0.3);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
}
```

### Input Fields
```css
.input-glass {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 0.75rem;
  padding: 0.875rem 1rem;
  transition: all 0.3s ease;
}

.input-glass:focus {
  border-color: #6366F1;
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
  background: rgba(255, 255, 255, 0.08);
}
```

---

## 📐 Spacing System

```css
--space-1: 0.25rem  /* 4px */
--space-2: 0.5rem   /* 8px */
--space-3: 0.75rem  /* 12px */
--space-4: 1rem     /* 16px */
--space-6: 1.5rem   /* 24px */
--space-8: 2rem     /* 32px */
--space-12: 3rem    /* 48px */
--space-16: 4rem    /* 64px */
```

---

## 🔤 Typography

### Font Stack
```css
--font-sans: 'Inter', 'Plus Jakarta Sans', system-ui, sans-serif;
--font-display: 'Space Grotesk', 'Cabinet Grotesk', sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;
```

### Scale
```css
--text-xs: 0.75rem      /* 12px */
--text-sm: 0.875rem     /* 14px */
--text-base: 1rem       /* 16px */
--text-lg: 1.125rem     /* 18px */
--text-xl: 1.25rem      /* 20px */
--text-2xl: 1.5rem      /* 24px */
--text-3xl: 1.875rem    /* 30px */
--text-4xl: 2.25rem     /* 36px */
--text-5xl: 3rem        /* 48px */
```

---

## ✅ Design Checklist

- [x] 3 couleurs professionnelles (Indigo, Cyan, Slate)
- [x] 3 animations fluides (float, shimmer, fadeSlideIn)
- [x] Glassmorphisme complet
- [x] Cards style Avito
- [x] Responsive mobile-first
- [x] SEO meta tags complets
- [x] Géolocalisation API
- [x] Dark mode natif
- [x] Accessibility (ARIA labels)
