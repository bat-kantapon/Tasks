//
//  AddNoteView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import SwiftUI


struct AddNoteView: View {
    @ObservedObject var noteViewModel: NoteViewModel
    @State private var newNote = Note(title: "", content: "")

    var body: some View {
        UpdateNoteView(noteViewModel: noteViewModel, note:$newNote)
    }
}
