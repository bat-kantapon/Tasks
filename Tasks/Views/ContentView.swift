//
//  ContentView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var noteViewModel = NoteViewModel()

    var body: some View {
        TabView {
            NotesListView(noteViewModel: noteViewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("List")
                }

            AddNoteView(noteViewModel: noteViewModel)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Add")
                }
        }
    }
}
