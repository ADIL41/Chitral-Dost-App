# Chitral Dost 🏔️

A Flutter-based local home services and community app designed for the people of Chitral, connecting residents with trusted service providers across 20+ categories — right in their neighborhood.

---

## 📱 About the App

**Chitral Dost** ("Friend of Chitral") is a mobile application that bridges the gap between residents and local service providers in Chitral. Whether you need a plumber, electrician, tutor, or any other home service, Chitral Dost helps you find the right person nearby — quickly and easily.

Built as a Final Year Project (FYP) for BS Software Engineering at Islamia College University Peshawar.

---

## ✨ Features

- **20+ Service Categories** — Plumbers, electricians, tutors, carpenters, painters, and more
- **Location-Based Sorting** — Automatically sorts service providers by proximity to the user's current location
- **Service Provider Profiles** — View provider details, services offered, and contact information
- **User Authentication** — Secure sign-up and login via Firebase Authentication
- **Real-Time Data** — Service listings powered by Firebase Firestore with live updates
- **Clean & Intuitive UI** — Simple, easy-to-navigate interface designed for all age groups

---

## 📸 Screenshots

> _Screenshots coming soon_

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Backend / Database | Firebase Firestore |
| Authentication | Firebase Auth |
| Storage | Firebase Storage |
| Location Services | Geolocator / Google Maps |
| State Management | Provider / Riverpod |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Firebase project configured
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/chitral-dost.git
   cd chitral-dost
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a project on [Firebase Console](https://console.firebase.google.com/)
   - Download `google-services.json` and place it in `android/app/`
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/` *(for iOS)*
   - Enable Firestore, Authentication, and Storage in your Firebase project

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```
lib/
├── main.dart
├── models/          # Data models
├── screens/         # UI screens
├── widgets/         # Reusable widgets
├── services/        # Firebase & API services
├── providers/       # State management
└── utils/           # Constants, helpers
```



---

## 🎓 Project Info

| Detail | Info |
|---|---|
| Project Type | Final Year Project (FYP) |
| University | Islamia College University Peshawar |
| Degree | BS Software Engineering |
| Year | 2026 |

---

## 👤 Author

**Adil**
Flutter / Mobile App Developer


---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

> _Chitral Dost — Bringing Chitral's community closer, one service at a time._
