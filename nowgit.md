# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | QuoteSnap |
| **Git URL** | git@github.com:asunnyboy861/QuoteSnap.git |
| **Repo URL** | https://github.com/asunnyboy861/QuoteSnap |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ❌ **DISABLED** (iOS app distributed via App Store) |

## Policy Pages (Separate Repository)

| Item | Value |
|------|-------|
| **Repository Name** | QuoteSnap-pages |
| **Git URL** | git@github.com:asunnyboy861/QuoteSnap-pages.git |
| **Repo URL** | https://github.com/asunnyboy861/QuoteSnap-pages |
| **Visibility** | Public |
| **GitHub Pages** | ✅ **ENABLED** |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/QuoteSnap-pages/ | ⏳ Pending |
| Support | https://asunnyboy861.github.io/QuoteSnap-pages/support.html | ⏳ Pending |
| Privacy Policy | https://asunnyboy861.github.io/QuoteSnap-pages/privacy.html | ⏳ Pending |
| Terms of Use | https://asunnyboy861.github.io/QuoteSnap-pages/terms.html | ⏳ Pending |

## Repository Structure

### Main App Repository
```
QuoteSnap/
├── QuoteSnap/                       # iOS App Source Code
│   ├── QuoteSnap.xcodeproj/         # Xcode Project
│   └── QuoteSnap/                   # Swift Source Files
│       ├── Views/
│       ├── Models/
│       ├── Services/
│       ├── ViewModels/
│       └── Utilities/
├── us.md                            # English Development Guide
├── keytext.md                       # App Store Metadata
├── capabilities.md                  # Capabilities Configuration
├── icon.md                          # App Icon Details
├── price.md                         # Pricing Configuration
└── nowgit.md                        # This File
```

### Policy Pages Repository
```
QuoteSnap-pages/
├── index.html                       # Landing Page
├── support.html                     # Support Page
├── privacy.html                     # Privacy Policy
├── terms.html                       # Terms of Use
└── .github/workflows/deploy.yml     # GitHub Pages deployment
```
