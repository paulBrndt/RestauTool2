//
//  PasswortTextfeld.swift
//  
//
//  Created by Paul Brendtner on 03.07.23.
//

import SwiftUI

struct PasswordTextfeld: View {
    @Binding var passwort: String
    @State private var showsPassword = false
    @State private var icon: String
    
    public init(passwort: Binding<String>, icon: String = "lock") {
        self._passwort = passwort
        self.icon = icon
    }
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                if showsPassword{
                    TextField("Passwort eingeben", text: $passwort)
                        .autocorrectionDisabled()
                }else{
                    SecureField("Passwort eingeben", text: $passwort)
                        .autocorrectionDisabled()
                    Button{
                        withAnimation(.linear(duration: 0.175)){
                            showsPassword.toggle()
                        }
                    }label:{
                        Image(systemName: showsPassword ? "eye.slash" : "eye")
                    }
                    .foregroundColor(.gray)
                }
            }
                Divider()
                    .background(Color(.gray))
        }
    }
}
