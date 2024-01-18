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
                .font(Font.custom("Segoe UI", size: 18))
                .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
            Spacer()
        }
        //.background(Color(red: 0.02, green: 0.02, blue: 0.13))
        .background(Color(red: 1, green: 0.93, blue: 0.67))
        .navigationBarTitle(note.title, displayMode: .inline)
        .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
        .navigationBarItems(trailing: Button("Edit") {
            showUpdateNoteView = true
        })
        .sheet(isPresented: $showUpdateNoteView) {
            UpdateNoteView(noteViewModel: noteViewModel, note: note)
        }
    }
}



