//
//  FromOtherView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//
import SwiftUI

struct FromOtherView: View {
    @ObservedObject var noteViewModel: NoteViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(noteViewModel.fetchedNotes) { note in
                    NavigationLink(destination: ReadNoteView(note: note, noteViewModel: noteViewModel)) {
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.content)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: noteViewModel.deleteNoteUserAdded)
            }
            .navigationTitle("Other")
            .onAppear {
                noteViewModel.fetchNotes()
            }
        }
    }
}
