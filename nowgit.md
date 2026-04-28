# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | QuoteSnap |
| **Git URL** | git@github.com:asunnyboy861/QuoteSnap.git |
| **Repo URL** | https://github.com/asunnyboy861/QuoteSnap |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository)

| Item | Value |
|------|-------|
| **Repository** | QuoteSnap (main repo) |
| **Pages Source** | `/docs` folder |
| **GitHub Pages** | ✅ **ENABLED** |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/QuoteSnap/ | ✅ Active |
| Support | https://asunnyboy861.github.io/QuoteSnap/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/QuoteSnap/privacy.html | ✅ Active |

**Note**: Terms of Use not required for one-time purchase (non-consumable IAP) apps.

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
├── docs/                            # GitHub Pages (Policy Pages)
│   ├── index.html                   # Landing Page
│   ├── support.html                 # Support Page
│   └── privacy.html                 # Privacy Policy
├── .github/workflows/
│   └── deploy.yml                   # GitHub Pages deployment
├── us.md                            # English Development Guide
├── keytext.md                       # App Store Metadata
├── capabilities.md                  # Capabilities Configuration
├── icon.md                          # App Icon Details
├── price.md                         # Pricing Configuration
├── screenshots/                     # App Store Screenshots
│   ├── ipad_*.png                   # iPad screenshots
│   └── iphone_*.png                 # iPhone screenshots
└── nowgit.md                        # This File
```
