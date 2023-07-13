//
//  SaveLogic.swift
//  
//
//  Created by Paul Brendtner on 12.07.23.
//

import Foundation
public extension FileManager {
    static var documentDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    @discardableResult
    static func generateUniqueFilename() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let timestamp = formatter.string(from: Date())
        return "Objekt_\(timestamp).json"
    }
    
    @discardableResult
    /// Eine Funktion, die eine beliebige Klasse, die dem Codable Protokolls entspricht, speichern kann.
    /// - Parameters:
    ///   - object: Das Object, welches du speichern möchtest
    ///   - name: Der Name, wo du die Datei speichern möchtest. Er muss mit ".json" enden.
    /// - Returns: Der Name, wo die Datei gespeichert wurde. Wenn du die ``loadObject`` Funktion aufrufst, musst du als "mitName" diesen Wert eingeben
    static func saveObject<T: Codable>(_ object: T, mitDemNamen name: String?) -> String? {
        let uniqueFilename = generateUniqueFilename()
        let filename = name ?? uniqueFilename
        let fileURL = FileManager.documentDirectoryURL.appendingPathComponent(filename)
        
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: fileURL)
            return name ?? uniqueFilename
        } catch {
            print("Fehler beim Speichern des Objekts: \(error)")
            return nil
        }
    }
    
    @discardableResult
    /// Eine Funktion, die alle gesicherten Daten aus einer Datei aufrufen kann.
    /// - Parameter filename: Der Name der Datei, die aufgerufen werden soll. Sie ist der Return der ``saveObject``Funktion
    /// - Returns: Das Dokument das geladen wurde als angegebene Klasse. Die Klasse muss dem ``Codable``Protokoll entsprechen...
    static func loadObject<T: Codable>(mitName filename: String) -> T? {
        let fileURL = FileManager.documentDirectoryURL.appendingPathComponent(filename)
        
        do {
            let data = try Data(contentsOf: fileURL)
            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Fehler beim Laden des Objekts: \(error)")
            return nil
        }
    }
}
