//
//  Reservierung.swift
//  
//
//  Created by Paul Brendtner on 10.07.23.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

public struct Reservierung: Decodable, Identifiable{
    @DocumentID public var id: String?
    public var date: Timestamp
    public var nameOfGuest: String
    public var people: Int
    
    public init(zeitpunkt: Timestamp, nameDerGäste: String, personen: Int) {
        self.date = zeitpunkt
        self.nameOfGuest = nameDerGäste
        self.people = personen
    }
}
