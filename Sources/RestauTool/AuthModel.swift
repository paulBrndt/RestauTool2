//
//  AuthModel.swift
//  Comutext
//
//  Created by Paul Brendtner on 12.02.23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import PhotosUI

@available(macOS 10.15, *)
public class AuthModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticatedUser = false
    /// Der zurzeit eingeloggte User mit all seinen Infos
    @Published public var user: User?
    
    private let service = UserService()
    
    public init(){
        self.userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    
    
    public func einloggen(mitEmail email: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                completion(error)
                return
            }
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
        }
        
    }
    
    
    
    public func registrieren(mitEmail email: String, username: String, name: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            guard let user = result?.user else { return }
            self.userSession = user
            
            let data = [
                "email": email,
                "username": username.lowercased(),
                "firstName": name,
                "uid": user.uid,
            ]
            Firestore.firestore()
                .collection("users")
                    .document(user.uid)
                        .setData(data){ error in
                            if let error = error{
                                print(error.localizedDescription)
                                return
                            }
                            self.didAuthenticatedUser = true
            }
        }
    }
    
    
    public func abmelden() {
            withAnimation{
                user = nil
                userSession = nil
                try? Auth.auth().signOut()
            }
        }
    
    
    public func löscheAccount(completion: @escaping(Error?) -> Void){
                
        Auth.auth().currentUser?.delete(){ error in
            if let error = error{
                completion(error)
                return
            }
        }
        guard let ref = user?.profileImageURL else { return }
        ImageUploader.deleteImage(forRef: ref) { error in
            if let error = error{
                completion(error)
                return
            }
        }
        guard let uid = user?.id else { return }
        service.deleteUserData(forUid: uid) { error in
            if let error = error{
                completion(error)
                return
            }
        }
            withAnimation {
                self.didAuthenticatedUser = false
                self.user = nil
                self.userSession = nil
        }
    }
    
    
    public func ladeProfilFotoHoch(_ data: Data){
        guard let uid = userSession?.uid else { return }
        
        ImageUploader.uploadImage(data: data) { ImageURL in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageURL":ImageURL]) { _ in
                    self.user?.profileImageURL = ImageURL
                    self.fetchUser()
                }
        }
    }
    
 func fetchUser(){
        guard let uid = userSession?.uid else { return }
        service.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    
    public func aktualisiereUser(_ user: User, completion: @escaping(Error?) -> Void){
        service.updateUserData(to: user) { user, error in
            if let error = error{
                completion(error)
                return
            }
            if let user = user{
                self.user = user
            }
        }
    }
}
