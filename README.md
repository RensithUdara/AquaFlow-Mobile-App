# AquaFlow - Water Reminder App

A smart hydration tracking app built with Flutter that helps users maintain healthy hydration habits with intelligent reminders and customizable goals.

![AquaFlow App](https://i.imgur.com/placeholder.jpg)

## Features

- **Daily Water Tracking**: Easily track daily water intake with a visual progress indicator
- **Smart Reminders**: Get intelligent notifications based on your drinking habits
- **Customizable Goals**: Set personalized daily water intake goals
- **Detailed History**: View your hydration history with statistics by day, week, month, and year
- **Quick Add Options**: Quickly add common water amounts with one tap
- **Dark & Light Theme**: Choose your preferred app theme

## Architecture

AquaFlow is built using the Model-View-Controller (MVC) architecture pattern:

- **Models**: Define data structures for water entries, goals, and settings
- **Views**: UI components like screens and widgets
- **Controllers**: Handle business logic and state management with Provider

## Tech Stack

- **Flutter**: Framework for building cross-platform apps
- **Provider**: State management solution
- **SharedPreferences & SQLite**: Local data persistence
- **Flutter Local Notifications**: Smart reminder notifications
- **Material Design 3**: Modern UI with custom theme

## Getting Started

### Prerequisites

- Flutter SDK (^3.5.3)
- Dart SDK (^3.1.0)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/aqualflow_mobile_app.git
   ```

2. Navigate to the project directory:
   ```
   cd aqualflow_mobile_app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

```
lib/
├── controllers/       # Business logic and state management
├── models/            # Data structures
├── services/          # External services (storage, notifications)
├── utils/             # Utility classes, constants, and themes
├── views/
│   ├── screens/       # Full screens
│   └── widgets/       # Reusable UI components
└── main.dart          # App entry point
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Hydration icons created by [Freepik](https://www.freepik.com)
- Wave animation inspired by [Flutter Wave Animation](https://github.com/placeholder)
