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

@available(iOS 16.0, *)
@available(macOS 10.15, *)
/// Eine Klasse, die benötigt wird, um einmalige Aktionen, wie z.B. Bild hochladen oder Account löschen oder Dinge zur Authentifizierung, wie z.B. einloggen oder registrieren, auszuführen
extension RestauTool{
    
    
    /// Das Profilfoto des angemeldeten Users
    ///
    /// Verwendung:
    /// ```swift
    /// tool.auth.profilFoto { image in
    ///      image
    ///           .scaledToFit()
    /// //Alle Modifier wie z.B. .frame(width: 10) hierhin
    /// } platzhalter: {
    /// Text("Platzhalter")
    /// }
    /// ```
    /// - Parameters:
    ///   - bild: Wie soll das Bild aussehen; siehe Codebeispiel
    ///   - platzhalter: Wie soll der Platzhalter aussehen, siehe Codebeispiel
    public func profilFoto(modifier: @escaping (Image) -> Image, placeholder: @escaping () -> Text) -> UrlImage<Text> {
        return UrlImage(user?.profileImageURL, image: modifier, placeholder: placeholder)
        }
    
    
    /// Logge einen User ein
    /// - Parameters:
    ///   - email: Die hinterlegte Email
    ///   - password: Das hinterlegte Passwort
    ///   - completion: Falls es einen Fehler gibt wird er hier zurückgegeben
    
    public func einloggen(mitEmail email: String, password: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                completion(error)
                return
            }
            guard let user = result?.user else { return }
            self.didAuthenticatedUser = true
            self.userSession = user
            self.fetchUser()
        }
    }
    
    
    public func einloggen(mitDaten data: AuthData, completion: @escaping(Error?) -> Void) {
        self.einloggen(mitEmail: data.email, password: data.passwort, completion: completion)
    }
    
    
    /// Die Registrierung eines neuen Users
    /// - Parameters:
    ///   - email: Die Email-Adresse des neuen Users. Sie muss dem Email-Adressen Format entsprechen und darf nicht von einem anderen User bereits genutzt werden
    ///   - username: Der Username/Benutzername des Users.
    ///   - name: Der Name des Restaurants
    ///   - password: Das gewählte Passwort
    ///   - completion: Falls es einen Fehler gibt wird er hier zurückgegeben
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
                "id": user.uid,
            ]
            Firestore.firestore()
                .collection("users")
                    .document(user.uid)
                        .setData(data){ error in
                            if let error = error{
                                completion(error)
                                return
                            }
                            self.didAuthenticatedUser = true
                            self.fetchUser()
            }
        }
    }
    
    
    public func registrieren(mitDaten data: RegistrierenData, completion: @escaping(Error?) -> Void) {
        self.registrieren(mitEmail: data.email, username: data.username, name: data.name, password: data.passwort, completion: completion)
    }
    
    
    /// Melde den aktuellen User ab
    public func abmelden() {
            withAnimation{
                user = nil
                userSession = nil
                try? Auth.auth().signOut()
            }
        }
    
    
    /// Lösche den Account des Users, der gerade angemeldet ist
    /// - Parameter completion: Falls es einen Fehler gibt wird er hier zurückgegeben
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
        self.service.deleteUserData(forUid: uid) { error in
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

    ///Diese Funktion kann ein Profilfoto hochladen.
    ///
    ///Du kannst einen PhotoPicker verwenden, um das Foto aus der Fotomediathek zu downloaden.
    ///
    ///
    ///
    ///Zuallererst musst du ``PhotosUI` importieren
    /// ```swift
    /// import PhotosUI
    /// ```
    ///
    ///Dann musst du eine Variable erstellen, die dem Typ ``PhotosPickerItem`` entspricht und ein Optional ist. Dann musst du eine Variable erstellen, die Data entspricht und Optional ist.
    ///```swift
    ///@State private var selectedItem: PhotosPickerItem? = nil
    ///@State private var imageData: Data? = nil
    ///```
    ///
    ///Anschließend erstellst du einen ``PhotoPicker``.  ``selection`` ist hierbei das Foto, das verändert wird. Alles zwischen den geschweiften Klammern entspricht dem Platzhalter, der angezeigt wird. Beim Drücken von ihm öffnet sich der ``PhotoPicker``
    ///```swfit
    /// PhotosPicker(selection: $selectedItem){
    ///         Text("Placeholder")
    ///}
    ///```
    ///
    ///Füge unterhalb des PhotoPickers diesen Code hinzu. Dieser probiert das ``PhotoPickerItem``zu ``Data``umzuwandeln.
    ///```swift
    ///.onChange(of: selectedItem) { newItem in
    ///    Task {
    ///         if let data = try? await newItem?.loadTransferable(type: Data.self) {
    ///            imageData = data
    ///         }
    ///     }
    ///}
    ///```
    ///
    ///Ob ein Foto ausgewählt wurde kannst du mit diesem Code testen. In die Klammern kannst du zum Beispiel den "Weiter-Button" einbauen, der  ``ladeProfilFotoHoch(_:)`` ausführt. Falls der Button in den Klammern ist, musst du in die Klammern von ``ladeProfilFotoHoch(_:)`` nur ``data`` schreiben.
    ///```swift
    ///if let data = imageData{
    ///
    ///}
    ///```
    ///
    ///So sieht der ganze Code aus:
    ///```swift
    ///@State private var selectedItem: PhotosPickerItem? = nil
    ///@State private var imageData: Data? = nil
    ///var body: some View{
    ///         VStack{
    ///         PhotosPicker(selection: $selectedItem){
    ///                 Text("Placeholder")
    ///         }
    ///         .onChange(of: selectedItem) { newItem in
    ///             Task {
    ///                 if let data = try? await newItem?.loadTransferable(type: Data.self) {
    ///                      imageData = data
    ///                      }
    ///             }
    ///         }
    ///         if let data = imageData{
    ///                 Button("Weiter"){
    ///                 tool.auth.ladeProfilFotoHoch(data)
    ///                 }
    ///         }
    ///     }
    ///}
    ///```
    ///
    ///
    ///Falls du den PhotoPicker so anpassen möchtest, dass er falls ein Bild ausgeählt wurde, das Bild anzeigt geht das so:
    ///```swift
    ///@State private var selectedItem: PhotosPickerItem? = nil
    ///@State private var imageData: Data? = nil
    ///var body: some View{
    ///         VStack{
    ///         PhotosPicker(selection: $selectedItem){
    ///                 if let data imageData, let image = UIImage(data: data){
    ///                      Image(uiImage: image)
    ///                      .scaledToFit()
    ///                 } else {
    ///                 Text("Placeholder")
    ///                 }
    ///         }
    ///         .onChange(of: selectedItem) { newItem in
    ///             Task {
    ///                 if let data = try? await newItem?.loadTransferable(type: Data.self) {
    ///                      imageData = data
    ///                      }
    ///             }
    ///         }
    ///         if let data = imageData{
    ///                 Button("Weiter"){
    ///                 tool.auth.ladeProfilFotoHoch(data)
    ///                 }
    ///         }
    ///     }
    ///}
    ///```
    ///
    ///Falls du dein Bild außerhalb dieser View verwenden möchtest, nutze tool.auth.profilFoto(bild:platzhalter:)
    ///
    ///
    /// - Parameter data: Der Data Parameter; wie oben genannt verwenden
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
    
    @available(macOS 13.0, *)
    /// Eine etwas einfacher gestaltete Version dieser Funktion
    ///
    ///Sie ist aber asynchron und muss so verwendet werden
    ///```swift
    ///Task{
    ///tool.auth.ladeProfilFotoHoch(pickerItem)
    ///}
    ///```
    ///
    ///Dieses Task wird dabei unbedingt benötigt
    ///
    ///
    ///Am besten verwendest du das so:
    ///```swift
    ///@State private var selectedItem: PhotosPickerItem? = nil
    ///var body: some View{
    ///         VStack{
    ///         PhotosPicker(selection: $selectedItem){
    ///                 if let data imageData, let image = UIImage(data: data){
    ///                      Image(uiImage: image)
    ///                      .scaledToFit()
    ///                 } else {
    ///                 Text("Placeholder")
    ///                 }
    ///         }
    ///         .onChange(of: selectedItem) { newItem in
    ///             Task {
    ///                 if let data = try? await newItem?.loadTransferable(type: Data.self) {
    ///                      imageData = data
    ///                      }
    ///             }
    ///         }
    ///         if let data = imageData{
    ///                 Button("Weiter"){
    ///                 tool.auth.ladeProfilFotoHoch(photosPickerItem)
    ///                 }
    ///         }
    ///     }
    ///}
    ///```
    ///
    ///Falls du das Foto garnicht anzeigen möchtest reicht es so
    ///```swift
    ///@State private var selectedItem: PhotosPickerItem? = nil
    ///var body: some View{
    ///VStack
    ///         PhotosPicker(selection: $selectedItem){
    ///                 if let data imageData, let image = UIImage(data: data){
    ///                      Image(uiImage: image)
    ///                      .scaledToFit()
    ///                 } else {
    ///                 Text("Placeholder")
    ///                 }
    ///                 if let data = selectedItem{
    ///                 Button("Weiter"){
    ///                 tool.auth.ladeProfilFotoHoch(photosPickerItem)
    ///                 }
    ///              }
    ///         }
    ///     }
    ///}
    ///```
    ///
    ///
    ///
    /// - Parameter pickerItem: Ein ausgewähltes Foto eines PhotoPickers
    public func ladeProfilFotoHoch(_ pickerItem: PhotosPickerItem) async {
        guard let data = try? await pickerItem.loadTransferable(type: Data.self) else { return }
        self.ladeProfilFotoHoch(data)
    }
    
    
    
 public func fetchUser(){
     guard let uid = userSession?.uid else { return }
     self.service.fetchUser(withUid: uid) { user in
         self.user = user
        }
    }
    
    
    /// Falls der User seine Angaben ändern möchte kann er das hier bis auf die Email-Adresse tun
    /// - Parameters:
    ///   - user: Die neuen Daten in Form der ``User``-Klasse
    ///   - completion: Falls es einen Fehler gibt wird er hier zurückgegeben
   
    public func aktualisiereUserDaten(_ user: User, completion: @escaping(Error?) -> Void){
        self.service.updateUserData(to: user) { user, error in
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
