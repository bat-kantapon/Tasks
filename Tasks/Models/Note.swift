//
//  Note.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import Foundation

struct Note: Identifiable {
    var id = UUID()
    var title: String
    var content: String
}
