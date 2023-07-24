//
//  GerichteService.swift
//  
//
//  Created by Paul Brendtner on 29.06.23.
//

import Firebase
import FirebaseFirestore

struct GerichteService{
    
    func fetchGerichte(forTable id: String, completion: @escaping(Result<[Gericht], Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid)
            .collection("tables")
            .document(id)
            .collection("orders")
            .addSnapshotListener{ snapshot, error in
                if let error = error{
                    completion(.failure(FirestoreError(error)))
                    return
                }
                guard let doc = snapshot?.documents else { return }
                let gerichte = doc.compactMap({try? $0.data(as: Gericht.self)})
                completion(.success(gerichte))
        }
    }
    
//    func uploadAlleGerichte(forTable tableId: String, gerichte: [Gericht], completion: @escaping() -> Void){
//        
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        let ref = Firestore.firestore().collection("users").document(uid)
//            .collection("gerichte")
//        
//        for i in 0..<gerichte.count{
//            let id = UUID().uuidString
//            
//            ref.document(id)
//                .setData(["name":gerichte[i].name,
//                          "id":id
//
//    ])
//        }
//    }
    
    func fetchGericht(forTable id: String, forOrderId orderId: String, completion: @escaping(Result<Gericht, Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid)
            .collection("tables")
            .document(id)
            .collection("orders")
            .document(orderId)
            .getDocument { snapshot, error in
                if let error = error{
                    completion(.failure(FirestoreError(error)))
                    return
                }
                guard let doc = snapshot else { return }
                guard let gericht = try? doc.data(as: Gericht.self) else { return }
                completion(.success(gericht))
        }
    }
    
    func uploadGericht(_ order: Gericht, toTable table: String, completion: @escaping(Result<[Gericht], Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let id = UUID().uuidString
        
        let data = [
            "id" : id,
            "name" : order.name,
            "preis" : order.preis,
            "sonderwunsch" : order.sonderwunsch as Any,
            "tableId" : table
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid)
            .collection("tables")
            .document(table)
            .collection("orders")
            .document(id)
            .setData(data) { error in
                if let error = error{
                    completion(.failure(FirestoreError(error)))
                    return
                }
                self.fetchGerichte(forTable: table) { gerichte in
                    completion(gerichte)
                }
            }
    }
    
    
    func gerichtFinished(_ order: Gericht, changedTo state: Bool, completion: @escaping(Result<Gericht, Error>) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = order.id else { return }
        guard let tableId = order.tableId else { return }
        Firestore.firestore().collection("users").document(uid).collection("tables")
            .document(tableId)
            .collection("orders")
            .document(id)
            .updateData(["istSchonGekommen" : state]) { error in
                if let error = error{
                    completion(.failure(FirestoreError(error)))
                    return
                }
                self.fetchGericht(forTable: tableId, forOrderId: id) { gericht in
                    completion(gericht)
                }
            }
        }
    
}
