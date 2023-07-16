//
//  UserToEdit.swift
//  Comutext
//
//  Created by Paul Brendtner on 11.05.23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

public struct User: Identifiable, Decodable{
    @DocumentID public var id: String?
    public var email: String
    public var username: String
    public var firstName: String
    var profileImageURL: String
    public var tables: [Tisch]?
    
    public var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == id
    }
     
    public init(id: String? = nil, email: String, username: String, firstName: String, profileImageURL: String, tables: [Tisch]? = nil) {
        self.id = id
        self.email = email
        self.username = username
        self.firstName = firstName
        self.profileImageURL = profileImageURL
        self.tables = tables
    }
}
