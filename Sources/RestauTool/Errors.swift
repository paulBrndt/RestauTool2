//
//  Errors.swift
//  
//
//  Created by Paul Brendtner on 10.07.23.
//

import SwiftUI


public enum ReservationError: Error, LocalizedError{
    case schonBelegt
    case zuWeitImVoraus(abWannBuchbar: Date?)
    
    public var errorMessage: String{
        switch self {
        case .schonBelegt:
            
            return NSLocalizedString(
                "Leider ist der Tisch zur gewünschten Zeit schon belegt.",
                comment: "Alle Tische belegt")
            
        case let .zuWeitImVoraus(datum):
            
            if let date = datum{
                return NSLocalizedString(
                    "Leider ist dieser Termin noch zu weit entfernt. Probieren sie bitte ein näherliegendes Datum oder probieren sie es ab dem \(date.formatted(.dateTime.month().day().year())) nocheinmal",
                    comment: "Zu Weit in der Zukunft")
            } else {
                return NSLocalizedString(
                    "Leider ist dieser Termin noch zu weit entfernt. Probieren sie bitte ein näherliegendes Datum oder probieren sie es demnächst nocheinmal",
                    comment: "Zu Weit in der Zukunft")
            }
        }
    }
}
