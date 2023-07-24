//
//  RestauTool.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Foundation
import Firebase

@available(macOS 10.15, *)
@available(iOS 16.0, *)
/// Das RestauTool beinhaltet das ganze Package und wird am besten durch ein ``environmentObject`` an die Views weitergegeben
public class RestauTool: ObservableObject{
    /// Alle Tische deines Restaurants, wenn noch keine vorhanden sind, musst du sie mit der Funktion "ladeTischeHoch(_ tische: [Tisch]) hochladen"
    @Published public var tische = [Tisch]()
    let tischService = TischService()
    let reserService = ReservationService()
    let service = UserService()
    
    @Published var userSession: FirebaseAuth.User?
    @Published public var didAuthenticatedUser = false
    /// Der zurzeit eingeloggte User mit all seinen Infos
    @Published public var user: User?
    
    
    
    public init(){
        self.userSession = Auth.auth().currentUser
        fetchUser()
        self.didAuthenticatedUser = self.user == nil ? false : true
    }
   
}

public final class Initialisierung{
    public static func configure(){
        FirebaseApp.configure()
    }
}
