//
//  NotesListView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import SwiftUI

struct NotesListView: View {
    @ObservedObject var noteViewModel: NoteViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(noteViewModel.userAddedNotes) { note in
                    NavigationLink(destination: ReadNoteView(note: note, noteViewModel: noteViewModel)) {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                                .font(Font.custom("Segue UI", size: 22))
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .font(Font.custom("Segue UI", size: 18))
                        }
                    }
                }
                .onDelete(perform: noteViewModel.deleteNoteUserAdded)
            }
            .navigationTitle("Notes")
        }
    }
}
