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
            let newNote = note
            newNote.id = UUID()
            userAddedNotes.append(newNote)
            saveNoteToFirebase(newNote)
        }
    }

    func deleteNoteUserAdded(at offsets: IndexSet) {
        let deletedNotes = offsets.map { userAddedNotes[$0] }
        userAddedNotes.remove(atOffsets: offsets)
        deleteNotesFromFirebase(deletedNotes)
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

                        if let jsonData = result.data(using: .utf8),
                           let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                           let firebaseID = json["name"] as? String {
                            // Assign the Firebase ID to note
                            note.firebaseID = firebaseID
                            print("Firebase ID: \(firebaseID)")
                        }
                    case .failure(let error):
                        print("Error posting note: \(error)")
                    }
                }
        } catch {
            print("Error encoding note: \(error)")
        }
    }
    private func deleteNotesFromFirebase(_ notes: [Note]) {
        for note in notes {
            if let firebaseID = note.firebaseID {
                let deleteURL = "https://task-realtimedb-default-rtdb.asia-southeast1.firebasedatabase.app/notes/\(firebaseID).json"

                AF.request(deleteURL, method: .delete)
                    .validate(statusCode: 200..<300)
                    .response { response in
                        switch response.result {
                        case .success:
                            print("Note deleted from Firebase. Firebase ID: \(firebaseID)")
                        case .failure(let error):
                            if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                                print("Error deleting note from Firebase: \(error)")
                                print("Firebase error message: \(errorMessage)")
                            } else {
                                print("Error deleting note from Firebase: \(error)")
                            }
                        }
                    }
            }
        }
    }
    func updateNoteInFirebase(_ note: Note) {
        guard let firebaseID = note.firebaseID else {
            return
        }

        let updateURL = "https://task-realtimedb-default-rtdb.asia-southeast1.firebasedatabase.app/notes/\(firebaseID).json"

        let noteData = NoteData(
            id: note.id.uuidString,
            title: note.title,
            content: note.content
        )

        do {
            let encoder = JSONEncoder()
            let requestData = try encoder.encode(noteData)

            AF.upload(requestData, to: updateURL, method: .put, headers: .none)
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let result):
                        print("Note updated in Firebase: \(result)")
                    case .failure(let error):
                        print("Error updating note: \(error)")
                    }
                }
        } catch {
            print("Error encoding note: \(error)")
        }
    }

}

