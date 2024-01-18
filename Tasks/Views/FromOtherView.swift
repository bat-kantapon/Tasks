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
                        ZStack {
                            Color(red: 0.02, green: 0.02, blue: 0.13)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(note.title)
                                    .font(Font.custom("Segoe UI", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 1, green: 0.87, blue: 0.41))

                                Text(note.content)
                                    .font(Font.custom("Segoe UI", size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 4)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .onDelete(perform: noteViewModel.deleteNoteUserAdded)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Other")
            //.background(Color(red: 0.02, green: 0.02, blue: 0.13))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    noteViewModel.fetchNotes()
                }
            }
        }
    }
}
