//
//  ReadNoteView.swift
//  Tasks
//
//  Created by Kantapon Makwong on 26/11/2566 BE.
//

import SwiftUI

struct ReadNoteView: View {
    var note: Note
    @ObservedObject var noteViewModel: NoteViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(note.content)
                .padding(.leading, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .navigationBarTitle(note.title, displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
}
