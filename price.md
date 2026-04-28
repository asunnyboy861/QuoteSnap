# Price Configuration

## Monetization Model
Non-Consumable In-App Purchase (One-Time Buyout)

## Pricing Strategy
- **Free Tier**: 3 quotes per month, 1 general template, basic PDF export
- **Pro Tier**: One-time purchase $9.99 — unlimited quotes, 8 industry templates, invoice conversion, branding, e-signature, CloudKit sync

## Product Configuration

### Free Tier (Always Available)
- **Type**: Free (limited features)
- **Features**: 
  - 3 quotes per month
  - 1 general template
  - Client management with contacts import
  - Standard PDF export
  - Email sharing
  - Auto-calculation (subtotal/tax/discount/total)
  - Local SwiftData storage

### Pro Tier (Non-Consumable IAP)
- **Reference Name**: QuoteSnap Pro
- **Product ID**: com.zzoutuo.QuoteSnap.premium
- **Price**: $9.99 (USD)
- **Type**: Non-consumable (One-time purchase, no renewal)
- **Localization (English US)**:
  - Display Name: QuoteSnap Pro (max 35 chars)
  - Description: Unlock unlimited quotes and all pro features (max 55 chars)

### Pro Features Unlocked
- Unlimited quotes (no monthly limit)
- 8 industry templates (Landscaping, Cleaning, Plumbing, Electrical, Handyman, HVAC, Painting, General)
- Quote-to-Invoice conversion
- Invoice management (create/edit/send)
- Brand customization (Logo upload + brand color + company info)
- Electronic signature
- iMessage/SMS sharing
- CloudKit sync (iPhone + iPad)
- AirPrint support
- PDF + CSV export

## App Store Connect Setup Instructions
1. Go to App Store Connect → Your App → In-App Purchases
2. Click "+" to create new IAP
3. Select "Non-Consumable"
4. Reference Name: QuoteSnap Pro
5. Product ID: com.zzoutuo.QuoteSnap.premium
6. Price: $9.99 (Tier 10)
7. Add localization: English (US)
   - Display Name: QuoteSnap Pro
   - Description: Unlock unlimited quotes and all pro features
8. Submit for review

## IAP Compliance Checklist
- [ ] Paywall displays product name
- [ ] Dynamic pricing from StoreKit (no hardcoded prices)
- [ ] Restore Purchases button implemented
- [ ] Privacy Policy link on paywall
- [ ] Terms of Use link on paywall
- [ ] NO dark patterns (no auto-selecting expensive options)
- [ ] Clear feature comparison between Free and Pro
