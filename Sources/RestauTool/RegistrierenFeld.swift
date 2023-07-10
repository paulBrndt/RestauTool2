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
    @Binding var text: String
    @Binding var data: RegistrierenData
    
    public init(feld: RegistrierenFeldAuftrag, text: Binding<String>, platzhalter: String? = nil, data: Binding<RegistrierenData>) {
        self.feld = feld
        self._text = text
        self.placeholder = platzhalter
        self._data = data
    }
    
    public var body: some View{
        if feld == .email{
            TextFeld(icon: "envelope", placeholder: placeholder ?? "Email hier eingeben", text: $data.email)
        } else if feld == .name{
            TextFeld(icon: "person", placeholder: placeholder ?? "Name hier eingeben", text: $data.name)
        } else if feld == .username{
            TextFeld(icon: "fork.knife", placeholder: placeholder ?? "Öffentlichen Benutzernamen für andere Restaurants hier eingeben", text: $data.username)
        } else if feld == .password{
            PasswordTextfeld(passwort: $data.password)
        } else {
            EmptyView()
        }
    }
}



public enum RegistrierenFeldAuftrag: CaseIterable, Identifiable{
    case email
    case username
    case name
    case password
    
    public var placeholder: String{
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
    
    public var icon: String{
        switch self{
        case .email:
            return "envelope"
        case .username:
            return "fork.knife"
        case .name:
            return "person"
        case .password:
            return ""
        }
    }
    
    public var id: UUID{
        return UUID()
    }
}
