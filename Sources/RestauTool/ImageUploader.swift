//
//  ImageUploader.swift
//  Comutext
//
//  Created by Paul Brendtner on 20.02.23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage


struct ImageUploader{
    static func uploadImage(data: Data, completion: @escaping (String) -> Void){
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(data, metadata: nil) { _, error in
            if let error = error{
                print("DEBUG: Couldnt upload imageData Error: \(error)")
                return
            }
            ref.downloadURL { imageURL, error in
                if let error = error{
                    print("DEBUG: Couldnt download URL Error: \(error)")
                    return
                }
                
                guard let imageURL = imageURL?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
    
    
    static func deleteImage(forRef ref: String, completion: @escaping(Error?) -> Void){
        Storage.storage().reference(forURL: ref).delete { error in
                completion(error)
        }
    }
    
}
