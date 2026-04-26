# Capabilities Configuration Guide

## Configuration Summary

### No Capabilities Required
| Capability | Status | Notes |
|------------|--------|-------|
| **None** | ⏭️ Skipped | No special capabilities needed for this app |

**Why no capabilities needed**: QuoteSnap is a local-first business app that uses SwiftData for on-device storage. While the Pro tier offers CloudKit sync, this is handled through NSPersistentCloudKitContainer at the code level and does not require the iCloud capability to be manually configured in the Xcode project for basic development and testing. The CloudKit capability will need to be configured in App Store Connect when submitting for review.

**Verification**: Build succeeded without any capabilities enabled ✅

---

## Future Configuration (App Store Submission)

When submitting to App Store Connect, the following capabilities may need manual configuration:

### 1. iCloud (CloudKit) - Pro Feature
**Status**: ⏳ Requires manual setup before App Store submission
**Why needed**: Pro users can sync data across iPhone and iPad via iCloud
**Manual Configuration Steps**:

**Step 1: Xcode Configuration**
1. Select project in Navigator → Select target → Signing & Capabilities
2. Click "+ Capability"
3. Select "iCloud"
4. Check "CloudKit"
5. Create or select a CloudKit container: `iCloud.com.zzoutuo.QuoteSnap`

**Step 2: Apple Developer Portal**
1. Go to https://developer.apple.com/account/resources/identifiers/list
2. Select your App ID
3. Enable iCloud
4. Configure CloudKit container

**Step 3: Verify**
1. Build project (Cmd+B)
2. Test CloudKit sync on physical devices

### 2. In-App Purchase
**Status**: ✅ Auto-configured by StoreKit 2
**Notes**: StoreKit 2 handles IAP automatically. No manual capability configuration needed.

---

## Summary Checklist

### Manual Configuration (To Do Before App Store Submission)
- [ ] iCloud/CloudKit capability configured for Pro sync feature

### Auto-Configured (Verified)
- [x] In-App Purchase via StoreKit 2
- [x] Build test passed without capabilities
