# QuoteSnap - iOS App Development Guide

## Executive Summary

**QuoteSnap** is a mobile-first estimate and invoice app built for independent contractors, freelancers, and small business owners in the US market. It solves the core pain point: creating professional quotes in 30 seconds from a phone, without the complexity and subscription costs of existing tools.

**Product Vision**: "Pay once. Quote forever." - The only estimate/invoice app with a one-time purchase model, no subscription, designed for the field.

**Core Differentiators**:
1. **Only one-time purchase** ($9.99) in a market dominated by $5-$69/month subscriptions
2. **30-second quote flow** - 4 taps from launch to send
3. **8 industry-specific templates** with preset line items and pricing
4. **Fully offline** - works on job sites with no internet
5. **SwiftUI native** - 60fps, not a web wrapper

**Target Users**: Independent contractors (plumbers, electricians, cleaners, landscapers, handymen, HVAC, painters), 1-5 person teams, $40K-$150K annual revenue, iPhone primary device.

**Technical Stack**: Swift + SwiftUI + SwiftData + PDFKit + CloudKit + StoreKit 2

---

## Competitive Analysis

| Feature | QuoteSnap | Joist | Invoice Simple | Quotation Maker | Housecall Pro |
|---------|-----------|-------|---------------|-----------------|---------------|
| **Price** | Free + $9.99 once | Free + $5.99/mo | Free + $4.99-$24.99/mo | Free + IAP | $69/mo+ |
| **1-Year Cost** | **$9.99** | $71.88 | $59.88-$299.88 | Varies | $828+ |
| **One-Time Purchase** | YES | NO | NO | NO | NO |
| **Quote→Invoice** | YES | YES | YES | YES | YES |
| **Industry Templates** | 8 | Limited | NO | NO | YES |
| **Mobile-First** | YES | YES | YES | YES | Partial |
| **Offline** | YES | Partial | NO | Partial | NO |
| **Branding** | YES | YES | Limited | YES | YES |
| **E-Signature** | YES (Pro) | YES | Limited | YES | YES |
| **Native SwiftUI** | YES | NO | NO | NO | NO |
| **CloudKit Sync** | YES (Pro) | Cloud | NO | Cloud | Cloud |

**Key Insight**: No competitor offers a one-time purchase. "No Subscription" is the single most powerful differentiator in the Business category where 95%+ apps use subscription pricing.

---

## Technical Architecture

```
QuoteSnap App
├── Views (SwiftUI)
│   ├── Quotes/ (QuoteListView, NewQuoteView, QuoteDetailView)
│   ├── Invoices/ (InvoiceListView, InvoiceDetailView)
│   ├── Clients/ (ClientListView, ClientFormView)
│   ├── Settings/ (SettingsView, BrandingView, PaywallView)
│   └── Shared/ (LineItemRow, StatusBadge, SignatureView)
├── ViewModels (@Observable)
│   ├── QuoteViewModel
│   ├── InvoiceViewModel
│   ├── ClientViewModel
│   └── SettingsViewModel
├── Models (SwiftData @Model)
│   ├── Quote
│   ├── Invoice
│   ├── Client
│   └── BusinessInfo
├── Services
│   ├── PDFGenerator (PDFKit)
│   ├── ShareService (MFMailCompose + UIActivityViewController)
│   ├── TemplateService (8 industry presets)
│   ├── QuoteService (CRUD + free tier logic)
│   ├── InvoiceService (CRUD + conversion)
│   ├── ClientService (CRUD + Contacts import)
│   └── PurchaseManager (StoreKit 2)
├── Utilities
│   ├── Constants (colors, strings)
│   ├── Extensions (Color+Theme, Date+Formatting, View+Helpers)
│   └── NumberFormatter+Currency
└── Storage
    ├── SwiftData (Local - default)
    └── CloudKit (Pro - optional sync)
```

---

## Module Structure & File Organization

```
QuoteSnap/
├── QuoteSnapApp.swift
├── ContentView.swift
├── Models/
│   ├── Quote.swift
│   ├── Invoice.swift
│   ├── Client.swift
│   ├── LineItem.swift
│   ├── BusinessInfo.swift
│   └── Enums.swift
├── Views/
│   ├── Quotes/
│   │   ├── QuoteListView.swift
│   │   ├── NewQuoteView.swift
│   │   ├── QuoteDetailView.swift
│   │   └── LineItemEditView.swift
│   ├── Invoices/
│   │   ├── InvoiceListView.swift
│   │   └── InvoiceDetailView.swift
│   ├── Clients/
│   │   ├── ClientListView.swift
│   │   └── ClientFormView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   ├── BrandingView.swift
│   │   ├── PaywallView.swift
│   │   └── ContactSupportView.swift
│   └── Shared/
│       ├── StatusBadge.swift
│       ├── TemplatePicker.swift
│       ├── SignatureView.swift
│       └── FreeQuoteCounter.swift
├── ViewModels/
│   ├── QuoteViewModel.swift
│   ├── InvoiceViewModel.swift
│   ├── ClientViewModel.swift
│   └── SettingsViewModel.swift
├── Services/
│   ├── PDFGenerator.swift
│   ├── ShareService.swift
│   ├── TemplateService.swift
│   ├── QuoteService.swift
│   ├── InvoiceService.swift
│   ├── ClientService.swift
│   └── PurchaseManager.swift
├── Utilities/
│   ├── Constants.swift
│   └── Extensions/
│       ├── Color+Theme.swift
│       ├── Date+Formatting.swift
│       └── View+Helpers.swift
└── Assets.xcassets/
    └── AppIcon.appiconset/
```

---

## Implementation Flow

### Step 1: Project Setup & Data Models
- Create Xcode project with SwiftUI, SwiftData
- Define Quote, Invoice, Client, BusinessInfo models
- Define enums: QuoteStatus, InvoiceStatus, TemplateType, DiscountType
- Define LineItem struct (Codable)

### Step 2: Core Services
- TemplateService: 8 industry presets with line items and pricing
- QuoteService: CRUD, free tier counting, auto-calculation
- InvoiceService: CRUD, quote-to-invoice conversion
- ClientService: CRUD, Contacts framework integration

### Step 3: Main Navigation & Quote List
- TabView: Quotes, Invoices, Settings
- QuoteListView with status filter (All/Draft/Sent/Accepted)
- Free quote counter banner for free users

### Step 4: Quote Creation Flow
- NewQuoteView: client selection, template picker, line items
- LineItemEditView: add/edit/delete line items
- Auto-calculation: subtotal, discount, tax, total

### Step 5: PDF Generation & Sharing
- PDFGenerator using PDFKit (US Letter format)
- Professional layout: logo, business info, line items table, totals
- ShareService: email (MFMailCompose) + system share (SMS/AirDrop)

### Step 6: Invoice Module
- InvoiceListView with status filter
- Quote-to-invoice one-tap conversion
- InvoiceDetailView with PDF preview

### Step 7: Client Management
- ClientListView with search
- ClientFormView with Contacts import
- Address management

### Step 8: Pro Features
- PurchaseManager with StoreKit 2 (Non-Consumable $9.99)
- PaywallView with feature comparison
- BrandingView: logo upload, brand color, company info
- SignatureView: on-screen customer signature

### Step 9: Settings & Support
- SettingsView with policy links, version info
- ContactSupportView with feedback form
- Restore purchases button

### Step 10: Polish & Testing
- Dark mode support
- iPad layout optimization
- Offline functionality verification
- Build and test on iPhone + iPad simulators

---

## UI/UX Design Specifications

### Design Principles (US Market 2025)

| Principle | Implementation |
|-----------|---------------|
| **Speed First** | Every action within 3 taps; large buttons; preset options |
| **Mobile Native** | SwiftUI components, gestures, haptic feedback |
| **Glove-Friendly** | Min 44x44pt touch targets; generous spacing |
| **Sunlight Readable** | High contrast; bold text; dark mode support |
| **Zero Learning** | Standard iOS patterns; intuitive layout |

### Color System

| Role | Color | Hex |
|------|-------|-----|
| Primary | Trust Blue | #1270C4 |
| Secondary | Teal Green | #2E9E8A |
| Accent | Warm Orange | #FF9C1E |
| Success | Green | #38BA59 |
| Danger | Red | #E63838 |
| Background | Light Gray | #F7F7FA |
| Card | White | #FFFFFF |
| Text Primary | Near Black | #212129 |
| Text Secondary | Gray | #737380 |

### Navigation Structure

- **Tab 1**: Quotes (list + create + detail)
- **Tab 2**: Invoices (list + detail)
- **Tab 3**: Settings (branding, pro upgrade, support, policies)

### Key Screen Layouts

**Quote List**: Status filter pills at top, card-based list, free counter banner at bottom, FAB for new quote

**New Quote**: Client picker, template selector, line items with add/edit, auto-calculated totals, preview & send buttons

**Quote Detail**: PDF preview, status actions (mark sent/accepted/declined), convert to invoice button, share options

**Paywall**: Feature comparison table, one-time $9.99 CTA, no dark patterns

---

## Code Generation Rules

1. Use Swift 6 strict concurrency
2. Use @Observable instead of ObservableObject
3. SwiftData with @Model macro
4. Naming: View=XxxView, Service=XxxService, Model=noun, Enum=noun
5. PDF generation via PDFKit only (no third-party)
6. All monetary values stored as Double, formatted on display
7. All dates stored as Date, formatted with DateFormatter
8. Colors via Color+Theme extension
9. Free tier logic centralized in QuoteService
10. No comments in code unless requested
11. iPad content: `.frame(maxWidth: 720).frame(maxWidth: .infinity)` for main ScrollView content
12. Never use `.tabViewStyle(.sidebarAdaptable)`
13. Use `Color.accentColor` instead of `ShapeStyle.accent`
14. Never hardcode version numbers - read from Bundle.main

---

## Testing & Validation Standards

### Functional Tests
- Create quote (blank + template) - full flow
- Contacts import - permission handling
- PDF generation - all fields display correctly
- Email send - PDF attachment opens correctly
- Quote-to-invoice conversion - data integrity
- Free tier 3/month limit - counting correct
- Pro upgrade - StoreKit purchase flow
- Brand logo upload - displays in PDF
- E-signature - saves and appears in PDF
- Dark mode - all screens adapted
- iPhone + iPad layout - both correct
- Offline mode - create/view quotes without network
- Data persistence - survives force quit

### Device Testing
- iPhone XS Max simulator (primary phone)
- iPad Pro 13-inch M4 simulator (primary tablet)

---

## Build & Deployment Checklist

- [ ] Xcode project configured with Bundle ID com.zzoutuo.QuoteSnap
- [ ] iOS Deployment Target set to 17.0
- [ ] SwiftData models compile without errors
- [ ] All SwiftUI views render correctly
- [ ] PDF generation produces valid PDFs
- [ ] StoreKit 2 purchase flow works in sandbox
- [ ] Build succeeds on both iPhone and iPad simulators
- [ ] No hardcoded secrets in source code
- [ ] App icon configured in Assets.xcassets
- [ ] Privacy permissions configured (Contacts, Camera for logo)
- [ ] Policy pages deployed to GitHub Pages
- [ ] App Store metadata prepared in keytext.md
