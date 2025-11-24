
# FamilyBoard (tvOS)

FamilyBoard is a TV‑friendly digital notice board for families on **Apple TV (tvOS)**.  
Each family member chooses their profile, adds quick sticky notes, and sees all notes together on a big shared board.

The UI is built with **SwiftUI** and designed for tvOS focus navigation (Apple TV remote): large targets, clear focus outlines, and high-contrast pastel colors.

---

## Features

### Screen 1 – User Selection

- **Prompt**: “Who’s using FamilyBoard?”
- **Profiles**:
  - **Dad**
  - **Mom**
  - **Kid**
- **Design**:
  - Solid **white** background for a clean look.
  - Each user card has a unique accent color and a bold border.
  - Focus state:
    - Yellow/colored outline and subtle scale effect when focused with the Apple TV remote.

### Screen 2 – Quick Note & Custom Note

- **Quick notes (preset buttons)**:
  - Left column: `BUY MILK`, `GOOD LUCK!`, `I'M HOME`
  - Right column: `CALL ME`, `FEED THE DOG`, `RUNNING LATE`
  - Each quick note is a **pastel sticky-style button**:
    - Pastel purple, orange, and red variations.
    - Thick black border and drop shadow for a “sticker” feel.

- **Custom note input**:
  - “Or write your own note:” section.
  - Text field:
    - Background color **`#D0C3F1`** (pastel purple).
    - Rounded corners.
    - Automatically focused when screen appears to bring up the tvOS keyboard.
  - **ADD** button:
    - Background color **`#FEF1AB`** (pastel yellow).
    - Bold text, black border, and clear shadow.
    - Adds the trimmed text as a new note on the board.

- **On-screen keyboard** (custom SwiftUI keyboard):
  - Rows of A–Z letters.
  - **Space** and **Delete** keys:
    - Background color **`#AFD9AE`** (pastel green).
  - All letter keys:
    - Background color **`#FFCC99`** (pastel orange).
  - Each key:
    - Black text, black border, and a subtle shadow.
    - Sized for comfortable tvOS remote selection.

- **CANCEL button**:
  - Background color **`#FEF1AB`** (same pastel yellow as ADD).
  - Black text with a black border and top padding.
  - Returns to the previous state (closes the Quick Note overlay).

### Screen 3 – Board (Sticky Notes)

- **Board layout**:
  - Large grid of sticky notes built with `LazyVGrid`.
  - Fixed-size note tiles arranged in **5 columns** with spacing.

- **Sticky notes**:
  - Coloring based on the note’s `userName`:
    - **Dad**: `#E9F9E5` (light green).
    - **Mom**: `#FFD7EE` (light pink).
    - **Kid**: `#CEEEF8` (light blue).
    - Default / other: yellow-ish.
  - Design:
    - Rounded rectangle with drop shadow (paper note look).
    - A `pin.fill` SF Symbol at the top-right.
    - Note text centered under the pin.
  - Each note includes a **red delete button**:
    - Red background, white border, and a trash icon.
    - Activating it removes that note from the board.

- **Board controls**:
  - Top bar:
    - Back button on the left.
    - “FamilyBoard” title in the center.
    - Circular profile placeholder on the right.
  - Bottom-right **Plus** button:
    - Blue circular button with a black-bordered outline and drop shadow.
    - Tapping returns to Screen 2 to add a new note.

---

## App Flow

1. **Start at Screen 1**  
   User chooses **Dad**, **Mom**, or **Kid** via the Apple TV remote.

2. **Go to Screen 2 (Quick Note)**  
   - User picks:
     - One of the preset quick-note buttons, **or**
     - Types a custom note with the colored text field and on-screen keyboard.
   - Presses **ADD** to confirm, or **CANCEL** to go back without adding.

3. **Go to Screen 3 (Board)**  
   - The new note is added to `boardNotes` and appears as a sticky note.
   - User can:
     - Add more notes via the Plus button (returns to Screen 2).
     - Delete notes using each note’s trash button.
     - Use the back button to return to Screen 2.

All state is held in memory while the app runs; notes are not persisted across app restarts yet.

---

## Technical Overview

### Tech Stack

- **Platform**: tvOS
- **UI Framework**: SwiftUI
- **Language**: Swift

### Main Types

- **Model**

```swift
struct BoardNote {
    let text: String
    let userName: String
}
