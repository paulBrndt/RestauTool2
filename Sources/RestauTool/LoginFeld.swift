//
//  LoginFeld.swift
//  
//
//  Created by Paul Brendtner on 04.07.23.
//

import SwiftUI

public struct LoginFeld: View{
    @State private var feld: LoginFeldAuftrag
    @State private var placeholder: String?
    @Binding private var text: String
    
    init(feld: LoginFeldAuftrag, text: Binding<String>, platzhalter: String? = nil) {
        self.feld = feld
        self._text = text
        self.placeholder = platzhalter
    }
    
    public var body: some View{
        if feld == .email{
            TextFeld(icon: "envelope", placeholder: placeholder ?? "Email hier eingeben", text: $text)
        } else if feld == .username{
            TextFeld(icon: "person", placeholder: placeholder ?? "Name hier eingeben", text: $text)
        } else if feld == .name{
            TextFeld(icon: "fork.knife", placeholder: placeholder ?? "Öffentlichen Benutzernamen für andere Restaurants hier eingeben", text: $text)
        } else if feld == .password{
            PasswordTextfeld(passwort: $text)
        } else {
            EmptyView()
        }
    }
}



public enum LoginFeldAuftrag{
    case email
    case username
    case name
    case password
}
