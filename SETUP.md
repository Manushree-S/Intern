# Environment Setup & Deployment Guide

This guide covers complete step-by-step instructions to configure, run, test, and build the **[CLIENT NAME]** EdTech mobile application.

---

## 1. Prerequisites

- **Flutter SDK**: `3.16.0` or higher (stable channel)
- **Dart SDK**: `3.2.0` or higher
- **Node.js**: `20.x LTS` (for Firebase Cloud Functions)
- **Firebase CLI**: `npm install -g firebase-tools`
- **Android Studio** & Android SDK (API Level 34)
- **Xcode** 15+ & CocoaPods (for iOS macOS builds)

---

## 2. Environment Variables Configuration

1. In the root directory, copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Fill in the required parameters:
   - `ENVIRONMENT`: `development` | `staging` | `production`
   - `APP_NAME`: Display branding for the institution
   - `CLIENT_INSTITUTION_ID`: Tenant identifier (e.g. `inst_pilot_001`)
   - `FIREBASE_*`: Extracted from Firebase Console project settings
   - `RAZORPAY_KEY_ID`: Android Razorpay Public Key ID (**DO NOT store secret key here**)
   - `APPLE_MERCHANT_ID`: Apple Developer merchant identifier

---

## 3. Firebase Project Configuration

### A. Authentication Setup
1. Open the [Firebase Console](https://console.firebase.google.com/).
2. Enable **Email/Password** authentication provider.
3. Enable **Google Sign-In** and configure SHA-1 and SHA-256 fingerprints from your Android keystore.
4. Enable **Apple Sign-In**:
   - Register Services ID in Apple Developer portal.
   - Configure Apple Private Key and Team ID in Firebase Auth.
5. **Disable Public Signup**: Disable any self-registration hooks; all users are created via the Admin Cloud Function.

### B. Firestore Database & Security Rules
1. Initialize Cloud Firestore in your preferred geographic region (e.g., `asia-south1` or `us-central1`).
2. Deploy the verified security rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

### C. Cloud Storage Configuration
1. Initialize Firebase Storage for assignment submissions and fee receipts.
2. Deploy storage rules ensuring students can only write to their own submission folders:
   ```bash
   firebase deploy --only storage
   ```

### D. Cloud Functions Deployment
1. Navigate to the functions directory:
   ```bash
   cd functions
   npm install
   ```
2. Set Cloud Functions Secrets using Google Cloud Secret Manager:
   ```bash
   firebase functions:secrets:set RAZORPAY_KEY_SECRET
   firebase functions:secrets:set APPLE_STOREKIT_PRIVATE_KEY
   ```
3. Deploy functions:
   ```bash
   firebase deploy --only functions
   ```

---

## 4. Payment Gateway Setup

### Android (Razorpay)
1. Register on Razorpay Dashboard and obtain **Key ID** (Public) and **Key Secret**.
2. Put `RAZORPAY_KEY_ID` into `.env`.
3. Add `RAZORPAY_KEY_SECRET` exclusively into Firebase Cloud Functions Secrets.
4. Server-side verification function `verifyRazorpayPayment` verifies HMAC-SHA256 signatures before unlocking content or marking fee records paid.

### iOS (Apple In-App Purchase / StoreKit)
1. In App Store Connect, configure in-app purchase products under your App ID.
2. Generate App Store Server API credentials (Key ID, Issuer ID, Private Key).
3. Cloud Function `verifyAppleReceipt` verifies JWS transaction tokens directly against Apple's production / sandbox endpoints.

---

## 5. Building for Release

### Android Release (.aab)
> [!IMPORTANT]
> The primary release artifact for Google Play Store must be an Android App Bundle (`.aab`), not an APK.

1. Ensure release keystore is configured in `android/key.properties`.
2. Execute:
   ```bash
   flutter build appbundle --release --dart-define=ENVIRONMENT=production
   ```
3. Output located at: `build/app/outputs/bundle/release/app-release.aab`.

### iOS Release (App Store / TestFlight)
1. Open iOS workspace in Xcode:
   ```bash
   cd ios && pod install && open Runner.xcworkspace
   ```
2. Ensure correct Development Team, Signing Certificate, and Provisioning Profile are selected.
3. Build archive:
   ```bash
   flutter build ipa --release --dart-define=ENVIRONMENT=production
   ```
4. Upload via Xcode Organizer or Transporter to Apple TestFlight.

---

## 6. Staging vs Production Best Practices

- **Dev/Staging**: Use Firebase App Distribution and TestFlight Internal Testing. All data should be synthetic.
- **Production**: External testers must **never** test against real student records.
- **COPPA Compliance**: Ensure no behavioral ads are injected, and child data collection is strictly bounded to functional academic records.
