# Expense Tracker (TakeUForward Assignment)

A Flutter-based personal finance tracker with a modern fintech-style UI, local persistence, and modular architecture for future backend migration.

## Table of Contents

- [Architecture Decisions and Assumptions](#architecture-decisions-and-assumptions)
	- [Why This Architecture](#why-this-architecture)
	- [Repository Pattern + Hive](#repository-pattern--hive)
	- [Scalability and Backend Migration Readiness](#scalability-and-backend-migration-readiness)
	- [Key Assumptions](#key-assumptions)
- [Setup Instructions](#setup-instructions)
- [Feature List](#feature-list)
- [App Screenshots](#app-screenshots)
- [UI/UX Inspiration](#uiux-inspiration)
- [AI Disclosure](#ai-disclosure)

## Architecture Decisions and Assumptions

### Why This Architecture

I used a modular, feature-first structure with clear responsibilities:

- `screens/` for UI views
- `controller` for presentation/business logic and state coordination
- `repository` for data access abstraction
- `services/` for low-level integrations (Hive, theme settings)

This follows an MVC-like flow adapted for Flutter + Riverpod:

- View: screen/widget layer
- Controller: Riverpod notifiers/providers as app logic
- Model: domain models (`TransactionModel`, `AppUser`, etc.)
- Repository: data boundary between controller and persistence

### Repository Pattern + Hive

Current persistence is local using Hive for fast offline storage and simple setup.

- `HiveService` handles actual read/write operations
- Repositories wrap `HiveService` and expose app-friendly methods
- Controllers call repositories, not Hive directly

This keeps the app logic independent from the storage implementation.

### Scalability and Backend Migration Readiness

Because UI and controllers do not depend directly on Hive APIs, backend migration is straightforward:

1. Replace or extend repository implementations to call REST/GraphQL/Firebase.
2. Keep screen and controller contracts mostly unchanged.
3. Optionally add sync/caching strategy while preserving local-first UX.

In short, the current architecture is clean, testable, and scalable for future growth.

### Key Assumptions

- This is an assignment scope app, so authentication is simplified for local flow.
- Local-first behavior is preferred for speed and demo reliability.
- Feature boundaries are intentionally kept separate to avoid tightly coupled code.

## Setup Instructions

### Prerequisites
- Flutter SDK (recommended stable channel)
- Dart SDK (comes with Flutter)
- Android Studio or VS Code with Flutter extension
- Android emulator / iOS simulator / physical device

### 1) Clone and open project
```bash
git clone https://github.com/Teja-Varshith/Expense_Tracker_TUFAssignment.git
cd expense_tracker_tuf
```

### 2) Install dependencies
```bash
flutter pub get
```

### 3) Run the app
```bash
flutter run
```

### 4) Build release (optional)
```bash
flutter build apk
```

## Feature List

- Authentication flow
  - Sign in
  - Sign up
  - User session via local storage
- Home dashboard
  - Monthly income, expense, and balance summary
  - Recent transactions list
  - Swipe-to-delete with confirmation dialog
- Add transaction flow
  - Income/Expense type toggle
  - Category selection
  - Custom category support
  - Date and note support
- Balance analytics
  - Monthly trend chart
  - Category breakdown pie chart
  - Insight cards (net status, top expense)
- Profile module
  - View profile details and stats
  - Update details
  - Sign out
- Theming
  - Light/dark theme toggle available in top app bars
- Notification UX
  - Awesome snackbar feedback (`awesome_snackbar_content`) for key success/error/warning events

## App Screenshots

Screenshots from the project root:

| Screen | Preview |
|---|---|
| Screen 1 | ![Screen 1](flutter_01.png) |
| Screen 2 | ![Screen 2](flutter_02.png) |
| Screen 3 | ![Screen 3](flutter_03.png) |
| Screen 4 | ![Screen 4](flutter_04.png) |
| Screen 5 | ![Screen 5](flutter_05.png) |
| Screen 6 | ![Screen 6](flutter_06.png) |
| Screen 7 | ![Screen 7](flutter_07.png) |

## UI/UX Inspiration

Since this is a fintech app assignment, I took inspiration from the CRED app's visual language and interaction style, and designed the UI/UX in a similar modern fintech direction.

## AI Disclosure

AI assistance was used in parts of this project, including:

- color/theming exploration and refinements
- reducing repetitive/boilerplate tasks
- helping reason through architecture and feature breakdown

All final code and decisions were reviewed and integrated intentionally for this project.
