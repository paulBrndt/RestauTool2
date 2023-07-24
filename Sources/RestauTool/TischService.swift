//
//  TischService.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Firebase

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
                    service.fetchGerichte(forTable: id) { result in
                        switch result{
                        case .success(let gerichte):
                            tische[i].gerichte = gerichte
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                completion(tische)
            }
    }
    
    
    
     public func uploadSingleTisch(_ tisch: Tisch, completion: @escaping(Tisch) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("users")
            .document(uid)
            .collection("tables")

            let currentRef = ref.document()
            let id = currentRef.documentID
            let data = [
                "id" : id,
                "name" : tisch.name,
                "isBesetzt" : tisch.isBesetzt] as [String : Any]
            currentRef.setData(data) { error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
            }
         self.fetchTable(forUid: id, completion: completion)
    }


    public func uploadTables(_ tische: [Tisch], completion: @escaping([Tisch]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("users")
            .document(uid)
            .collection("tables")

        for tisch in tische {
            self.uploadSingleTisch(tisch) { _ in }
        }
        self.fetchTables { tische in
            completion(tische)
        }
    }

}
