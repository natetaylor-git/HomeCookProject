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

// MARK: - Extension for method with default values in arguments
extension CoreDataServiceProtocol {
    func loadRecipes(completion: @escaping ([Int: DetailedRecipeEntity]) -> Void) {
        return loadRecipes(specificIds: Set<Int>(), completion: completion)
    }
}

/// Service that allows to save recipes, load all or specisifc recipes and delete all recipes from coreData persistent store
class CoreDataService: CoreDataServiceProtocol {
    private let stack = CoreDataStack.shared
    private let entityName = "Recipe"
    
    /// Method that loads needed recipes specified by id
    ///
    /// - Parameters:
    ///   - specificIds: set consisted of ids of needed recipes
    ///   - completion: passes collection of recipe models based on retrieved MORecipe objects
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
    
    /// Method that allows to delete all recipes from persistent store, but ingredients still exist
    ///
    /// - Parameter completion: passes success status of delete opearation
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
    
    /// Method that checks if given ingredient already exists in persistent store
    ///
    /// - Parameters:
    ///   - name: ingredient name
    ///   - context: managed object context
    /// - Returns: returns found ingredient managed object or nil
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
    
    /// Method that checks if given recipe already exists in persistent store
    ///
    /// - Parameters:
    ///   - id: recipe id
    ///   - context: managed object context
    /// - Returns: returns found recipe managed object or nil
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
    
    
    /// Method that checks if given recipe model differs from recipe located at persistent store
    ///
    /// - Parameters:
    ///   - localEntity: recipe u want to check to find out if it needs to be resaved
    ///   - localImageData: recipe image data
    ///   - loadedEntity: entity loaded from persistent store ( ofthen with same id as local entity)
    /// - Returns: returns the result of comparison based on name, cousine, instructions and image data parameters
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
    
    /// Method that deletes given recipe managed object from presistent store
    ///
    /// - Parameters:
    ///   - loadedEntity: recipe to delete
    ///   - deleteContext: managed object context
    func deleteRecipe(loadedEntity: MORecipe, deleteContext: NSManagedObjectContext) {
            deleteContext.delete(loadedEntity)
    }
    
    /// Method that saves collection of recipes to persistent store also checking if there any
    /// recipes need to be updated
    ///
    /// - Parameter recipesCollection: collection of detailed recipes to be saved to persistent store
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
