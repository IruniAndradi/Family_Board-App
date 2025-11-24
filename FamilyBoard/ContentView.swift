//
//  ContentView.swift
//  FamilyBoard
//
//  Created by STUDENT on 2025-11-22.
//

import SwiftUI

struct BoardNote {
    let text: String
    let userName: String
}

struct ContentView: View {
    @State private var selectedUser: String?
    @State private var isShowingQuickNote = false
    @State private var isShowingBoard = false
    @State private var boardNotes: [BoardNote] = []

    var body: some View {
        ZStack {
            Group {
                if isShowingBoard {
                    BoardScreen(
                        notes: boardNotes,
                        userName: selectedUser ?? "",
                        onAddNote: {
                            print("=== Plus button tapped on BoardScreen ===")
                            isShowingQuickNote = true
                        },
                        onDeleteNote: { index in
                            guard boardNotes.indices.contains(index) else { return }
                            boardNotes.remove(at: index)
                        },
                        onBack: {
                            print("=== Back button tapped on BoardScreen ===")
                            isShowingQuickNote = true
                        }
                    )
                } else {
                    Color.gray.opacity(0.15)
                        .ignoresSafeArea()
                    VStack(spacing: 80) {
                        Text("Who's using FamilyBoard?")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 80)
                        HStack(spacing: 80) {
                            UserCard(name: "Dad", accentColor: .mint, isSelected: selectedUser == "Dad") {
                                print("=== Dad tapped ===")
                                selectedUser = "Dad"
                                isShowingQuickNote = true
                            }
                            UserCard(name: "Mom", accentColor: .pink, isSelected: selectedUser == "Mom") {
                                selectedUser = "Mom"
                                isShowingQuickNote = true
                            }
                            UserCard(name: "Kid", accentColor: .blue, isSelected: selectedUser == "Kid") {
                                selectedUser = "Kid"
                                isShowingQuickNote = true
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 80)
                }
            }
            .disabled(isShowingQuickNote)
            .allowsHitTesting(!isShowingQuickNote)

            if isShowingQuickNote {
                QuickNoteScreen(
                    onCancel: {
                        isShowingQuickNote = false
                        isShowingBoard = false
                    },
                    onSelectNote: { note in
                        isShowingQuickNote = false
                        let user = selectedUser ?? ""
                        boardNotes.append(BoardNote(text: note, userName: user))
                        isShowingBoard = true
                    }
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
}

// Back button variant specifically for Screen 2 (QuickNote), using Button
struct QuickNoteBackButtonView: View {
    let action: () -> Void
    @State private var isFocused: Bool = false

    var body: some View {
        Button(action: {
            print("QuickNoteBackButtonView tapped")
            action()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)

                Text("Back")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(isFocused ? Color.yellow : Color.black,
                                    lineWidth: isFocused ? 6 : 4)
                    )
                    .shadow(color: .black.opacity(0.9), radius: 0, x: 8, y: 8)
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
        .focusable(true) { focused in
            isFocused = focused
        }
    }
}

struct OnScreenKeyboardView: View {
    @Binding var text: String

    private let rows: [[String]] = [
        ["A", "B", "C", "D", "E", "F", "G"],
        ["H", "I", "J", "K", "L", "M", "N"],
        ["O", "P", "Q", "R", "S", "T", "U"],
        ["V", "W", "X", "Y", "Z"]
    ]

    var body: some View {
        VStack(spacing: 18) {
            ForEach(rows, id: \.[0]) { row in
                HStack(spacing: 16) {
                    ForEach(row, id: \.self) { key in
                        KeyboardKey(title: key) {
                            text.append(key)
                        }
                    }
                }
            }

            HStack(spacing: 18) {
                KeyboardKey(title: "SPACE") {
                    text.append(" ")
                }

                KeyboardKey(title: "DELETE") {
                    guard !text.isEmpty else { return }
                    text.removeLast()
                }
            }
        }
        .padding(.top, 28)
    }
}

struct KeyboardKey: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .frame(width: title.count > 1 ? 90 : 50, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .shadow(color: .black.opacity(0.7), radius: 0, x: 6, y: 6)
                )
        }
        .buttonStyle(.plain)
    }
}

struct BackButtonView: View {
    let action: () -> Void
    @State private var isFocused: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.left")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)

            Text("Back")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(isFocused ? Color.yellow : Color.black,
                                lineWidth: isFocused ? 6 : 4)
                )
                .shadow(color: .black.opacity(0.9), radius: 0, x: 8, y: 8)
        )
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .focusable(true) { focused in
            isFocused = focused
        }
        .onTapGesture {
            print("BackButtonView tapped")
            action()
        }
    }
}

struct UserCard: View {
    let name: String
    let accentColor: Color
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isFocused: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            let isHighlighted = isFocused

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(isHighlighted ? accentColor.opacity(0.25) : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(isHighlighted ? accentColor : Color.black,
                                lineWidth: isFocused ? 6 : 4)
                )
                .shadow(color: (isHighlighted ? accentColor : Color.black).opacity(0.7), radius: 0, x: 10, y: 10)

            VStack {
                Spacer()
                Text(name)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(accentColor, lineWidth: 4)
                    )
                    .frame(width: 220, height: 14)
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 30)
        }
        .frame(width: 280, height: 360)
        .scaleEffect(isFocused ? 1.03 : 1.0)
        .focusable(true) { focused in
            isFocused = focused
        }
        .onTapGesture {
            onTap()
        }
    }
}

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

struct QuickNoteScreen: View {
    let onCancel: () -> Void
    let onSelectNote: (String) -> Void

    private let leftNotes = ["BUY MILK", "GOOD LUCK!", "I'M HOME"]
    private let rightNotes = ["CALL ME", "FEED THE DOG", "RUNNING LATE"]

    @State private var customNote: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var hasInitiallyFocusedField: Bool = false

    private func quickNoteColor(for title: String) -> Color {
        switch title {
        case "BUY MILK", "CALL ME":
            return Color(red: 0.98, green: 0.90, blue: 1.0) // pastel purple
        case "GOOD LUCK!", "FEED THE DOG":
            return Color(red: 1.0, green: 0.95, blue: 0.85) // pastel orange
        case "I'M HOME", "RUNNING LATE":
            return Color(red: 1.0, green: 0.88, blue: 0.88) // pastel red
        default:
            return Color(red: 1.0, green: 0.97, blue: 0.88)
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack {
                VStack(spacing: 30) {
                    HStack {
                        QuickNoteBackButtonView(action: onCancel)
                        Spacer()
                    }

                    Text("ADD A QUICK NOTE")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.black)

                    Text("Select a note to add to the board.")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.gray)

                    HStack(spacing: 80) {
                        VStack(spacing: 30) {
                            ForEach(leftNotes, id: \.self) { title in
                                QuickNoteButton(title: title, backgroundColor: quickNoteColor(for: title)) {
                                    onSelectNote(title)
                                }
                            }
                        }
                        VStack(spacing: 30) {
                            ForEach(rightNotes, id: \.self) { title in
                                QuickNoteButton(title: title, backgroundColor: quickNoteColor(for: title)) {
                                    onSelectNote(title)
                                }
                            }
                        }
                    }

                    VStack(spacing: 12) {
                        Text("Or write your own note:")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)

                        HStack(spacing: 16) {
                            TextField("Type a note", text: $customNote)
                                .font(.system(size: 24))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color(red: 208.0/255.0, green: 195.0/255.0, blue: 241.0/255.0)) // #D0C3F1
                                .cornerRadius(4)
                                .focused($isTextFieldFocused)

                            Button(action: {
                                let trimmed = customNote.trimmingCharacters(in: .whitespacesAndNewlines)
                                print("ADD pressed, customNote='\(customNote)', trimmed='\(trimmed)'")
                                guard !trimmed.isEmpty else { return }
                                onSelectNote(trimmed)
                                customNote = ""
                            }) {
                                Text("ADD")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color(red: 254.0/255.0, green: 241.0/255.0, blue: 171.0/255.0)) // #FEF1AB
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.black, lineWidth: 3)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                        OnScreenKeyboardView(
                            text: $customNote
                        )
                    }

                    Button(action: onCancel) {
                        Text("CANCEL")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(.top, 20)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 80)
                .padding(.horizontal, 120)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke(Color.black, lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.85), radius: 0, x: 12, y: 12)
                )
            }
            .onAppear {
                // Focus the text field once so the tvOS keyboard appears,
                // but still allow focus to move to other controls (like ADD).
                if !hasInitiallyFocusedField {
                    hasInitiallyFocusedField = true
                    DispatchQueue.main.async {
                        isTextFieldFocused = true
                    }
                }
            }
        }
    }
}

struct QuickNoteButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 320, height: 70)
                .background(
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .fill(backgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2, style: .continuous)
                                .stroke(Color.black, lineWidth: 4)
                        )
                        .shadow(color: .black.opacity(0.9), radius: 0, x: 10, y: 10)
                )
        }
        .buttonStyle(.plain)
    }
}

struct BoardScreen: View {
    let notes: [BoardNote]
    let userName: String
    let onAddNote: () -> Void
    let onDeleteNote: (Int) -> Void
    let onBack: () -> Void

    private func color(for userName: String) -> Color {
        switch userName {
        case "Dad":
            return Color(red: 0xE9/255, green: 0xF9/255, blue: 0xE5/255) // #E9F9E5
        case "Mom":
            return Color(red: 0xFF/255, green: 0xD7/255, blue: 0xEE/255) // #FFD7EE
        case "Kid":
            return Color(red: 0xCE/255, green: 0xEE/255, blue: 0xF8/255) // #CEEEF8
        default:
            return Color.yellow.opacity(0.9)
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    BackButtonView(action: onBack)
                        .padding(.leading, 40)
                    Spacer()
                    Text("FamilyBoard")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    Circle()
                        .fill(Color.white)
                        .frame(width: 60, height: 60)
                        .overlay(Circle().stroke(Color.black, lineWidth: 3))
                        .padding(.trailing, 40)
                }
                .padding(.top, 30)

                Rectangle()
                    .fill(Color.black)
                    .frame(height: 4)
                    .padding(.top, 6)

                // Grid of sticky notes: 5 columns per row, wrapping onto new rows
                let columns = Array(repeating: GridItem(.fixed(320), spacing: 28), count: 5)

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 28) {
                        ForEach(Array(notes.enumerated()), id: \.offset) { index, note in
                            let baseColor = color(for: note.userName)
                            StickyNoteView(
                                text: note.text,
                                color: baseColor,
                                onDelete: { onDeleteNote(index) }
                            )
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 30)
                }

                Spacer()
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    PlusButtonView(action: onAddNote)
                        .padding(.trailing, 60)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            print("=== BoardScreen appeared, notes count: \(notes.count) ===")
        }
    }
}

struct StickyNoteView: View {
    let text: String
    let color: Color
    let onDelete: () -> Void

    var body: some View {
        FocusableNoteContainer(onActivate: onDelete) {
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(color)
                    .shadow(color: .black.opacity(0.8), radius: 0, x: 10, y: 10)

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        Image(systemName: "pin.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .padding(.trailing, 16)
                    }

                    Text(text)
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color.red)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 44, height: 44)
                        .padding(.trailing, 16)
                        .padding(.bottom, 14)
                    }
                }
            }
        }
        .frame(width: 320, height: 190)
    }
}

struct PlusButtonView: View {
    let action: () -> Void
    @State private var isFocused: Bool = false

    var body: some View {
        ZStack {
            // Black shadow circle behind
            Circle()
                .fill(Color.black)
                .frame(width: 84, height: 84)
                .offset(x: 6, y: 6)

            // Main blue button circle
            Circle()
                .fill(Color.blue)
                .frame(width: 80, height: 80)
                .overlay(
                    Circle()
                        .stroke(isFocused ? Color.yellow : Color.black,
                                lineWidth: isFocused ? 6 : 4)
                )
                .overlay(
                    Image(systemName: "plus")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                )
        }
        .scaleEffect(isFocused ? 1.08 : 1.0)
        .focusable(true) { focused in
            isFocused = focused
        }
        .onTapGesture {
            print("PlusButtonView tapped via onTapGesture")
            action()
        }
    }
}

struct FocusableNoteContainer<Content: View>: View {
    let onActivate: () -> Void
    @ViewBuilder let content: Content
    @State private var isFocused: Bool = false

    var body: some View {
        content
            .scaleEffect(1.0)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isFocused ? Color.yellow : Color.clear,
                            lineWidth: isFocused ? 5 : 0)
            )
            .focusable(true) { focused in
                isFocused = focused
            }
            .onTapGesture {
                if isFocused {
                    onActivate()
                }
            }
    }
}

#Preview {
    ContentView()
}
