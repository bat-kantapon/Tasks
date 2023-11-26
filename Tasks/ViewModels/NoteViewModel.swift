//
//  NoteViewModel.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import Foundation
import Alamofire
import Combine

struct NoteResponse: Decodable {
    var id: Int
    var title: String
    var body: String
}

class NoteViewModel: ObservableObject {
    @Published private(set) var notes: [Note] = []
    
    func addOrUpdateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            var newNote = note
            newNote.id = UUID()
            notes.append(newNote)
        }
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
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
                                        self.notes = fetchedNotes
                                    case .failure(let error):
                                        print("Error fetching notes: \(error)")
                                    }
                }
        }
    
}
