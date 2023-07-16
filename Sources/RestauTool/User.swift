//
//  UserToEdit.swift
//  Comutext
//
//  Created by Paul Brendtner on 11.05.23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

public struct User: Identifiable{
    @DocumentID public var id: String?
    public var email: String
    public var username: String
    public var firstName: String
    var profileImageURL: String
    public var tables: [Tisch]?
    
    public var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == id
    }
        
    init(_ user: StaticUser) {
        self.id = user.id
        self.email = user.email
        self.username = user.username
        self.firstName = user.firstName
        self.profileImageURL = user.profileImageURL
        self.tables = user.tables
    }
}
