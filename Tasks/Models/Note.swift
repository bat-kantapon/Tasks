//
//  Note.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import Foundation

//struct Note: Identifiable {
//    var id = UUID()
//    var firebaseID: String?
//    var title: String
//    var content: String
//}

class Note: Identifiable {
    var id = UUID()
    var firebaseID: String?
    var title: String
    var content: String

    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
