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
                //.font(Font.custom("Segoe UI", size: 18))
            
            FromOtherView(noteViewModel: noteViewModel)
                .tabItem {
                    Image(systemName: "cloud.fill")
                    Text("Other")
                }
                //.font(Font.custom("Segoe UI", size: 18))

            AddNoteView(noteViewModel: noteViewModel)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Add")
                }
                //.font(Font.custom("Segoe UI", size: 18))
        }
        .font(Font.custom("Segoe UI", size: 18))
    }
}
