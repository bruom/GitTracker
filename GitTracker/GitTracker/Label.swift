//
//  Label.swift
//  GitTracker
//
//  Created by Andre Lucas Ota on 30/04/15.
//  Copyright (c) 2015 Omella, Ota e Hieda. All rights reserved.
//

import Foundation
import CoreData

class Label: NSManagedObject {

    @NSManaged var cor: String
    @NSManaged var desc: String
    @NSManaged var umProjeto: Projeto

}
