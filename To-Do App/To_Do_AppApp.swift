//
//  To_Do_AppApp.swift
//  To-Do App
//
//  Created by Uroš Katanić on 10.1.22..
//

import SwiftUI

@main
struct To_Do_AppApp: App {
    
    let contatiner = CoreDataMenager.shered.container
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext,contatiner.viewContext)
        }
    }
}
