//
//  UrlImage.swift
//  
//
//  Created by Paul Brendtner on 01.07.23.
//

import SwiftUI

@available(macOS 12.0, *)
@available(iOS 16.0, *)

extension RestauTool{
        
    public struct UrlImage<Content>: View where Content: View {
        let placeholder: () -> Content
        let urlString: String?
        let modifier: (Image) -> Content
        
        public init(_ url: String?,
                    image: @escaping (Image) -> Content,
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
