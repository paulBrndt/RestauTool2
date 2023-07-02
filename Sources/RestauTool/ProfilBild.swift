//
//  ProfilBild.swift
//  
//
//  Created by Paul Brendtner on 01.07.23.
//

import SwiftUI

@available(macOS 12.0, *)

extension AuthModel{
    
    public struct ProfileImage<Content>: View where Content: View {
        let placeholder: () -> Content
        let urlString: String?
        let modifier: (Image) -> Image
        
        public init(_ url: String?,
                    image: @escaping (Image) -> Image,
                    @ViewBuilder placeholder: @escaping () -> Content) {
            self.placeholder = placeholder
            self.urlString = url
            self.modifier = image
        }
        
        public var body: some View {
            AsyncImage(url: urlString.flatMap(URL.init)) { image in
                modifier(image)
            } placeholder: {
                placeholder()
            }
        }
    }

}
