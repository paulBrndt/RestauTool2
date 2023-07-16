//
//  LoginDaten.swift
//  
//
//  Created by Paul Brendtner on 03.07.23.
//

import SwiftUI

public class RegistrierenData: AuthData{
    @Published public var username = ""
    @Published public var name = ""
    
    public override init() { }
}
