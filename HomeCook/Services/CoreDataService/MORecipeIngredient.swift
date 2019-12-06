//
//  MORecipeIngredient.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import CoreData

@objc(MORecipeIngredient)
class MORecipeIngredient: NSManagedObject {
    @NSManaged var amount: Int16
    @NSManaged var unit: String
    @NSManaged var ingredient: MOIngredient
}
