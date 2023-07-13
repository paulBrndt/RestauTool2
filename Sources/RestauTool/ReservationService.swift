//
//  ReservationService.swift
//  
//
//  Created by Paul Brendtner on 10.07.23.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ReservationService{
    
    func daysBetween(start: Date, end: Date) -> Int {
            return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    
    
    func findTableForReservation(date: Date, people: Int) throws -> String {
        #warning("Falls kein Tisch verfügbar ist ReservationError.schonBelegt benutzen")
        #warning("Auf Anzahl der Personen achten")
        
        return ""
    }
    
    
    
    
    func addReservation(at date: Date, withHowManyPeople people: Int, nameOfGuests: String) throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        #warning("Error message erstellen")
        
        if daysBetween(start: Date(), end: date) > 366{
            throw ReservationError.zuWeitImVoraus(abWannBuchbar: Calendar.current.date(byAdding: .year, value: 1, to: Date()))
        }
        
        var tableUid: String?
        
        do {
            tableUid = try findTableForReservation(date: date, people: people)
        } catch {
            throw error
        }
        
        if let tableUid = tableUid{
            let id = UUID().uuidString
            Firestore.firestore().collection("users").document(uid)
                .collection("tables")
                .document(tableUid)
                .collection("reservations")
                .document(id)
                .setData(["id" : id,
                          "nameOfGuest" : nameOfGuests,
                          "people" : people,
                          "date" : Timestamp(date: date)])
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
