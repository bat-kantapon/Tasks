//
//  UpdateNoteView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import SwiftUI

struct UpdateNoteView: View {
    @ObservedObject var noteViewModel: NoteViewModel
    @Binding var note: Note

    @State private var title: String
    @State private var content: String

    // Control presentation mode
    @Environment(\.presentationMode) var presentationMode

    init(noteViewModel: NoteViewModel, note: Binding<Note>) {
        self.noteViewModel = noteViewModel
        self._note = note 
        _title = State(initialValue: note.wrappedValue.title)
        _content = State(initialValue: note.wrappedValue.content)
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
                    // Update using two-way binding
                    note.title = title
                    note.content = content
                    noteViewModel.addOrUpdateNote(note)

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
