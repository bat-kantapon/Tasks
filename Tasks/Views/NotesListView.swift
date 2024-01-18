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
                        ZStack{
                            Color(red: 0.02, green: 0.02, blue: 0.13)
                            .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text(note.title)
                                    .font(.custom("Segoe UI", size: 18))
                                    .foregroundColor(Color(red: 1, green: 0.87, blue: 0.41))
                                
                                Text(note.content)
                                    .foregroundColor(.gray)
                                    .font(.custom("Segoe UI", size: 14))
                            }
                            .padding(.leading, 4)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .onDelete(perform: noteViewModel.deleteNoteUserAdded)
            }
            .navigationTitle("Notes")
        }
        //.background(Color(UIColor(red: 0.22, green: 0.19, blue: 0.2, alpha: 1)))
        .accentColor(Color(red: 0.02, green: 0.02, blue: 0.13))
        //.background(Color(red: 0.02, green: 0.02, blue: 0.13))
        .background(Color(red: 1, green: 0.93, blue: 0.67))
    }
}
