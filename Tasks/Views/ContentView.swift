//
//  ContentView.swift
//  Tasks
//
import SwiftUI

struct ContentView: View {
    @StateObject private var noteViewModel = NoteViewModel()
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                NoteListView(noteViewModel: noteViewModel)
            }
            .tabItem {
                Label("Local", systemImage: "square.grid.2x2")
            }
            .tag(0)

            NavigationView {
                FirebaseNoteListView(noteViewModel: noteViewModel)
                    .onAppear {
                        if selectedTab == 1 {
                            noteViewModel.fetchNotes()
                        }
                    }
            }
            .tabItem {
                Label("Cloud", systemImage: "cloud.fill")
            }
            .tag(1)
        }
        .onChange(of: selectedTab) { newTab in
            if newTab == 1 {
                noteViewModel.fetchNotes()
            }
        }
    }
}


struct NoteListItemView: View {
    var note: Note

    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.custom("SegoeUI", size: 16))
                .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))

            Text(note.content)
                .font(.custom("SegoeUI", size: 14))
                .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
                .lineLimit(1)
        }
        .padding()
        .listRowBackground(Color.blue)
        .cornerRadius(8)
    }
}

struct EditNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var noteViewModel: NoteViewModel
       var note: Note
       
       @State private var editedTitle: String
       @State private var editedContent: String

       init(noteViewModel: NoteViewModel, note: Note) {
           self.noteViewModel = noteViewModel
           self.note = note
           _editedTitle = State(initialValue: note.title)
           _editedContent = State(initialValue: note.content)
       }
    var body: some View {
        ZStack {
            Color(red: 1, green: 0.93, blue: 0.67).edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading) {
                CustomTextField(placeholder: "Title", text: $editedTitle)
                    .font(.custom("SegoeUI", size: 20))
                    .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
                    .padding()
                CustomTextField(placeholder: "Content", text: $editedContent)
                    .font(.custom("SegoeUI", size: 18))
                    .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
                    .padding()

                Spacer()
                Button(action: {
                    // Modify existing note
                    note.title = editedTitle
                    note.content = editedContent

                    // Update the note both on Firebase and local
                    noteViewModel.updateNoteInFirebase(note)
                    noteViewModel.addOrUpdateUserAddedNote(note)

                    // back to ReadNoteView
                    presentationMode.wrappedValue.dismiss()
                }) {
                    CustomButton().thirdButton(text: "SAVE CHANGE")
                }
                .padding()


            }
        }
        .navigationBarTitle("Edit Note")
    }
}

struct ReadNoteView: View {
    var note: Note
        @ObservedObject var noteViewModel: NoteViewModel
    

        init(note: Note, noteViewModel: NoteViewModel) {
            self.note = note
            self.noteViewModel = noteViewModel
        }

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.93, blue: 0.67).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.custom("SegoeUI", size: 20))
                    .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
                    .padding()
                
                Text(note.content)
                    .font(.custom("SegoeUI", size: 18))
                    .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
                    .padding()
                
                Spacer()
                
                NavigationLink(destination: EditNoteView(noteViewModel: noteViewModel, note: note)) {
                    CustomButton().thirdButton(text: "EDIT")
                }
            }
        }
        .navigationBarTitle("Read Note")
    }
}





struct FirebaseNoteListView: View {
    @ObservedObject var noteViewModel = NoteViewModel()

    var body: some View {
        ZStack {
            Color(red: 1, green: 0.93, blue: 0.67).edgesIgnoringSafeArea(.all)
            
            VStack {
                List {
                    ForEach(noteViewModel.fetchedNotes) { note in
                        FirebaseNoteListItemView(note: note)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Spacer()
            }
            .navigationBarTitle("Firebase Note List")
        }
    }
}

struct FirebaseNoteListItemView: View {
    var note: Note
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .font(.custom("SegoeUI", size: 16))
                .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
            Text(note.content)
                .font(.custom("SegoeUI", size: 14))
                .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
        }
        .padding()
        .listRowBackground(Color(red: 1, green: 0.93, blue: 0.67))
        .cornerRadius(8)
    }
}


struct NoteListView: View {
    @ObservedObject var noteViewModel: NoteViewModel
    @State private var isAddingNote = false

    var body: some View {
        NavigationView {
            ZStack {
                //Color(red: 1, green: 0.93, blue: 0.67).edgesIgnoringSafeArea(.all)

                VStack {
                    List {
                        ForEach(noteViewModel.userAddedNotes) { note in
                            NavigationLink(destination: ReadNoteView(note: note, noteViewModel: noteViewModel)) {
                                FirebaseNoteListItemView(note: note)
                            }
                        }
                        .onDelete { indexSet in
                            noteViewModel.deleteNoteUserAdded(at: indexSet)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                    //Spacer()

                    NavigationLink(
                        destination: CreateNoteView(noteViewModel: noteViewModel, isPresented: $isAddingNote),
                        isActive: $isAddingNote
                    ) {
                        EmptyView()
                    }

                    Button(action: {
                        isAddingNote = true
                    }) {
                        CustomButton().thirdButton(text: "ADD NEW")
                    }
                }
                .navigationBarTitle("Note List")
            }
        }
    }
}

struct CreateNoteView: View {
    @ObservedObject var noteViewModel: NoteViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    
    @State private var noteTitle = ""
    @State private var noteContent = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            CustomTextField(placeholder: "Title", text: $noteTitle)
                .font(.custom("SegoeUI", size: 20))
                .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
                .padding()

            CustomTextField(placeholder: "Content", text: $noteContent)
                .font(.custom("SegoeUI", size: 18))
                .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
                .padding()

            Spacer()

            Button(action: {
                let newNote = Note(title: noteTitle, content: noteContent)
                noteViewModel.addOrUpdateUserAddedNote(newNote)
                presentationMode.wrappedValue.dismiss()
                isPresented = false
            }) {
                CustomButton().primaryButton(text: "SAVE NOTE")
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Create Note")
    }
}
