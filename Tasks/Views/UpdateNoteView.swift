//
//  UpdateNoteView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import SwiftUI

struct UpdateNoteView: View {
    @ObservedObject var noteViewModel: NoteViewModel
    var note: Note

    @State private var editedNote: Note
    @State private var title: String
    @State private var content: String

    // Control presentation mode
    @Environment(\.presentationMode) var presentationMode

    init(noteViewModel: NoteViewModel, note: Note) {
        self.noteViewModel = noteViewModel
        self.note = note
        self._editedNote = State(initialValue: note) // Initialize editedNote with the initial value of note
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
    }

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $content)
                .padding()

            Button("Save") {
                // Check title and content not empty before saving
                if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                    !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    // Update the editedNote directly
                    editedNote.title = title
                    editedNote.content = content
                    noteViewModel.addOrUpdateUserAddedNote(editedNote)

                    // Close view after saving
                    presentationMode.wrappedValue.dismiss()

                    // Clear text after save
                    title = ""
                    content = ""
                }
            }
            .padding()
        }
        .navigationTitle("Edit Note")
    }
}
