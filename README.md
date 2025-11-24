# Family_Board-App
# FamilyBoard (tvOS)

FamilyBoard is a simple, TV‑friendly digital notice board for families on **Apple TV (tvOS)**.  
It lets each family member select their profile, add quick sticky notes, and view all notes together on a big “board” screen using the Apple TV remote.

The UI is built for tvOS with large, clear elements and focus states for directional/remote navigation.

---

## Features

- **Profile selection screen (tvOS-optimized)**
  - “Who’s using FamilyBoard?” prompt.
  - Three user cards: **Dad**, **Mom**, **Kid**.
  - Each user card has its own accent color and a focus highlight when selected with the remote.

- **Quick note selection (Screen 2)**
  - Preset “quick note” buttons on two columns, such as:
    - BUY MILK, GOOD LUCK!, I’M HOME  
    - CALL ME, FEED THE DOG, RUNNING LATE
  - Simple **custom note input**:
    - Text field for typing a message.
    - Custom **on‑screen keyboard** built in SwiftUI (A–Z, SPACE, DELETE).
    - “ADD” button to send the custom note to the board.
  - “Back” and “Cancel” actions to leave this overlay and return with the remote.

- **Board screen (Screen 3)**
  - Displays all notes as **sticky notes** arranged in a `LazyVGrid` (5 columns per row).
  - Notes are color‑coded by user:
    - Dad: light green  
    - Mom: light pink  
    - Kid: light blue  
    - Fallback: yellow
  - Large **plus button** at the bottom‑right to add a new note (returns to Quick Note screen).
  - Each sticky note shows:
    - A “pin” SF Symbol icon at the top.
    - The note text.
    - A red trash button to delete the note.
  - Sticky notes are focusable: focused note gets a yellow outline, making it easy to see what the remote is pointing at.

- **Session state**
  - Notes are stored in memory in an array of `BoardNote` (text + userName).
  - You can add and delete notes while the app is running on Apple TV.

---

## Screens & Flow (tvOS)

1. **Screen 1 – User Selection**
   - The user uses the **Apple TV remote** to move focus between **Dad**, **Mom**, and **Kid**.
   - Selecting a user opens the **QuickNoteScreen** overlay.

2. **Screen 2 – Quick Notes / Custom Note**
   - User can:
     - Pick one of the preset quick notes with the remote.
     - Type a custom note using the text field and on‑screen keyboard.
   - After choosing/adding a note:
     - A new sticky note is created for the selected user.
     - The app navigates to the **BoardScreen**, showing the updated board.
   - “CANCEL” or the back button closes the quick note overlay and returns to the previous state.

3. **Screen 3 – Board**
   - All notes created in the session are displayed in a grid of sticky notes.
   - The **plus button** at the bottom‑right opens the QuickNote overlay again to add more notes.
   - Each note has a **trash icon**; activating it removes that note from the board.

---

## Technical Overview

- **Platform**: **tvOS** application using **SwiftUI**.
- **Main file**: [FamilyBoard/ContentView.swift](cci:7://file:///Users/student/Desktop/IRUNI/FamilyBoard/FamilyBoard/ContentView.swift:0:0-0:0)
- **Language**: Swift

### Architecture & Main Views

- **Root view**: `ContentView`
  - Manages global UI state and navigation:
    - `@State private var selectedUser: String?`
    - `@State private var isShowingQuickNote: Bool`
    - `@State private var isShowingBoard: Bool`
    - `@State private var boardNotes: [BoardNote]`
  - Decides whether to show:
    - User selection screen
    - BoardScreen
    - QuickNoteScreen overlay

- **Supporting views**:
  - `UserCard` – cards for Dad/Mom/Kid with focus highlights.
  - `QuickNoteScreen` – overlay for selecting preset notes or adding a custom note.
    - `QuickNoteButton` – styled buttons for each quick note.
    - `OnScreenKeyboardView` and `KeyboardKey` – custom keyboard for tvOS.
    - `QuickNoteBackButtonView` – back button with focus outline.
  - `BoardScreen` – the main sticky note board.
    - `StickyNoteView` – each individual sticky note with pin icon and trash button.
    - `BackButtonView` – back button on the board screen.
    - `PlusButtonView` – large circular button to add a new note.
    - `FocusableNoteContainer` – reusable wrapper to add focus outline behavior.

### Data Model

```swift
struct BoardNote {
    let text: String
    let userName: String
}
