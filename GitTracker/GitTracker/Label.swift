//
//  Label.swift
//  GitTracker
//
//  Created by Bruno Omella Mainieri on 4/27/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import Foundation
import CoreData

class Label: NSManagedObject {

    @NSManaged var desc: String
    @NSManaged var cor: String
    @NSManaged var umProjeto: NSSet

}
