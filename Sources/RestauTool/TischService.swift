//
//  TischService.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Firebase
import FirebaseFirestoreSwift

struct TischService{
    
    private let gerichteService = GerichteService()
    
    func fetchTable(forUid uid: String, completion: @escaping(Tisch) -> Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId)
            .collection("tables")
            .document(uid)
            .getDocument { snapshot, _ in
                
            if let snapshot = snapshot{
                
                guard let tisch = try? snapshot.data(as: Tisch.self) else { return }
                
            completion(tisch)
            
            } else { return }
        }
    }
    
    func fetchTables(completion: @escaping([Tisch]) -> Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(userId)
            .collection("tables")
            .getDocuments { snapshots, _ in
                
                guard let docs = snapshots?.documents else { return }
                
                var tische = docs.compactMap({try? $0.data(as: Tisch.self)})

                let service = GerichteService()
                
                for i in 0..<tische.count{
                    guard let id = tische[i].id else { break }
                    service.fetchGerichte(forTable: id) { gerichte in
                        tische[i].gerichte = gerichte
                    }
                }
                completion(tische)
            }
        }
    
    
    public func uploadTables(_ tische: [Tisch], completion: @escaping([Tisch]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("users")
            .document(uid)
            .collection("tables")
        
        for i in 0..<tische.count{
            let id = UUID().uuidString
            let data = [
                "id" : id,
                "name" : tische[i].name,
                "isBesetzt" : tische[i].isBesetzt] as [String : Any]
            ref.document(id).setData(data) { error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
            }
        }
        self.fetchTables { tische in
            completion(tische)
        }
    }
}
