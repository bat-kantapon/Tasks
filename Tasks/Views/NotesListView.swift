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
                                .font(.custom("Segoe UI", size: 18))
                                //.foregroundColor(.red)
                            
                            Text(note.content)
                                .foregroundColor(.gray)
                                .font(.custom("Segoe UI", size: 14))
                        }
                    }
                }
                .onDelete(perform: noteViewModel.deleteNoteUserAdded)
            }
            .navigationTitle("Notes")
            .font(.custom("Segoe UI", size: 18))
        }
    }
}
