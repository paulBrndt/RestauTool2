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
@available(iOS 16.0, *)
extension RestauTool{
    /// Eine Funktion, die alle Tische, die zu Firebase hochgeladen wurden, mit ihren Bestellungen abruft
public func ladeAlleTische(){
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
