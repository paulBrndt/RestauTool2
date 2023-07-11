//
//  ReservationService.swift
//  
//
//  Created by Paul Brendtner on 10.07.23.
//

import SwiftUI
import Foundation

struct ReservationService{
    
    func daysBetween(start: Date, end: Date) -> Int {
            return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func findTableForReservation(date: Date, people: Int) throws {
        #warning("Falls kein Tisch verfügbar ist ReservationError.schonBelegt benutzen")
        #warning("Auf Anzahl der Personen achten")
        
    }
    
    func addReservation(forDate date: Date, withHowManyPeople people: Int) throws {
        if daysBetween(start: .now, end: date) < 366{
            throw ReservationError.zuWeitImVoraus(abWannBuchbar: Calendar.current.date(byAdding: .year, value: 1, to: .now))
        }
        
        
    }
    
    
    
    
    
}
