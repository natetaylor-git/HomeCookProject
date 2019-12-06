//
//  MOIngredient.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import CoreData

@objc(MOIngredient)
class MOIngredient: NSManagedObject {
    @NSManaged var name: String
}
