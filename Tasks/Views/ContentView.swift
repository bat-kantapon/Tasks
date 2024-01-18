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
                    Text("List").font(Font.custom("Segoe UI", size: 12))
                }
                .background(Color(red: 0.02, green: 0.02, blue: 0.13))

            FromOtherView(noteViewModel: noteViewModel)
                .tabItem {
                    Image(systemName: "cloud.fill")
                    Text("Other").font(Font.custom("Segoe UI", size: 12))
                }
                .background(Color(red: 0.02, green: 0.02, blue: 0.13))

            AddNoteView(noteViewModel: noteViewModel)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Add").font(Font.custom("Segoe UI", size: 12))
                }
                .background(Color(red: 1, green: 0.93, blue: 0.67))
        }
        
        .environment(\.font, Font.custom("Segoe UI", size: 18))
        .accentColor(Color(red: 1, green: 0.87, blue: 0.41))
        .background(Color(red: 1, green: 0.93, blue: 0.67))
    }
}
