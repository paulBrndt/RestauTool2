//
//  LoginFeld.swift
//  
//
//  Created by Paul Brendtner on 04.07.23.
//

import SwiftUI

/// Das typische Feld zum Registrieren. Falls du keine fertigen Angeben verwenden möchtest kannst du das``TextFeld``oder das ``PasswortTextfeld``verwenden
public struct RegistrierenFeld: View{
    @State private var feld: RegistrierenFeldAuftrag
    @State private var placeholder: String?
    @Binding var data: RegistrierenData
    
    /// Die Initialisierung
    /// - Parameters:
    ///   - feld: Welche Aufgabe hat dises Textfeld
    ///   - platzhalter: Ein optionaler Platzhalter der für dieses Feld verwendet wird
    ///   - data: Welche Werte sollen bearbeitet werden
    public init(feld: RegistrierenFeldAuftrag, platzhalter: String? = nil, data: Binding<RegistrierenData>) {
        self.feld = feld
        self.placeholder = platzhalter
        self._data = data
    }
    
    public var body: some View{
        if feld == .email{
            TextFeld(icon: feld.icon, placeholder: placeholder ?? feld.placeholder, text: $data.email)
        } else if feld == .name{
            TextFeld(icon: feld.icon, placeholder: placeholder ?? feld.placeholder, text: $data.name)
        } else if feld == .username{
            TextFeld(icon: feld.icon, placeholder: placeholder ?? feld.placeholder, text: $data.username)
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
