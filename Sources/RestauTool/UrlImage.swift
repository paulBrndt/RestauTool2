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
        
    @available(macOS 13.0, *)
    public struct UrlImage<Content>: View where Content: View {
        let urlString: String?
        let modifier: (Image) -> Content
        
        public init(_ url: String?,
                    image: @escaping (Image) -> Content) {
            self.urlString = url
            self.modifier = image
        }
        
        public var body: some View {
            AsyncImage(url: urlString.flatMap(URL.init)) { image in
                modifier(image)
            } placeholder: {
                platzhalter()
            }
        }
    }

}
