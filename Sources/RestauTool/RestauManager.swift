//
//  RestauManager.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Foundation
import Firebase
import FirebaseFirestore

@available(macOS 10.15, *)
/// Eine Klasse, die benötigt wird um alle Bestellungen zu tätigen
public class RestauManager: ObservableObject{
   /// Alle Tische deines Restaurants, wenn noch keine vorhanden sind, musst du sie mit der Funktion "ladeTischeHoch(_ tische: [Tisch]) hochladen"
    @Published public var tische = [Tisch]()
    private let tischService = TischService()
    
    /// Bei der Initialisierung werden die hochgeladenen Tische, falls sie überhaupt hochgeladen sind, geladen
    public init(){
        self.ladeAlleTische()
    }
    
    
    func ladeAlleTische(){
        tischService.fetchTables { tische in
            self.tische = tische
        }
    }
    
    /// Eine Konfigurationsfunktion, die alle Tische zu Firebase hochlädt, damit du sie dann über die tische-Variable aufrufen kannst
    /// - Parameter tische: Alle Tische, die zu Firebase hochgeladen werden sollen
    public func ladeTischeHoch(_ tische: [Tisch]){
        tischService.uploadTables(tische) { tische in
            self.tische = tische
        }
    }
}
