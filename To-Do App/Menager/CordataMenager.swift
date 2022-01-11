//
//  CordataMenager.swift
//  To-Do App
//
//  Created by Uroš Katanić on 10.1.22..
//

import Foundation
import CoreData



class CoreDataMenager{
    let container : NSPersistentContainer
    static let shered: CoreDataMenager = CoreDataMenager()
    
    private init(){
        
        container = NSPersistentContainer(name: "SimpleTodoModel")
        container.loadPersistentStores{ description, error in
            if let error = error {
                fatalError("Unable to initalize coreData\(error)")
            }
            
        }
    }
    
}
