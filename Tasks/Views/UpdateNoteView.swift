//
//  UpdateNoteView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import SwiftUI

struct UpdateNoteView: View {
    @ObservedObject var noteViewModel: NoteViewModel
    @State private var note: Note
    @State private var title: String
    @State private var content: String

    //control presentation mode
    @Environment(\.presentationMode) var presentationMode

    init(noteViewModel: NoteViewModel, note: Note) {
        self.noteViewModel = noteViewModel
        self._note = State(initialValue: note)
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
                    // Update instead of creating a new one
                    note.title = title
                    note.content = content
                    noteViewModel.addOrUpdateNote(note)

                    // closee view after saving
                    presentationMode.wrappedValue.dismiss()

                    // clear text after save
                    title = ""
                    content = ""
                }
            }
            .padding()
        }
        .navigationTitle("Create new Note")
    }
}
