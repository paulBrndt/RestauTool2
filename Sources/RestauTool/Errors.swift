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
    case istInVergangenheit
    case keinEingeloggterUser
    
    public var errorMessage: String{
        switch self {
        case .schonBelegt:
            
            return NSLocalizedString(
                "Leider ist der Tisch zur gewünschten Zeit schon belegt.",
                comment: "Alle Tische belegt")
            
        case let .zuWeitImVoraus(datum):
            
            if let date = datum{
                if #available(iOS 15.0, *) {
                    return NSLocalizedString(
                        "Leider ist dieser Termin noch zu weit entfernt. Probieren sie bitte ein näherliegendes Datum oder probieren sie es ab dem \(date.formatted(.dateTime.month().day().year())) nocheinmal",
                        comment: "Zu Weit in der zukunft")
                } else {
                    return NSLocalizedString(
                        "Leider ist dieser Termin noch zu weit entfernt. Probieren sie bitte ein näherliegendes Datum oder probieren sie es demnächst nocheinmal",
                        comment: "Zu Weit in der zukunft")
                }
            } else {
                return NSLocalizedString(
                    "Leider ist dieser Termin noch zu weit entfernt. Probieren sie bitte ein näherliegendes Datum oder probieren sie es demnächst nocheinmal",
                    comment: "Zu Weit in der zukunft")
            }
        case .istInVergangenheit:
            return NSLocalizedString("Leider ist dieser Termin in der Vergangenheit. Wolange sie nicht Zeitreisen können ist es nicht möglich diesen Tisch zu reservieren (-:", comment: "Ist in Vergangenheit")
            
        case .keinEingeloggterUser:
            return NSLocalizedString("Leider ist ein unbekannter Fehler aufgetreten. Stellen sie sicher, dass ein User angemeldet ist.", comment: "Kein angemeldeter User")
        }
    }
}
