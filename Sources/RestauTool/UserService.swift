//
//  UserService.swift
//  Comutext
//
//  Created by Paul Brendtner on 22.02.23.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService{
    
   public func fetchUser(withUid uid: String, completion: @escaping(User) -> Void){
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                if let snapshot = snapshot{
                    
                    guard let user = try? snapshot.data(as: StaticUser.self) else { return }
                    
                    completion(User(user))
                    
            }
        }
    }
    
   public func fetchUsers(completion: @escaping([User]) -> Void){
        Firestore.firestore().collection("users")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let users = documents.compactMap({try? $0.data(as: StaticUser.self)})
                completion(users.compactMap({User($0)}))
                
        }
    }
    
    public func deleteUserData(forUid uid: String, completion: @escaping(Error?) -> Void){
        Firestore.firestore().collection("users").document(uid).delete() { error in
            completion(error)
        }
    }
    
    
   public func updateUserData(to user: User, completion: @escaping(User?, Error?) -> Void){
        guard let uid = user.id else { return }
        
        Firestore.firestore().collection("users").document(uid)
            .updateData([
                "email" : user.email,
                "username" : user.username.lowercased(),
                "firstName" : user.firstName]) { error in
                    if let error = error{
                        completion(nil, error)
                        return
                    }
                    self.fetchUser(withUid: uid) { user in
                        completion(user, nil)
                    }
            }
    }
}
