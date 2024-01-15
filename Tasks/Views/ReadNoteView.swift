//
//  ReadNoteView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import SwiftUI

struct ReadNoteView: View {
    var note: Note
    @ObservedObject var noteViewModel: NoteViewModel
    @State private var showUpdateNoteView = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(note.content)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Font.custom("Segue UI", size: 18))
            Spacer()
        }
        .navigationBarTitle(note.title, displayMode: .inline)
        .navigationBarItems(trailing: Button("Edit") {
            showUpdateNoteView = true
        })
        .sheet(isPresented: $showUpdateNoteView) {
            UpdateNoteView(noteViewModel: noteViewModel, note: note)
        }
    }
}



