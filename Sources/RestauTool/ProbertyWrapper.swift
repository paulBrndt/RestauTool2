//
//  ProbertyWraapper.swift
//  
//
//  Created by Paul Brendtner on 20.07.23.
//

import Foundation
import SwiftUI

protocol DynamicProperty {
    associatedtype Value
    var wrappedValue: Value { get set }
    var projectedValue: Binding<Value> { get }
}


// Protokoll, um Binding aus dem Property Wrapper zu erhalten
protocol BindingProtocol: DynamicProperty {
    var binding: Binding<Value> { get }
}

// Property Wrapper, der generischen Typ T speichert und als Binding verwendet werden kann
@propertyWrapper
public struct Bindable<T>: BindingProtocol, Identifiable, Equatable, Hashable where T: Codable & Equatable & Hashable{
    @State private var value: T
    private let filename: String
    public let id = UUID()

    public var wrappedValue: T {
        get { value }
        nonmutating set {
            value = newValue
            saveDataToFile() // Speichern des Werts in der Datei, wenn sich der Wert ändert
        }
    }

    public var projectedValue: Binding<T> {
        $value
    }

    public var binding: Binding<T> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }

    public init(wrappedValue: T,_ dateiname: String) {
        self._value = State(wrappedValue: wrappedValue)
        self.filename = dateiname
        loadDataFromFile() // Laden des Werts aus der Datei beim Initialisieren
    }

    // Dateipfad für die Speicherung des Wertes
    private var dataFilePath: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("\(filename).plist")
    }

    // Speichern des Werts in der Datei
    private func saveDataToFile() {
        do {
            let data = try PropertyListEncoder().encode(wrappedValue)
            try data.write(to: dataFilePath)
        } catch {
            print("Error saving data to file: \(error)")
        }
    }

    // Laden des Werts aus der Datei
    private func loadDataFromFile() {
        do {
            let data = try Data(contentsOf: dataFilePath)
            wrappedValue = try PropertyListDecoder().decode(T.self, from: data)
        } catch {
            print("Error loading data from file: \(error)")
        }
    }
}


public extension Bindable {
    static func == (lhs: Bindable<T>, rhs: Bindable<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}

