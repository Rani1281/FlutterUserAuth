# What is this app?
This is a sample Flutter app for that has basic user authentication functionality:
- Creating account or signing in
- signing out
- with email & password
- with Google
- email verification
- forgot password (uncomplete as of now)

# Why is this app usefull?
This app is usefull to start developming fast - it bypasses what already almost always needs to be done.

# Get started
- Clone this repository and switch the remote repository to not push changes into this one.
- Run `flutter pub get`
- Change you should change the name of the app in any place that refers to the current name "articly" (mostly the folder name, but also in some deep files). I think there's a Flutter command like "flutter rename" (you should check that).
- Change the `README.md`.
- Delete or change configuration files (like firebase_options.dart and google_services.json, firebase.json, .kilo).
- For google sign in, change the appropriate values inside `ios/Runner/Info.plist` (CLIENT ID and REVERSE CLIENT ID)
- Prioritize connecting Firebase with `flutterfire configure` so that the configuration process is done automatically.
- Still have to connect the SHA1 fingerprint to Firebase. Just run: `keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android 2>&1`.
- Delete unimportant files for you (e.g, TODO.md).

# Some explanation about the app
- Supported platforms: Android, IOS and web.
- Architecture: the app follows the Flutter recommended MVVM pattern.
- .cursor/rules: project rules for Cursor IDE (delete this if you're not using Cursor).
-  rules.md: all Flutter rules recommended by Flutter that any AI agent should know about (not required if you're using only Cursor, but can be usefull for other AI agents that support rules in only a single file). Also, feel free to change the name depending on the AI agent you're using (e.g, AGENTS.md, CLAUDE.md, GEMINI.md, etc.).

# Recommendations
- Connect the dart and Flutter skills. See this Flutter article: https://docs.flutter.dev/ai/agent-skills
- Define custom themes for you app under `\theme` and create a file for each widget, and define app colors in `\theme\app_colors.dart`
