//
//  ReservationService.swift
//  
//
//  Created by Paul Brendtner on 10.07.23.
//

import SwiftUI

struct ReservationService{
    
    func daysBetween(start: Date, end: Date) -> Int {
            return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    func addReservation(forDate date: Date) throws {
        if daysBetween(start: .now, end: date) < 366{
            throw ReservationError.zuWeitImVoraus(abWannBuchbar: <#T##Date#>)
        }
    }
    let test = Calendar.current.date(byAdding: .year, to: <#T##Date#>)
}
