# StudyFlow

StudyFlow is a clean, beginner-friendly Flutter study companion for B.Tech CSE students. It gives a student a daily checklist, a weekly day selector, a 25-minute focus timer, and a compact class schedule.

## What is included

- Interactive task checklist that updates the daily progress indicator
- Responsive dashboard that works in a desktop browser and mobile-sized screens
- 25-minute focus timer with start and pause controls
- Sample tasks for DSA, DBMS, Operating Systems, and Computer Networks
- A widget test for the checklist behaviour

## Project location

```text
C:\Users\User\Documents\Codex\2026-10-02\referenced-chatgpt-conversation-this-is-an\outputs\studyflow
```

## Open the project in VS Code

1. Close and reopen VS Code once after installing Flutter so it sees the Flutter command on your PATH.
2. Open PowerShell.
3. Run these commands:

```powershell
cd "C:\Users\User\Documents\Codex\2026-10-02\referenced-chatgpt-conversation-this-is-an\outputs\studyflow"
code .
```

## Run the app in Chrome

Run these commands in a PowerShell window inside the project folder:

```powershell
flutter pub get
flutter run -d chrome
```

Flutter opens StudyFlow in Chrome. While it is running, save `lib\main.dart` or press `r` in the same terminal to hot reload. Press `q` to stop the app.

## Verify code quality

Run these commands in PowerShell inside the project folder:

```powershell
flutter analyze
flutter test
```

## Build the web version

Run this command in PowerShell inside the project folder:

```powershell
flutter build web --release
```

The shareable production website is created in `build\web`. To publish it online later, upload the contents of that folder to a static-hosting service such as GitHub Pages, Netlify, or Firebase Hosting.

## Run on an Android emulator

Android Studio is not installed on this computer yet, so Flutter is currently configured for Chrome and Edge web development. To add Android support:

1. Install Android Studio from <https://developer.android.com/studio>.
2. During first launch, install the Android SDK, Android SDK Platform-Tools, and Android Emulator.
3. In Android Studio, open **More Actions** > **Virtual Device Manager**, create a Pixel device, and start it.
4. Open a new PowerShell window and run:

```powershell
flutter doctor --android-licenses
flutter doctor
flutter emulators
flutter run
```

Accept each Android licence by typing `y`. With an emulator running, `flutter run` will install and launch StudyFlow on it.

## Push the project to GitHub

First, sign in to <https://github.com> and create an empty repository named `studyflow`. Do not add a README, `.gitignore`, or licence on GitHub because this project already has those files.

Then run the following in PowerShell inside the project folder. Replace the two placeholder values with your own information:

```powershell
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR_EMAIL@example.com"
git init
git branch -M main
git add .
git commit -m "Initial StudyFlow Flutter app"
git remote add origin https://github.com/YOUR-GITHUB-USERNAME/studyflow.git
git push -u origin main
```

After the first push, use these three commands whenever you make changes:

```powershell
git add .
git commit -m "Describe your change"
git push
```

## Main files to edit

- `lib\main.dart` - the full StudyFlow interface and sample tasks
- `test\widget_test.dart` - automated behaviour test
- `pubspec.yaml` - app metadata and packages
