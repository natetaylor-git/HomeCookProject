//
//  CoreDataService.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import CoreData

protocol CoreDataServiceProtocol {
    func saveRecipes(_ recipesCollection: [Int : DetailedRecipeEntity])
    func loadRecipes(specificIds: Set<Int>, completion: @escaping ([Int: DetailedRecipeEntity]) -> Void)
    func deleteAllRecipes(completion: @escaping (Bool) -> Void)
}

extension CoreDataServiceProtocol {
    func loadRecipes(completion: @escaping ([Int: DetailedRecipeEntity]) -> Void) {
        return loadRecipes(specificIds: Set<Int>(), completion: completion)
    }
}

class CoreDataService: CoreDataServiceProtocol {
    private let stack = CoreDataStack.shared
    private let entityName = "Recipe"
    
    func loadRecipes(specificIds: Set<Int> = Set<Int>(), completion: @escaping ([Int: DetailedRecipeEntity]) -> Void) {
        stack.persistentContainer.performBackgroundTask { (readContext) in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
            let sorter: NSSortDescriptor = NSSortDescriptor(key: "id" , ascending: true)
            fetchRequest.sortDescriptors = [sorter]
            if specificIds.count > 0 {
                fetchRequest.predicate = NSPredicate(format: "id in %@", specificIds)
            }
            
            
            do {
                let result = try readContext.fetch(fetchRequest) as? [MORecipe]
                guard let recipeObjects = result else {
                    print("not MORecipe")
                    return
                }
                
                var recipesEntitiesCollection = [Int: DetailedRecipeEntity]()
                for recipeObject in recipeObjects {
                    var recipeIngredientsModelCollection = [IngredientModel]()
                    for recipeIngredient in recipeObject.recipeIngredients {
                        let amount = recipeIngredient.amount
                        let unit = recipeIngredient.unit
                        
                        let ingredient = recipeIngredient.ingredient
                        let name = ingredient.name
                        
                        let ingredientModel = IngredientModel(name: name,
                                                  amount: Int(amount),
                                                  unit: unit)
                        recipeIngredientsModelCollection.append(ingredientModel)
                    }
                    
                    let recipe = RecipeModel(id: Int(recipeObject.id),
                                             name: recipeObject.name,
                                             course: recipeObject.course,
                                             cuisine: recipeObject.cuisine,
                                             readyTimeMin: Int(recipeObject.minutes),
                                             instructions: recipeObject.instructions,
                                             ingredients: recipeIngredientsModelCollection)
                    let imageData = recipeObject.imageData
                    let recipeEntity = DetailedRecipeEntity(model: recipe, imageData: imageData)
                    recipesEntitiesCollection[recipeEntity.recipe.id] = recipeEntity
                }
                
                completion(recipesEntitiesCollection)
            } catch {
                print(error.localizedDescription)
                completion([:])
            }
        }
    }
    
    func deleteAllRecipes(completion: @escaping (Bool) -> Void) {
        stack.persistentContainer.performBackgroundTask { (deleteContext) in
            do {
                for entity in ["Recipe", "Ingredient", "RecipeIngredient"] {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                    try deleteContext.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest))
                    try deleteContext.save()
                }
                
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func ingredientExists(name: String, context: NSManagedObjectContext) -> MOIngredient? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Ingredient")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.first as? MOIngredient
    }
    
    func recipeExists(id: Int, context: NSManagedObjectContext) -> MORecipe? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipe")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.first as? MORecipe
    }
    
    func recipeChanged(localEntity: RecipeModel, localImageData: Data, loadedEntity: MORecipe) -> Bool {
        if localEntity.name == loadedEntity.name,
            localEntity.cousine == loadedEntity.cuisine,
            localEntity.course == loadedEntity.course,
            localEntity.instructions == loadedEntity.instructions,
            localImageData == loadedEntity.imageData {
            return false
        }
        return true
    }
    
    func deleteRecipe(loadedEntity: MORecipe, deleteContext: NSManagedObjectContext) {
            deleteContext.delete(loadedEntity)
    }
    
    func saveRecipes(_ recipesCollection: [Int : DetailedRecipeEntity]) {
        let localStorage = recipesCollection
        stack.persistentContainer.performBackgroundTask { (writeContext) in
            for localRecipe in localStorage {
                let recipeModel = localRecipe.value.recipe
                let imageData = localRecipe.value.recipeImageData
                
                if let recipeMO = self.recipeExists(id: recipeModel.id, context: writeContext) {
                    if self.recipeChanged(localEntity: recipeModel,
                                          localImageData: imageData,
                                          loadedEntity: recipeMO) {
                        self.deleteRecipe(loadedEntity: recipeMO,
                                          deleteContext: writeContext)
                    } else {
                        continue
                    }
                }
                
                let recipe = MORecipe(context: writeContext)

                recipe.id = Int32(recipeModel.id)
                recipe.name = recipeModel.name
                recipe.cuisine = recipeModel.cousine
                recipe.course = recipeModel.course
                recipe.instructions = recipeModel.instructions
                recipe.minutes = Int16(recipeModel.readyTimeMin)
                recipe.imageData = imageData

                recipe.recipeIngredients = Set<MORecipeIngredient>()
                for localIngredient in recipeModel.ingredients {
                    let recipeIngredient = MORecipeIngredient(context: writeContext)
                    
                    recipeIngredient.amount = Int16(localIngredient.amount)
                    recipeIngredient.unit = localIngredient.unit
                    
                    var ingredient: MOIngredient
                    if let existed = self.ingredientExists(name: localIngredient.name,
                                                              context: writeContext) {
                        ingredient = existed
                    } else {
                        let newIngredient = MOIngredient(context: writeContext)
                        newIngredient.name = localIngredient.name
                        ingredient = newIngredient
                    }
                    
                    recipeIngredient.ingredient = ingredient
                    recipe.recipeIngredients.insert(recipeIngredient)
                }
            }
            
            do {
                try writeContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

