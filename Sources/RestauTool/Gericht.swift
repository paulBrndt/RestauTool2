//
//  Gericht.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Foundation
import FirebaseFirestoreSwift

/// Ein einzelnes Gericht bzw. Getränk
public struct Gericht: Identifiable, Decodable{
    /// Die ID wird von Firebase-Firestore benötigt, ist die Adresse zu dem betreffenden Dokument und ist erforderlich, damit die Struktur dem Identifiable-Protokoll entspricht
    @DocumentID public var id: String?
    ///  Wie heißt dein Essen bzw. trinken
    public let name: String
    /// Wie teuer ist es?
    public let preis: Double
    /// Falls es einen Sonderwunsch gibt kannst du ihn mit dieser Variable abrufen
    public var sonderwunsch: String?
    /// Eine Variable die anzeigt, ob das Essen schon am Tisch angekommen ist
    public var istSchonGekommen: Bool
    var tableId: String?
    
    
    /// Die Initialisierung der Gericht-Struktur
    /// - Parameters:
    ///   - id: Die ID wird von Firebase-Firestore benötigt, ist die Adresse zu dem betreffenden Dokument und ist erforderlich, damit die Struktur dem Identifiable-Protokoll entspricht
    ///   - name: Wie heißt dein Essen bzw. trinken
    ///   - preis: Wie teuer ist es?
    ///   - sonderwunsch: Falls es einen Sonderwunsch gibt kannst du ihn mit dieser Variable abrufen
    ///   - istSchonGekommen:Eine Variable die anzeigt, ob das Essen schon am Tisch angekommen ist → Standardwert ist false
    public init(name: String, preis: Double, sonderwunsch: String? = nil, istSchonGekommen: Bool? = false) {
        self.name = name
        self.preis = preis
        self.sonderwunsch = sonderwunsch
        self.istSchonGekommen = istSchonGekommen ?? false
    }
    
    
    public mutating func gerichtIstGekommen(istGekommen state: Bool = true){
        let service = GerichteService()
        
        var mutable = self
        
        service.gerichtFinished(self, changedTo: state) { result in
            switch result {
            case .success(let gericht):
                mutable = gericht
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self = mutable
    }
}
