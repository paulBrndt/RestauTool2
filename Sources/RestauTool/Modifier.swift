//
//  Modifier.swift
//  
//
//  Created by Paul Brendtner on 14.07.23.
//

import SwiftUI

struct WichtigerButton: ViewModifier{
    var farbe: Color
    var hintergrund: Color
    init(farbe: Color = .white, hintergrund: Color = .blue){
        self.farbe = farbe
        self.hintergrund = hintergrund
    }
    func body(content: content) -> View {
        content
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


public extension View{
    public func wichtigerButton(farbe: Color = .white, hintergrund: Color = .blue) -> some View {
        modifier(WichtigerButton(farbe: farbe, hintergrund: hintergrund))
    }
}
