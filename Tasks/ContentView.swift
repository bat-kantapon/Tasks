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
            var newNote = note
            newNote.id = UUID()
            notes.append(newNote)
        }
    }
}



struct ContentView: View {
    @StateObject private var noteViewModel = NoteViewModel()

    var body: some View {
        TabView {
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
                UpdateNoteView(noteViewModel: noteViewModel, note: Note(title: "", content: ""))
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Add")
            }

        }
    }

    // to delete a note
    func deleteNote(at offsets: IndexSet) {
        noteViewModel.notes.remove(atOffsets: offsets)
    }
}

struct ReadNoteView: View {
    @State private var isEditing = false
    var note: Note
    @ObservedObject var noteViewModel: NoteViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(note.content)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .navigationBarTitle(note.title, displayMode: .inline) // This sets the title at the top-left
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
    @State private var note: Note
    @State private var title: String
    @State private var content: String

    //control presentation mode
    @Environment(\.presentationMode) var presentationMode

    init(noteViewModel: NoteViewModel, note: Note) {
        self.noteViewModel = noteViewModel
        self._note = State(initialValue: note)
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
    }

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextEditor(text: $content)
                .padding()

            Button("Save") {
                // Check title and content not empty before saving
                if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                   !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    // Update instead of creating a new one
                    note.title = title
                    note.content = content
                    noteViewModel.addOrUpdateNote(note)

                    // closee view after saving
                    presentationMode.wrappedValue.dismiss()

                    // clear text after save
                    title = ""
                    content = ""
                }
            }
            .padding()
        }
        .navigationTitle("Create new Note")
    }
}
