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
    
    func findTableForReservation(date: Date){
        
    }
    
    func addReservation(forDate date: Date, withHowManyPeople people: Int, completion: @escaping(Reservierung) -> Void) throws {
        if daysBetween(start: .now, end: date) < 366{
            throw ReservationError.zuWeitImVoraus(abWannBuchbar: Calendar.current.date(byAdding: .year, value: 1, to: .now))
            return
        }
        
        
    }
}
