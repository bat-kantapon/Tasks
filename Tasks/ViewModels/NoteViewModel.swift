//
//  NoteViewModel.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import Foundation
import Alamofire
import Combine
import Firebase
import FirebaseFirestore
import FirebaseDatabase

struct NoteResponse: Decodable {
    var id: Int
    var title: String
    var body: String
}

class NoteViewModel: ObservableObject {
    @Published private(set) var userAddedNotes: [Note] = []
    @Published private(set) var fetchedNotes: [Note] = []
    private var ref: DatabaseReference!
    
    init() {
        FirebaseApp.configure()
        ref = Database.database().reference()
        fetchNotes()
    }
    
    func addOrUpdateUserAddedNote(_ note: Note) {
        if let index = userAddedNotes.firstIndex(where: { $0.id == note.id }) {
            userAddedNotes[index] = note
        } else {
            var newNote = note
            newNote.id = UUID()
            userAddedNotes.append(newNote)
            saveNoteToFirebase(newNote)
        }
    }
    
    func deleteNoteUserAdded(at offsets: IndexSet) {
        userAddedNotes.remove(atOffsets: offsets)
    }
    
    func fetchNotes() {
        AF.request("https://jsonplaceholder.typicode.com/posts")
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [NoteResponse].self) { response in
                switch response.result {
                    case .success(let notesResponse):
                        let fetchedNotes = notesResponse.map { noteResponse in
                            return Note(title: noteResponse.title, content: noteResponse.body)
                        }
                        self.fetchedNotes = fetchedNotes
                    case .failure(let error):
                        print("Error fetching notes: \(error)")
                    }
            }
    }
    
    private func saveNoteToFirebase(_ note: Note) {
        let noteRef = ref.child("notes").childByAutoId()
        noteRef.setValue([
            "id": note.id.uuidString,
            "title": note.title,
            "content": note.content
        ])
    }

}
