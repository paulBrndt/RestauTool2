//
//  ProbertyWraapper.swift
//  
//
//  Created by Paul Brendtner on 20.07.23.
//

import Foundation
import SwiftUI



@propertyWrapper
public struct CodableSpeicher<T> where T: Codable{
    private let filename: String
    public var wrappedValue: T?{
        get {
            return FileManager.loadObject(mitName: filename)
        }
        nonmutating set {
            if let newValue = newValue{
                FileManager.saveObject(newValue, mitDemNamen: filename)
            } else {
                FileManager.deleteFile(mitDemNamen: filename)
            }
        }
    }
    
    
    public var projectedValue: Binding<T?>{
        Binding<T?>(
            get: {self.wrappedValue},
            set: {self.wrappedValue = $0}
        )
    }
    
    
    public init(_ filename: String) {
        self.filename = filename
    }
}


@propertyWrapper
public struct FirebaseTable{
    public var wrappedValue: [Tisch]?{
        get {
            return self.fetchTables()
        }
        nonmutating set {
            if let newValue = newValue {
                self.uploadTables(newValue)
            }
        }
    }
    
    
    public var projectedValue: Binding<[Tisch]?> {
           Binding<[Tisch]?>(
               get: { self.wrappedValue },
               set: { self.wrappedValue = $0 }
           )
       }
    
    private func uploadTables(_ tische: [Tisch]){
        let service = TischService()
        service.uploadTables(tische) { _ in }
    }
    
    private func fetchTables() -> [Tisch]{
        var tables: [Tisch] = []
        let service = TischService()
        service.fetchTables{ tische in
            tables = tische
        }
        return tables
    }
    
    public init() {}
}



// WEAK
