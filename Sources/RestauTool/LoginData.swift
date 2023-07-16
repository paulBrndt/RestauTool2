//
//  LoginData.swift
//  
//
//  Created by Paul Brendtner on 16.07.23.
//

import Foundation

public class LoginData: ObservableObject{
    @Published public var email = ""
    @Published public var passwort = ""
}
