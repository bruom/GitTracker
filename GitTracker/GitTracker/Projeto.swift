//
//  Projeto.swift
//  GitTracker
//
//  Created by Bruno Omella Mainieri on 4/27/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import Foundation
import CoreData

class Projeto: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var labels: NSSet

}
