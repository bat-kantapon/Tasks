//
//  CustomButton.swift
//  Tasks


import SwiftUI
struct CustomButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Segoe UI", size: 18))
                .foregroundColor(Color(red: 1, green: 0.87, blue: 0.41))
                .frame(width: 281, height: 60)
                .background(
                    Rectangle()
                        .foregroundColor(Color(red: 0.02, green: 0.02, blue: 0.13))
                        .cornerRadius(15)
                        .shadow(
                            color: Color(red: 0.02, green: 0.02, blue: 0.13, opacity: 0.15), radius: 10, y: 1
                        )
                )
        }
    }
}
