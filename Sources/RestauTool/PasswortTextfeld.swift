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
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(.darkGray))
                if showsPassword{
                    TextField("Passwort eingeben", text: $password)
                        .textInputAutocapitalization(.never)
                }else{
                    SecureField("Passwort eingeben", text: $password)
                        .textInputAutocapitalization(.never)
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
