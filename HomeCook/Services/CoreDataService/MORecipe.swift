//
//  MORecipe.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import CoreData

@objc(MORecipe)
class MORecipe: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var name: String
    @NSManaged var cuisine: String
    @NSManaged var course: String
    @NSManaged var instructions: String
    @NSManaged var imageData: Data
    @NSManaged var minutes: Int16
    @NSManaged var recipeIngredients: Set<MORecipeIngredient>
}
