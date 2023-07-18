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
    
    
    func authPadding() -> some View {
        self
            .padding(.top, 36)
            .padding(.horizontal, 36)
            .padding(.bottom, 18)
    }
}
public extension Image{
    
    func profileImage(größe: CGFloat = 56) -> some View {
                self
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: größe, height: größe)
    }
}

@available(macOS 13.0, *)
@available(iOS 16.0, *)
public extension View{
    func platzhalter(größe: CGFloat = 56) -> some View {
        return Circle()
                .foregroundColor(.gray)
                .frame(width: größe, height: größe)
    }
}
