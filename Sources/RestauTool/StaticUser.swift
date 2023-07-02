//
//  User.swift
//  Comutext
//
//  Created by Paul Brendtner on 22.02.23.
//

import FirebaseFirestoreSwift
import Firebase

public struct StaticUser: Identifiable, Decodable{
    @DocumentID public var id: String?
    public let email: String
    public let username: String
    public let firstName: String
    public var profileImageURL: String
    public var tables: [Tisch]?
    
    public var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == id
    }
}
