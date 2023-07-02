//
//  RestauTool.swift
//  
//
//  Created by Paul Brendtner on 28.06.23.
//

import Foundation
import Firebase

@available(macOS 10.15, *)
public class RestauTool: ObservableObject{
    public var manager = RestauManager()
    public var auth = AuthModel()
    
    public init(){
        FirebaseApp.configure()
    }
}
