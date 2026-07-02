# Setting up the Starsign Xcode project (beginner guide)

## 1. Create the project
1. Open **Xcode** → **File → New → Project…**
2. Choose **iOS → App**, click Next.
3. Product Name: `Starsign` · Interface: **SwiftUI** · Language: **Swift** · uncheck the test options for now.
4. Save it anywhere you like (e.g. inside this folder).

## 2. Add the starter code
1. In Finder, open this folder's `StarsignApp/` directory.
2. Xcode created a file called `ContentView.swift` and `StarsignApp.swift` — **delete both** (right-click → Delete → Move to Trash).
3. Drag all the `.swift` files from `StarsignApp/` (including subfolders) into the Xcode file list (left sidebar), dropping them on the yellow `Starsign` folder. When asked, tick **"Copy items if needed"**.

## 3. Run it
1. At the top of Xcode pick a simulator (e.g. iPhone 16).
2. Press **⌘R**. The app builds and launches in the simulator.
3. Enter a birth date, time, and city → tap **Calculate Chart**.

## 4. If something goes wrong
- Red errors in the sidebar: click one to see the message. Most common cause is a file not added to the app target — select the file, and in the right panel check **Target Membership → Starsign**.
- The city lookup needs the simulator to have network access.

## What each file does
| File | Purpose |
|---|---|
| `StarsignApp.swift` | App entry point |
| `Models.swift` | Zodiac signs, planets, chart data types |
| `Ephemeris.swift` | The astronomy math (planet positions) |
| `ChartBuilder.swift` | Turns birth data into a full natal chart |
| `Views/BirthDataFormView.swift` | Birth date/time/place input screen |
| `Views/ChartScreen.swift` | Results: placements list |
| `Views/ChartWheelView.swift` | The circular chart wheel drawing |
