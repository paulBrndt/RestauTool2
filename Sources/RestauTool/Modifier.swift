//
//  Modifier.swift
//  
//
//  Created by Paul Brendtner on 14.07.23.
//

import SwiftUI

@available(macOS 13.0, *)
@available(iOS 16.0, *)
public extension View{
    func wichtigerButton(farbe: Color = .white, hintergrund: Color = .blue) -> some View {
        self
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(farbe)
            .frame(width: 340, height: 50)
            .background(hintergrund)
            .clipShape(Capsule())
            .padding()
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
    }
}
