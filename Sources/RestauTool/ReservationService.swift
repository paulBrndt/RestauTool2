//
//  ReservationService.swift
//  
//
//  Created by Paul Brendtner on 10.07.23.
//

import SwiftUI
import Foundation
import Firebase

struct ReservationService{
    
    func daysBetween(start: Date, end: Date) -> Int {
            return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    
    
    func findTableForReservation(date: Date, people: Int, tische: inout [Tisch]) throws -> String {
        
        let availableTables = tische.filter { $0.isBesetzt == false && $0.personen >= people }

            // Überprüfen, ob es passende Tische gibt
            guard !availableTables.isEmpty else {
                throw ReservationError.zuVieleLeute
            }

            var tableFound = false
            
            // Überprüfen, ob die Tische zur gewünschten Zeit reserviert sind
            for table in availableTables {
                let isAlreadyReserved = table.reservierungen.contains { $0.date.dateValue() == date }
                if !isAlreadyReserved, let id = table.id {
                    tableFound = true
                    return id
                }
            }
            
            if !tableFound {
                throw ReservationError.schonBelegt
            }
    }
    
    
    func addReservation(at date: Date, withHowManyPeople people: Int, nameOfGuests: String, tische: inout [Tisch]) throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw ReservationError.keinEingeloggterUser }
        
        if daysBetween(start: Date(), end: date) > 366{
            throw ReservationError.zuWeitImVoraus(abWannBuchbar: Calendar.current.date(byAdding: .year, value: 1, to: Date()))
        }
        
        var tableUid: String?
        
        do {
            tableUid = try findTableForReservation(date: date, people: people, tische: &tische)
        } catch {
            throw error
        }
        
        if let tableUid = tableUid{
            let ref = Firestore.firestore().collection("users").document(uid)
                .collection("tables")
                .document(tableUid)
                .collection("reservations")
                .document()
            
            let id = ref.documentID
            
            ref
                .setData(["id" : id,
                          "nameOfGuest" : nameOfGuests,
                          "people" : people,
                          "date" : Timestamp(date: date)]) { error in
                    if let error = error{
                        
                    }
                }
        }
    }
    
    
    func fetchReservations(forTable tableUid: String, completion: @escaping([Reservierung]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid)
            .collection("tables")
            .document(tableUid)
            .collection("reservations")
            .getDocuments { snapshot, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let docs = snapshot?.documents else { return }
                let reservations = docs.compactMap({ try? $0.data(as: Reservierung.self) })
                completion(reservations)
            }
    }
    
}
