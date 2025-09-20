## Restaurant Mobile (restaurant_app)

Professional, production-ready Flutter mobile application for browsing a restaurant menu, placing orders, managing favorites, and booking tables. The app supports English and Arabic (RTL) locales and integrates with a REST API back-end.

---

Table of contents
- Overview
- Features
- Screenshots
- Requirements
- Quick start
- Configuration
- Project structure
- Key packages
- Troubleshooting
- Contributing
- License

## Overview

This repository contains a Flutter application named `restaurant_app`. It provides a customer-facing mobile app that lets users:

- Browse menu items (with special offers and recommendations)
- Add/remove favorites
- Add items to a cart and place orders
- Book tables and manage reservations
- Manage user profile and authentication
- Switch between English and Arabic (RTL) languages

The app is wired to a REST API defined in `lib/config/app_config.dart` and uses `dio` for HTTP communication.

## Features

- Multi-language support (English + Arabic with RTL layout)
- User authentication (login/register) and profile updates
- Menu browsing with carousel and categorization
- Discounted and recommended dishes endpoints
- Favorites persisted via remote API and local storage
- Table booking / reservation flow
- Cart and order creation
- Clean architecture with `services/`, `models/`, `providers/`, and `widgets/`

## Screenshots

Place screenshots in `images/` or `assets/images/` and reference them here. Example assets already in the repo: `images/image1.jpeg`, `images/image2.jpeg`, `assets/images/profileImage.png`.

## Requirements

- Flutter SDK (tested with Flutter stable and Dart SDK compatible with environment in `pubspec.yaml` - SDK constraint ^3.5.3)
- A connected device or emulator (Android / iOS / web / desktop as supported by your Flutter toolchain)

## Quick start

1. Install Flutter and set up your environment: https://docs.flutter.dev/get-started/install
2. From the project root, fetch dependencies:

```powershell
flutter pub get
```

3. Run the app on an Android device/emulator:

```powershell
flutter run -d android
```

Or run on iOS / web / windows depending on your setup:

```powershell
flutter run -d ios
flutter run -d chrome
flutter run -d windows
```

## Configuration

API base URLs and timeouts are configurable in `lib/config/app_config.dart`:

- `baseUrl` — the server origin (default: `https://restaurantapi-kyfg.onrender.com`)
- `apiUrl` — base API path (`$baseUrl/api`)

If you need to point the app at a local backend or a different environment, update `baseUrl` and rebuild.

Authentication tokens are stored using `shared_preferences` (key: `auth_token`). HTTP requests include the token automatically through `lib/core/api_client.dart`'s request interceptor.

## Project structure (high level)

- `lib/`
	- `main.dart` — app entrypoint and provider wiring
	- `Homepage.dart`, `food_page.dart`, `table_page.dart`, `profile_page.dart`, etc. — UI screens
	- `services/` — HTTP services (API, auth, favorites, language)
	- `core/` — `ApiClient` wrapper for `dio`
	- `config/` — `AppConfig` with API endpoints and timeouts
	- `models/` — domain models (UserModel, TableModel, etc.)
	- `widgets/` and reusable UI components

## Key packages (from `pubspec.yaml`)

- `dio` — HTTP client used across services
- `provider` — state management for authentication and providers
- `shared_preferences` — local persistent storage for tokens and settings
- `carousel_slider`, `smooth_page_indicator` — carousel UI on the homepage
- `image_picker` — profile avatar selection
- `intl` — internationalization utilities

## Logging & Debugging

- `lib/services/api_service.dart` includes console `print()` statements for request URLs and responses to help debugging. You can enhance logging by replacing prints with a proper logging package if desired.

## Tests & Lints

Run analyzer and tests (if added) with:

```powershell
flutter analyze
flutter test
```

The project includes `flutter_lints` in `dev_dependencies` and an `analysis_options.yaml` at the repo root.

## Troubleshooting

- 500 errors mentioning missing `image_path` may indicate a backend schema mismatch — `ApiService.getTables()` contains a conservative fallback and prints diagnostic details to help identify server-side issues.
- Network timeouts: adjust `connectTimeout` and `receiveTimeout` values in `lib/config/app_config.dart` when testing against slow or local servers.

## Contributing

1. Fork the repository
2. Create a branch: `git checkout -b feat/your-feature`
3. Make changes and add tests where appropriate
4. Commit: `git commit -m "feat: short description"`
5. Push: `git push origin feat/your-feature`
6. Open a Pull Request and describe the change

Please keep changes small and focused. If you plan to add or change API contracts, update `lib/config/app_config.dart` and add clear migration notes.

## Commit & push updated README (example)

```powershell
git add README.md
git commit -m "docs: add professional README"
git push origin master
```

## License

Add a LICENSE file to this repository to declare usage terms. If you don't have a preferred license, consider the MIT License for open-source projects.

---

If you'd like, I can:

- Add screenshots into the README and wire them to the existing assets
- Create a short CONTRIBUTING.md and CODE_OF_CONDUCT.md
- Add CI steps for Flutter analyze/test on GitHub Actions

Tell me which follow-up you'd like next and I'll proceed.


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
