import SwiftUI


struct Note: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}

class NoteViewModel: ObservableObject {
    @Published var notes: [Note] = []

    func addOrUpdateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
    }
}

struct ContentView: View {
    @StateObject private var noteViewModel = NoteViewModel()

    var body: some View {
        TabView {
            // First Page: List of Notes
            NavigationView {
                List {
                    ForEach(noteViewModel.notes) { note in
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
                    .onDelete(perform: deleteNote)
                }
                .navigationTitle("Notes")
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("List")
            }


            NavigationView {
                UpdateNoteView(noteViewModel: noteViewModel)
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Add")
            }
        }
    }

    // Function to delete a note
    func deleteNote(at offsets: IndexSet) {
        noteViewModel.notes.remove(atOffsets: offsets)
    }
}


struct ReadNoteView: View {
    @State private var isEditing = false
    var note: Note
    @ObservedObject var noteViewModel: NoteViewModel

    var body: some View {
        VStack {
            Text(note.title)
                .font(.title)
            Text(note.content)
                .padding()
            Spacer()
        }
        .navigationTitle("Read Note")
        .navigationBarItems(trailing:
            Button(action: {
                isEditing.toggle()
            }) {
                Text("Edit")
            }
            .sheet(isPresented: $isEditing) {
                UpdateNoteView(noteViewModel: noteViewModel, note: note)
            }
        )
    }
}


struct UpdateNoteView: View {
    @ObservedObject var noteViewModel: NoteViewModel
    @State private var title: String
    @State private var content: String

    init(noteViewModel: NoteViewModel, note: Note? = nil) {
        self.noteViewModel = noteViewModel
        _title = State(initialValue: note?.title ?? "")
        _content = State(initialValue: note?.content ?? "")
    }

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $content)
                .padding()

            Button("Save") {
                let editedNote = Note(title: title, content: content)
                noteViewModel.addOrUpdateNote(editedNote)
                // Clear the text fields after saving
                title = ""
                content = ""
            }
            .padding()
        }
        .navigationTitle("Update or Create Note")
    }
}

