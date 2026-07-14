# 🌿 Salem App

A feature-rich Flutter mobile application for salon discovery, loyalty rewards, and appointment management. Built with **GetX** state management, **Firebase** services, and a clean layered architecture.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Project Architecture](#project-architecture)
- [Folder Structure](#folder-structure)
- [Key Features](#key-features)
- [Getting Started](#getting-started)

---

## Overview

Salem App is a Flutter application that enables users to discover salons, earn loyalty points, manage referrals, redeem rewards, and receive real-time notifications — all in one place.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart SDK `^3.11.0`) |
| State Management | [GetX](https://pub.dev/packages/get) `^4.7.3` |
| Navigation | GetX Named Routes |
| Networking | `core_kit` (custom Dio-based HTTP client with token refresh) |
| Real-time | Socket.IO (`socket_io_client ^3.1.4`) |
| Push Notifications | Firebase Cloud Messaging + `flutter_local_notifications` |
| Deep Linking | `app_links ^6.4.0` |
| Location | `geolocator ^13.0.2` |
| Local Storage | `shared_preferences ^2.5.4` |
| Image Picking | `image_picker ^1.2.1` |
| Internationalization | GetX Translations (Arabic & English) |
| Fonts | Poppins (custom) |
| Design | Material 3, custom theme via `AppColor` |

---

## 🏛️ Project Architecture

The project follows a **feature-first, layered MVC architecture** powered by GetX. Each screen is self-contained with its own controller, and shared logic lives in the `core` layer.

```
┌─────────────────────────────────────────────────────────┐
│                        main.dart                        │
│     (App entry — Firebase, FCM, DeepLink, Location)     │
└────────────────────────┬────────────────────────────────┘
                         │
           ┌─────────────▼──────────────┐
           │       GetMaterialApp        │
           │  AppTranslations | AppRoute │
           │  AppInitialBindings (GetX)  │
           └─────────────┬──────────────┘
                         │
          ┌──────────────▼──────────────────┐
          │            CORE LAYER           │
          │  Routes · Bindings · Services   │
          │  Models · API Endpoints · i18n  │
          └──────────────┬──────────────────┘
                         │
          ┌──────────────▼──────────────────┐
          │           SCREEN LAYER          │
          │  Feature Screens (MVC pattern)  │
          │  screen / controller / widget   │
          └──────────────┬──────────────────┘
                         │
          ┌──────────────▼──────────────────┐
          │          SHARED LAYER           │
          │   widgets · utils · service     │
          └─────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Location | Responsibility |
|---|---|---|
| **Entry Point** | `lib/main.dart` | App bootstrap, Firebase init, FCM setup, deep link init |
| **Core** | `lib/core/` | Routes, bindings, API endpoints, models, translations, constants |
| **Screens** | `lib/screen/` | Feature UI screens — each has its own controller(s) |
| **Widgets** | `lib/widget/` | Reusable shared UI components (appbar, cards, shimmer, etc.) |
| **Utils** | `lib/utils/` | Colors, icons, images, strings, i18n helpers, SharedPrefs |
| **Service** | `lib/service/` | Socket.IO real-time service |

---

## 📁 Folder Structure

```
salem_app/
├── android/                        # Android platform files
├── ios/                            # iOS platform files
├── assets/
│   ├── fonts/                      # Poppins font
│   ├── icons/                      # SVG & PNG icons
│   └── images/                     # Static images
│
└── lib/
    ├── main.dart                   # App entry point
    ├── firebase_options.dart       # Firebase config (auto-generated)
    │
    ├── core/                       # App-wide core logic
    │   ├── api_endpoints/
    │   │   └── api_endpoints.dart  # Base URL, domain, all REST endpoints
    │   ├── app_bindings/
    │   │   └── app_bindings.dart   # GetX initial dependency injections
    │   ├── app_route/
    │   │   └── app_route.dart      # Named routes & GetPage definitions
    │   ├── app_translations/       # i18n — English & Arabic translations
    │   ├── constants/
    │   │   └── enums.dart          # App-wide enumerations
    │   ├── models/
    │   │   └── lat_long.dart       # Location data model
    │   └── services/
    │       ├── deep_link_service.dart      # Deep link handling (app_links)
    │       ├── location_controller.dart    # Geolocation GetX controller
    │       ├── location_service.dart       # Geolocator wrapper
    │       └── notificaiton_service.dart   # FCM + local notifications
    │
    ├── screen/                     # Feature screens (MVC per feature)
    │   ├── splash_screen/          # App splash / loading
    │   ├── onboarding_screen/      # First-launch onboarding flow
    │   │
    │   ├── auth_screen/            # Authentication
    │   │   ├── login_screen/       # Phone number login
    │   │   │   ├── login_screen.dart
    │   │   │   └── controller/
    │   │   │       └── login_screen_controller.dart
    │   │   ├── otp_screen/         # OTP verification
    │   │   │   └── controller/
    │   │   │       └── otp_screen_controller.dart
    │   │   └── signup_screen/      # New user registration
    │   │
    │   ├── bottom_nav/             # Bottom navigation bar host
    │   ├── home_screen/            # Home / dashboard
    │   ├── salon_screen/           # Salon listing & search
    │   │   └── controller/
    │   │       └── salon_screen_controller.dart
    │   ├── salon_details/          # Individual salon detail view
    │   │
    │   ├── rewards_screen/         # Loyalty rewards overview
    │   ├── rewards_details/        # Reward item detail
    │   ├── redem_now/              # Redeem reward flow
    │   ├── all_offer_screen/       # All available offers
    │   ├── rating_screen/          # Rate a salon / service
    │   │
    │   ├── profile_screen/         # User profile view
    │   ├── edit_profile/           # Edit profile info
    │   ├── myvisit_screen/         # User's visit history
    │   ├── view_history/           # Detailed visit history
    │   │
    │   ├── invite_friends/         # Invite via referral link
    │   ├── invite_history/         # Referral history log
    │   ├── referral_reward/        # Referral reward details
    │   │
    │   ├── how_it_work_invite/     # How referral works (explainer)
    │   ├── how_it_work_points/     # How points work (explainer)
    │   └── notificaton_screen/     # In-app notifications list
    │
    ├── service/                    # Real-time services
    │   ├── socket_service.dart     # Socket.IO client & event handlers
    │   └── steam_data_model.dart   # Stream data model
    │
    ├── utils/                      # Shared utilities & constants
    │   ├── app_colors/             # AppColor palette
    │   ├── app_icons/              # Icon name constants
    │   ├── app_images/             # Image path constants
    │   ├── app_string/             # String constants
    │   ├── i18n/                   # Locale helpers
    │   └── shared_prefe.dart       # SharedPreferences helper & keys
    │
    └── widget/                     # Reusable UI components
        ├── app_custom_appbar/      # Custom app bar widget
        ├── app_custom_cards/       # Reusable card widgets
        ├── app_device_utils/       # Device utility helpers (orientation lock, etc.)
        ├── app_observer/           # Navigation observer (NavigationObserver)
        ├── loading_widget/         # Loading indicators
        ├── notificaiton_widget/    # In-app notification UI widget
        └── shimmer/                # Shimmer loading skeleton widgets
```

---

## ✨ Key Features

- 🔐 **Phone + OTP Authentication** — Secure login via OTP verification
- 🗺️ **Salon Discovery** — Browse and search nearby salons using geolocation
- ⭐ **Loyalty Points System** — Earn and track points per visit
- 🎁 **Rewards & Redemption** — Redeem points for offers and rewards
- 👥 **Referral Program** — Invite friends and earn referral rewards
- 🔔 **Push Notifications** — FCM-powered push + local notifications
- 🔗 **Deep Linking** — Cold-start deep link handling via `app_links`
- 🌐 **Multi-language** — Full Arabic & English (RTL/LTR) support via GetX translations
- 💬 **Real-time Updates** — Socket.IO for live data streaming
- 📸 **Media Uploads** — Image picker for profile photos and uploads

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.11.0`
- Dart SDK compatible with Flutter version
- Android Studio / Xcode for platform builds
- Firebase project configured for Android & iOS

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd salem_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Environment

The app uses `ApiEndpoints` in `lib/core/api_endpoints/api_endpoints.dart` to configure the base URL and domain. Update these values for different environments (dev/staging/production).

---

> Built with ❤️ using Flutter & GetX
