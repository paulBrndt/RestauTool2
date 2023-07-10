//
//  RestauTool.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Foundation
import Firebase

@available(macOS 10.15, *)
/// Das RestauTool beinhaltet das ganze Package und wird am besten durch ein ``environmentObject`` an die Views weitergegeben
public class RestauTool: ObservableObject{
    /// Im ``manager``kann man Gerichte bestellen, Tische reservieren und vieles mehr...
    public var manager = RestauManager()
    /// Im ``auth``sind Funktionen zum Einloggen und Registrieren, sowie das Profilfoto eines Users...
    public var auth = AuthModel()
    
    public init(){
        FirebaseApp.configure()
    }
}

