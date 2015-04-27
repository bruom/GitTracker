//
//  Label.swift
//  
//
//  Created by Bruno Omella Mainieri on 4/27/15.
//
//

import Foundation
import CoreData

class Label: NSManagedObject {

    @NSManaged var desc: String
    @NSManaged var cor: String
    @NSManaged var umProjeto: NSSet

}
