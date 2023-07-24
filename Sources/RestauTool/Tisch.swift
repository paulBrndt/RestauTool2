//
//  Tisch.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Foundation
import FirebaseFirestoreSwift

/// Die Klasse Tisch entspricht einem einzelnem Tisch in einem Restaurant.
public struct Tisch: Identifiable, Decodable{
    /// Die ID wird von Firebase-Firestore benötigt, ist die Adresse zu dem betreffenden Dokument und ist erforderlich, damit die Struktur dem Identifiable-Protokoll entspricht
    @DocumentID public var id: String?
    /// Der Name des Tisches, er ist ein String, kann aber auch Zahlen enthalten bzw. nur aus Zahlen bestehen.
    public var name: String
    /// Eine Variable, die bestimmt, ob der Tisch besetzt ist oder nicht. Hierbei entspricht true dem Status besetzt
    public var isBesetzt: Bool
    /// Ein optionales Array aller bestellten Gerichte
    public var gerichte: [Gericht]?
    /// Personen, die an diesem Tisch Platz haben
    public var personen: Int
    
    public var reservierungen: [Reservierung]
    
    /// Der optionale und totale Preis aller Gerichte - wenn keine Gerichte vorhanden sind entspricht er nil
    public var totalPreis: Double? {
        guard let liste = self.gerichte else { return nil }
        return liste.compactMap({$0.preis}).reduce(0, +)
    }
    
    /// Die Initialisierung des Tisches
    /// - Parameters:
    ///   - name: Der Name des Tisches, er ist ein String, kann aber auch Zahlen enthalten bzw. nur aus Zahlen bestehen.
    ///   - personen: Die Anzahl der Personen, die an diesem Tisch Platz haben.
    public init(name: String, personen: Int) {
        self.name = name
        self.personen = personen
        self.isBesetzt = false
        self.reservierungen = []
    }
    
    
    public mutating func fügeGerichtHinzu(_ gericht: Gericht){
        guard let uid = id else { return }
        
        let service = GerichteService()
        
        var mutable = self
                    
            service.uploadGericht(gericht, toTable: uid) { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let gerichte):
                    mutable.gerichte = gerichte
                }
            }
        self = mutable
        }
    
    
    public mutating func gerichtIstGekommen(_ gericht: Gericht, istGekommen state: Bool = true) {
           guard var gerichte = gerichte else { return }

           let service = GerichteService()

           if let index = gerichte.firstIndex(where: { $0.id == gericht.id }) {
               gerichte[index].istSchonGekommen = state

               service.gerichtFinished(gerichte[index], changedTo: state) { updatedGericht in
                   switch updatedGericht{
                   case .failure(let error):
                       print(error.localizedDescription)
                   case .success(let gericht):
                       gerichte[index] = gericht
                   }
               }
           }

           self.gerichte = gerichte
       }
    
    public mutating func tischIstBesetzt(_ isBesetzt: Bool = true){
        self.isBesetzt = isBesetzt
    }
}
