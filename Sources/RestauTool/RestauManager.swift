//
//  RestauManager.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Foundation
import Firebase
import FirebaseFirestore

@available(macOS 10.15, *)
public class RestauManager: ObservableObject{
    @Published public var tische = [Tisch]()
    private let tischService = TischService()
    
    public init(){
        self.ladeAlleTische()
    }
    
    
    public func ladeAlleTische(){
        tischService.fetchTables { tische in
            self.tische = tische
        }
    }
    
    public func ladeTischeHoch(_ tische: [Tisch]){
        tischService.uploadTables(tische) { tische in
            self.tische = tische
        }
    }
}
