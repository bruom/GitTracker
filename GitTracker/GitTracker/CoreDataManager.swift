//
//  CoreDataManager.swift
//  GitTracker
//
//  Created by Bruno Omella Mainieri on 4/27/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    private override init(){
    }
    
    var context: NSManagedObjectContext!
    
    func fetchDataForEntity(entity:String, predicate:NSPredicate) -> NSArray {
        let request: NSFetchRequest = NSFetchRequest(entityName: entity)
        request.predicate = predicate
        
        let error: NSErrorPointer = NSErrorPointer()
        
        let resultSet: NSArray = self.context.executeFetchRequest(request, error: error)!
        
        //tratar erro
        if error != nil {
            println("Ocorreu um erro na persistencia. kawai halp")
        }
        
        return resultSet
    }
    
    func saveContext () {
        if let moc = context {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
}
