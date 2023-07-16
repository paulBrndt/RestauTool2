//
//  LoginFeld.swift
//  
//
//  Created by Paul Brendtner on 16.07.23.
//

import SwiftUI

/// Das typische Feld zum Einloggen. Falls du keine fertigen Angeben verwenden möchtest kannst du das``TextFeld``oder das ``PasswortTextfeld``verwenden
public struct LoginFeld: View{
    @State private var feld: LoginFeldAuftrag
    @State private var placeholder: String?
    @Binding var data: AuthData
    
    /// Die Initialisierung
    /// - Parameters:
    ///   - feld: Welche Aufgabe hat dises Textfeld
    ///   - platzhalter: Ein optionaler Platzhalter der für dieses Feld verwendet wird
    ///   - data: Welche Werte sollen bearbeitet werden
    public init(feld: LoginFeldAuftrag, platzhalter: String? = nil, data: Binding<AuthData>) {
        self.feld = feld
        self.placeholder = platzhalter
        self._data = data
    }
    
    public var body: some View{
        if feld == .email{
            TextFeld(icon: feld.icon, placeholder: placeholder ?? feld.placeholder, text: $data.email)
        } else if feld == .password{
            PasswordTextfeld(passwort: $data.passwort)
        } else {
            EmptyView()
        }
    }
}

public enum LoginFeldAuftrag: CaseIterable, Identifiable{
    case email
    case password
    
    public var placeholder: String{
        switch self{
        case .email:
            return "Email hier eingeben"
        case .password:
            return "Passwort hier eingeben"
        }
    }
    
    public var icon: String{
        switch self{
        case .email:
            return "envelope"
        case .password:
            return "lock"
        }
    }
    
    public var id: UUID{
        return UUID()
    }
}
