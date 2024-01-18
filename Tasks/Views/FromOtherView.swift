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
                                .font(Font.custom("Segoe UI", size: 18))
                                .fontWeight(.bold)
                            Text(note.content)
                                .font(Font.custom("Segoe UI", size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: noteViewModel.deleteNoteUserAdded)
            }
            .navigationTitle("Other")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    noteViewModel.fetchNotes()
                }
            }
        }
    }
}
