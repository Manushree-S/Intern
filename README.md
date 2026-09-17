# [CLIENT NAME] - Institution-Centric EdTech Mobile Platform

Production-ready cross-platform mobile application engineered for **[CLIENT NAME]**, delivering a centralized learning management platform for students from Grade 7 through higher grades, faculty educators, and non-technical school administrators.

---

## 1. Core Purpose & Architectural Model

Unlike generic consumer B2C learning applications, this system is an **institution-centric platform**:
- **No Public Signup**: All student and teacher accounts are created, provisioned, and managed by the institution.
- **Three Distinct User Roles**:
  1. **Student**: Course access, YouTube video lessons, quiz assessments, assignment submissions, attendance logs, and personal progress tracking.
  2. **Staff / Teacher**: Class roster view, daily attendance marking, assignment evaluation with score overrides, and class progress analytics. (Strictly zero access to fees or financial records).
  3. **Non-Technical Staff / Admin**: Institutional roster management, bulk user CSV imports, class/section allocations, fee invoicing, and administrative reports. (Strictly zero access to academic content, quizzes, submissions, or grading).
- **Enforced at Both UI & Server Level**: Role segregation is guarded both synchronously in Flutter GoRouter and enforced at the server-level via Cloud Firestore Security Rules.

---

## 2. Technology Stack

- **Framework**: Flutter (Latest Stable 3.x), Dart 3.x (Sound null-safety)
- **Architecture**: Clean Architecture (Presentation, Domain, Data) with Unidirectional Data Flow
- **State Management & DI**: `flutter_riverpod` (v2.x) with code generation (`riverpod_generator`)
- **Navigation**: `go_router` with synchronous role-guard redirects
- **Backend**: Firebase (Authentication, Cloud Firestore, Cloud Functions v2, Firebase Storage, Cloud Messaging)
- **Video Engine**: `youtube_player_iframe` with abstracted `VideoPlayerInterface` for unlisted lessons
- **Payments**:
  - Android: `razorpay_flutter` (Server-side HMAC-SHA256 signature verification)
  - iOS: `in_app_purchase` / StoreKit (Server-side Apple App Store Server API verification)
- **Security & Privacy**: Strict Firestore Security Rules, COPPA-aligned child privacy (no ad networks, zero behavioral profiling)
- **Crash Reporting & Analytics**: Firebase Crashlytics & Privacy-compliant Firebase Analytics

---

## 3. Project Directory Structure

```
lib/
├── main.dart                          # App entry point, environment loading, error zones
├── app.dart                           # Root MaterialApp with GoRouter and Global Theme
├── core/
│   ├── constants/                     # Colors, typography, API keys, storage keys
│   ├── errors/                        # Typed domain failures & exceptions
│   ├── network/                       # Connectivity monitoring & offline fallbacks
│   ├── routing/                       # GoRouter definition with synchronous role guards
│   ├── services/                      # Crashlytics, Analytics, RemoteConfig
│   ├── theme/                         # Material 3 Light/Dark themes & ClientBranding
│   └── widgets/                       # Reusable buttons, inputs, loading, error, empty states
│
├── features/
│   ├── auth/                          # Login, first-login password change, recovery, deactivation
│   ├── student/                       # Student dashboard & navigation shell
│   ├── teacher/                       # Educator dashboard & class controls
│   ├── admin/                         # Admin roster, CSV import, fees & audit reports
│   ├── courses/                       # Course catalog & syllabus details
│   ├── lessons/                       # YouTube player & watch progress sync
│   ├── quizzes/                       # Assessments, timer, instant scoring
│   ├── assignments/                   # Submission uploads & teacher evaluations
│   ├── attendance/                    # Roll call marking & attendance calculations
│   ├── progress/                      # Learning streak & completion analytics
│   ├── payments/                      # Platform-abstracted Razorpay / StoreKit
│   ├── notifications/                 # FCM push routing & in-app notification inbox
│   └── profile/                       # Child-safe profile & password updates
```

---

## 4. Running the Application Locally

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Configure Environment**:
   Copy `.env.example` to `.env` and fill in development Firebase project credentials:
   ```bash
   cp .env.example .env
   ```

3. **Run Code Generation** (if updating Riverpod annotations):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run Unit & Widget Tests**:
   ```bash
   flutter test
   ```

5. **Start Flutter Client**:
   ```bash
   flutter run -d chrome       # Web (or connected iOS/Android device/emulator)
   ```
