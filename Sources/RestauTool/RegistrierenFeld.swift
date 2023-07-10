//
//  LoginFeld.swift
//  
//
//  Created by Paul Brendtner on 04.07.23.
//

import SwiftUI

public struct RegistrierenFeld: View{
    @State private var feld: RegistrierenFeldAuftrag
    @State private var placeholder: String?
    @Binding private var text: String
    
    public init(feld: RegistrierenFeldAuftrag, text: Binding<String>, platzhalter: String? = nil) {
        self.feld = feld
        self._text = text
        self.placeholder = platzhalter
    }
    
    public var body: some View{
        if feld == .email{
            TextFeld(icon: "envelope", placeholder: placeholder ?? "Email hier eingeben", text: $text)
        } else if feld == .name{
            TextFeld(icon: "person", placeholder: placeholder ?? "Name hier eingeben", text: $text)
        } else if feld == .username{
            TextFeld(icon: "fork.knife", placeholder: placeholder ?? "Öffentlichen Benutzernamen für andere Restaurants hier eingeben", text: $text)
        } else if feld == .password{
            PasswordTextfeld(passwort: $text)
        } else {
            EmptyView()
        }
    }
}



public enum RegistrierenFeldAuftrag{
    case email
    case username
    case name
    case password
    
    var placeholder: String{
        switch self{
        case .email:
            return "Email hier eingeben"
        case .username:
            return "Öffentlichen Benutzernamen für andere Restaurants hier eingeben"
        case .name:
            return "Name hier eingeben"
        case .password:
            return ""
        }
    }
}
