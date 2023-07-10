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
}
