# 🩺 Dun Diary — Smart Blood Pressure Tracker

**Dun Diary** is a Flutter application for recording and tracking blood pressure with ease. It features an AI-powered system that reads values from photos of blood pressure monitors and analyzes health trends automatically.

---

## ✨ Key Features

### 📷 AI-Powered Blood Pressure Recording
- **Take a photo** or **pick an image** of your blood pressure monitor — AI reads Systolic, Diastolic, and Pulse values automatically
- Uses a **YOLOv8** model (TFLite) for digit detection from monitor screens
- Manual input is also supported

### 📊 Statistics & Graphs
- Displays average, max, min values with fluctuation range
- Blood pressure trend graphs filterable by day / week / month / year
- Classifies blood pressure into 6 levels: *Low → Normal → Elevated → High Stage 1 → High Stage 2 → Crisis*

### 🤖 AI Health Analysis
- AI-generated health summaries and personalized recommendations
- Weekly blood pressure trend analysis
- Analysis results are cached locally to reduce redundant API calls

### 📅 Record History
- Calendar view showing days with recorded data
- Easy browsing of past records

### 🔄 Offline-First & Cloud Sync
- Works fully **offline** — data is stored locally using Hive
- Syncs with **Cloud Firestore** when internet is available
- Built-in queue system for managing pending sync operations

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| **Flutter** 3.38.7 (via FVM) | Core framework |
| **Dart** SDK ^3.9.2 | Programming language |
| **Provider** | State management |
| **Hive** | Local storage (NoSQL) |
| **Firebase Auth** | Anonymous authentication |
| **Cloud Firestore** | Cloud database & sync |
| **Ultralytics YOLO** (TFLite) | Digit detection from images |
| **Lottie** | Animations |
| **Google Fonts** (NotoSansThai) | Thai typography |

---

## 🏗️ Architecture

The project follows a **Feature-based Architecture** with clear separation of concerns:

```
lib/
├── core/                  # Infrastructure
│   ├── auth/              # Firebase Anonymous Auth
│   ├── constant/          # Routes, Hive box names
│   ├── network/           # Network client, API state, connectivity check
│   ├── router/            # App navigation router
│   ├── services/          # Navigation & SnackBar services
│   └── mixins/            # Reusable mixins
│
├── data/                  # Data Layer
│   ├── blood_pressure/    # BP records (model, datasource, repository)
│   └── analyze_record/    # AI analysis results & cache
│
├── feature/               # Feature Modules
│   ├── home/              # Home — today's health overview
│   ├── record/            # Record BP (photo / manual input)
│   ├── history/           # Record history + calendar
│   ├── stat/              # Statistics + graphs + AI analysis
│   ├── main/              # Bottom navigation shell
│   └── splash_screen/     # Splash screen
│
├── shared/                # Shared Resources
│   ├── constant/          # App strings, colors, themes
│   ├── style/             # Text & component styles
│   ├── utils/             # Utility functions & helpers
│   └── widgets/           # Reusable UI components
│
├── main.dart              # Entry point
├── register_provider.dart # Provider registration
└── firebase_options.dart  # Firebase config (auto-generated)
```

Each **Feature Module** is organized into:
- `presentation/` — Screens & Widgets
- `provider/` — State management (ViewModel pattern via Provider)
- `model/` — Feature-specific data models (if applicable)

The **Data Layer** follows:
- `model/` — Data models & Hive adapters
- `datasource/` — Local (Hive) & Remote (Firestore) data sources
- `repository/` — Abstraction layer between datasources and features

---

## 🚀 Getting Started

### Prerequisites

- **Flutter** 3.38.7 (managed via [FVM](https://fvm.app/))
- **Firebase Project** with Authentication (Anonymous) and Cloud Firestore enabled
- **Android Studio** or **VS Code**

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/NutNaphop/Dun-Diary-Application.git
cd Dun-Diary-Application

# 2. Install FVM (if not already installed)
dart pub global activate fvm

# 3. Install the required Flutter version
fvm install

# 4. Install dependencies
fvm flutter pub get

# 5. Generate Hive adapters
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 6. Run the app
fvm flutter run
```

### Firebase Setup

1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/)
2. Enable **Authentication → Anonymous Sign-in**
3. Enable **Cloud Firestore**
4. Run `flutterfire configure` to generate `firebase_options.dart`

---

## 📱 Screens Overview

| Screen | Description |
|---|---|
| **🏠 Home** | Today's health status and quick-record button |
| **📝 Record** | Capture photo or manually enter SYS / DIA / PUL |
| **📋 History** | Calendar and past records list |
| **📊 Statistics** | Trend graphs, averages, and AI health analysis |

---

## 📄 License

This project is private and not published to pub.dev.