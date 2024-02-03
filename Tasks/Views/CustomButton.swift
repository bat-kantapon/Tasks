//
//  CustomButton.swift
//  Tasks

import Foundation
import SwiftUI

struct CustomButton {
    
    let blueNavy: Color = Color(red: 0.004, green: 0.275, blue: 0.447)
    
    func primaryButton(text: String) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .font(Font.custom("Segoe UI", size:20))
            .foregroundColor(Color(red: 0.11, green: 0.10, blue: 0.25))
            .frame(width: 281, height: 60)
            .padding()
            .background(Color(red: 1, green: 0.87, blue: 0.41))
            .cornerRadius(15)
            .padding(5)
    }
    
    func secondaryButton(text: String) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .font(Font.custom("Segoe UI", size:20))
            .foregroundColor(Color(red: 1, green: 0.87, blue: 0.41))
            .frame(width: 281, height: 60)
            .padding()
            //.background(Color(.white))
            .cornerRadius(15)
            .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .inset(by: 1.50)
                            .stroke(Color(red: 1, green: 0.87, blue: 0.41), lineWidth: 1.50)
                    )
            .padding(5)
    }
    
    func thirdButton(text: String) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .font(Font.custom("Segoe UI", size:20))
            .foregroundColor(Color(red: 1, green: 0.87, blue: 0.41))
            .frame(width: 325, height: 60)
            .padding()
            .background(Color(red: 0.02, green: 0.02, blue: 0.13))
            .cornerRadius(15)
            .padding(5)
    }
    
}
