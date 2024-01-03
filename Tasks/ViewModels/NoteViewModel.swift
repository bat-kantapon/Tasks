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
import FirebaseDatabase

struct NoteResponse: Decodable {
    var id: String
    var title: String
    var content: String
}

struct NoteData: Encodable {
    let id: String
    let title: String
    let content: String
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
        AF.request("https://task-realtimedb-default-rtdb.asia-southeast1.firebasedatabase.app/notes.json")
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [String: NoteResponse].self) { response in
                switch response.result {
                case .success(let notesResponse):
                    let fetchedNotes = notesResponse.map { (_, noteResponse) in
                        return Note(title: noteResponse.title, content: noteResponse.content)
                    }
                    self.fetchedNotes = fetchedNotes
                case .failure(let error):
                    print("Error fetching notes: \(error)")
                }
            }
    }

    private func saveNoteToFirebase(_ note: Note) {
        let url = "https://task-realtimedb-default-rtdb.asia-southeast1.firebasedatabase.app/notes.json"

        let noteData = NoteData(
            id: note.id.uuidString,
            title: note.title,
            content: note.content
        )

        do {
            let encoder = JSONEncoder()
            let requestData = try encoder.encode(noteData)

            AF.upload(requestData, to: url, method: .post, headers: .none)
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let result):
                        print("Note posted to Firebase: \(result)")
                    case .failure(let error):
                        print("Error posting note: \(error)")
                    }
                }
        } catch {
            print("Error encoding note: \(error)")
        }
    }
}

