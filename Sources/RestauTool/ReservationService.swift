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
    
    
    func findTableForReservation(date: Date, people: Int, tische: inout [Tisch]) -> Result<String, Error> {
        
        let availableTables = tische.filter { $0.isBesetzt == false && $0.personen >= people }

            // Überprüfen, ob es passende Tische gibt
            guard !availableTables.isEmpty else {
                return .failure(ReservationError.zuVieleLeute)
            }

            var tableFound = false
            
            // Überprüfen, ob die Tische zur gewünschten Zeit reserviert sind
            for table in availableTables {
                let isAlreadyReserved = table.reservierungen.contains { $0.date.dateValue() == date }
                if !isAlreadyReserved, let id = table.id {
                    tableFound = true
                    return .success(id)
                }
            }
            
            if !tableFound {
                return .failure(ReservationError.schonBelegt)
            }
    }
    
    
    func addReservation(at date: Date, withHowManyPeople people: Int, nameOfGuests: String, tische: inout [Tisch], completion: @escaping(Result<Reservierung, Error>) -> Void)  {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(ReservationError.keinEingeloggterUser))
            return }
        
        if daysBetween(start: Date(), end: date) > 366{
            completion(.failure(ReservationError.zuWeitImVoraus(abWannBuchbar: Calendar.current.date(byAdding: .year, value: 1, to: Date()))))
            return
        }
        
        var tableUid: String?
        
        switch findTableForReservation(date: date, people: people, tische: &tische){
        case .failure(let error):
            completion(.failure(error))
            return
        case .success(let id):
            tableUid = id
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
                    self.fetchReservation(forTable: tableUid, forResId: id) { result in
                        switch result{
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let reservierung):
                            completion(.success(reservierung))
                        }
                    }
                }
        } else {
            completion(.failure(ReservationError.schonBelegt))
        }
    }
    
    
    func fetchReservations(forTable tableUid: String, completion: @escaping(Result<[Reservierung], Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid)
            .collection("tables")
            .document(tableUid)
            .collection("reservations")
            .getDocuments { snapshot, error in
                if let error = error{
                    completion(.failure(FirestoreError(error)))
                }
                guard let docs = snapshot?.documents else { return }
                let reservations = docs.compactMap({ try? $0.data(as: Reservierung.self) })
                completion(.success(reservations))
            }
    }
    
    
    func fetchReservation(forTable tableUid: String, forResId id: String, completion: @escaping(Result<Reservierung, Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid)
            .collection("tables")
            .document(tableUid)
            .collection("reservations")
            .document(id)
            .getDocument { snapshot, error in
                if let error = error{
                    completion(.failure(FirestoreError(error)))
                }
                guard let reservation = try? snapshot?.data(as: Reservierung.self) else { return }
                completion(.success(reservation))
            }
    }
    
}
