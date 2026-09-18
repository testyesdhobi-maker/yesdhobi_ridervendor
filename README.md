# 🧺 YesDhobi Rider & Vendor Partner App

A unified Flutter mobile application powering the logistics, fulfillment, and operations ecosystem for **YesDhobi** — connecting **Delivery Riders** and **Laundromat / Dry-Cleaning Vendors**.

---

## 📱 Features Overview

### 🚴‍♂️ Rider Partner Portal
- **Onboarding & Registration**: Multi-step registration flow covering personal information, vehicle details, bank accounts, and driving licenses.
- **Identity Verification**: Live in-app front camera selfie capture with edge guidelines and automated liveness/headshot verification.
- **Availability & Status**: Quick Online/Offline toggle with real-time duty status monitoring.
- **Order Dispatch & Notifications**:
  - Heads-up lock-screen & background alerts via `flutter_local_notifications`.
  - In-app incoming pickup dialog with interactive sound, countdown timer, and automatic order screen routing.
- **Pickup & Verification**: Item counting, cloth type segregation, damage notes, customer OTP verification, and bill calculation.
- **Drop-off to Vendor**: Route navigation, vendor arrival confirmation, and secure OTP drop-off handoff.
- **Earnings & History**: Real-time earnings tracker, payout request management, tip tracking, and historical order receipts.

---

### 🏪 Vendor Partner Portal
- **Dashboard & Analytics**: Daily order summary, pending deliveries, active processing workload, and revenue metrics.
- **Order Lifecycle Management**:
  - **New Orders**: Review incoming wash & dry-clean requests with customer preferences.
  - **Processing & Packing**: Item checklist, special instruction tags, and one-tap **"Mark as Packed"** status update.
  - **Rider Assignment**: Automated and manual rider booking with live rider arrival state and persistent OTP banner for pickup handoff.
- **Rates & Service Catalogue**: Comprehensive price card management for Wash & Fold, Wash & Iron, Steam Press, Dry Cleaning, and Express Delivery.
- **Financials & Settlements**: Weekly payout ledger, platform commission breakdown, and tax invoices.
- **Store Profile**: Operating hours, shop pictures, service radius, and contact management.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev/) (Dart SDK `^3.12.2`)
- **UI & Design**: Custom Material 3 Design system with Google Fonts (`Plus Jakarta Sans`), responsive cards, and clean status badges.
- **Camera & Media**: `camera` & `image_picker` for live verification and document uploads.
- **Notifications**: `flutter_local_notifications` with background desugaring support for high-priority dispatch alerts.
- **Navigation & Utilities**: `url_launcher` for GPS turn-by-turn navigation and calling.
- **Specifications & Schemas**: Dedicated `/schema` directory containing PostgreSQL & T-SQL database definitions and architectural contracts.

---

## 📂 Project Structure

```text
yesdhobi_ridervendor/
├── lib/
│   ├── models/            # Data models (Orders, Riders, Vendors, Earnings)
│   ├── screens/           # UI Screens (Rider & Vendor flows, Onboarding, Verification)
│   ├── services/          # Notification service, camera helpers, API clients
│   ├── utils/             # Constants, helpers, formatters
│   ├── widgets/           # Reusable UI widgets (cards, dialogs, buttons, banners)
│   ├── theme.dart         # Color palette, typography, and component themes
│   └── main.dart          # App entrypoint and route configuration
├── schema/                # Database & API contract specifications (29 schema docs)
├── android/               # Android native configuration with core desugaring
├── ios/                   # iOS configuration
└── pubspec.yaml           # Flutter dependencies and assets configuration
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.12+ or latest stable)
- Android Studio / VS Code with Flutter and Dart extensions
- Android Device or Emulator (API 26+ recommended) / iOS Simulator

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/testyesdhobi-maker/yesdhobi_ridervendor.git
   cd yesdhobi_ridervendor
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on connected device/emulator:**
   ```bash
   flutter run
   ```

---

## 📄 License & Confidentiality
Proprietary software belonging to **YesDhobi**. All rights reserved.
