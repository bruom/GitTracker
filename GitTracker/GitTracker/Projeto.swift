//
//  Projeto.swift
//  GitTracker
//
//  Created by Bruno Omella Mainieri on 5/1/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import Foundation
import CoreData

class Projeto: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var user: String
    @NSManaged var lastUpdate: String
    @NSManaged var labels: NSSet

    func addLabel(newLabel:Label){
        var auxLabels:NSMutableSet = labels as! NSMutableSet
        auxLabels.addObject(newLabel)
        self.labels = NSSet(set: auxLabels)
    }
    
}
