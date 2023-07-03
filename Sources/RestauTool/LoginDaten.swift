//
//  LoginDaten.swift
//  
//
//  Created by Paul Brendtner on 03.07.23.
//

import SwiftUI

public class LoginDaten: ObservableObject{
    @Published public var email = ""
    @Published public var username = ""
    @Published public var name = ""
    @Published public var password = ""
}
