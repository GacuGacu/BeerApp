//
//  DataController.swift
//  Beer
//
//  Created by Kacper Domagała on 01/10/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Model")
    
    init(){
        container.loadPersistentStores{ description, error in
            if let error = error {
                print("Load failed \(error.localizedDescription)")
            }
        }
    }
}
