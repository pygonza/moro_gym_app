# Moro Gym

Moro Gym is a native mobile application developed in Flutter, designed for the comprehensive management of strength training and bodybuilding. This project serves as a practical implementation for a thesis, integrating a robust backend with Supabase and an intelligent assistant powered by Google Gemini.

## Core Features

- **Routine Management**: Creation and customization of training plans tailored to specific muscle groups.
- **Workout Tracking**: Real-time logging of sets, repetitions, and weight (kg), including session notes.
- **Exercise Catalog**: Comprehensive database with instructions and equipment details for various strength exercises.
- **Gamification**: Automatic tracking of workout streaks and achievement of milestones (Badges).
- **AI Coach**: Integrated floating assistant for technical guidance and motivational support.
- **Performance**: High-contrast, responsive UI optimized for the gym environment.

## Technology Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Backend & Database**: Supabase (PostgreSQL)
- **AI Engine**: Google Gemini (generative-ai)
- **Navigation**: Go Router
- **Analytics**: Fl Chart

## Setup and Installation

### Prerequisites
- Flutter SDK (>=3.2.0)
- Supabase Project
- Google AI Studio API Key (for the AI Assistant)

### Configuration
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Configure your Supabase credentials in `lib/main.dart`.
4. Obtain a free Gemini API Key from [Google AI Studio](https://aistudio.google.com/) and insert it in `lib/main.dart`.
5. Execute `flutter run` on your connected device.

## Deployment

To generate a release APK, execute:
```bash
flutter build apk --split-per-abi
```

## Authorship

**Developer**: Alejandro Gonzalo
**Contact**: andro.gonzs2003@gmail.com

---
*Developed as part of a formal academic thesis for Moro Gym.*
