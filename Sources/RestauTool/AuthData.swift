//
//  AuthData.swift
//  
//
//  Created by Paul Brendtner on 16.07.23.
//

import Foundation


public class AuthData: ObservableObject{
    @Published public var email = ""
    @Published public var passwort = ""
    
    public init() {}
}
