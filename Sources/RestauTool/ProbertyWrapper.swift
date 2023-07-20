//
//  ProbertyWraapper.swift
//  
//
//  Created by Paul Brendtner on 20.07.23.
//

import Foundation

@propertyWrapper
/// Ein Speicher
///
/// Verwendung:
///
///```swift
///struct MyData: Codable {
/// var name: String
/// var age: Int
///}
///
///struct MyViewModel {
/// @CodableStorage("myData.json")
/// var myData: MyData?
///}
///
///```
///
///Wichtig ist hierbei, dass deine klasse dem Codable-Protokoll entsoricht.
public struct Speicher<T> where T: Codable{
    private let filename: String
    
    public var wrappedValue: T? {
        get {
            return FileManager.loadObject(mitName: filename)
        }
        set {
            if let newValue = newValue {
                FileManager.saveObject(newValue, mitDemNamen: filename)
            } else {
                FileManager.deleteFile(mitDemNamen: filename)
            }
        }
    }
    
    
    /// Erstelle eine Variable, die gespeichert wird..
    /// - Parameter filename: Der Ort, wo die Datei gespeichert werden soll. Bitte <b>ohne</b> Dateiendung angeben
    public init(_ filename: String) {
        self.filename = "\(filename).json"
    }
}
