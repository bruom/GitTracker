//
//  Projeto.swift
//  
//
//  Created by Bruno Omella Mainieri on 4/27/15.
//
//

import Foundation
import CoreData

class Projeto: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var labels: NSSet

}
