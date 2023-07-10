//
//  LoginDaten.swift
//  
//
//  Created by Paul Brendtner on 03.07.23.
//

import SwiftUI

public class RegistrierenData: ObservableObject{
    @Published public var email = ""
    @Published public var username = ""
    @Published public var name = ""
    @Published public var password = ""
    
    public init(email: String = "", username: String = "", name: String = "", password: String = "") {
        self.email = email
        self.username = username
        self.name = name
        self.password = password
    }
}
