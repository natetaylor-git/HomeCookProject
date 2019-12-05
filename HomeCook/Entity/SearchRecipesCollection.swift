//
//  SearchRecipes.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 04/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class RecipesCollection {
    private let queue = DispatchQueue(label: "com.cacheQueue", attributes: .concurrent)
    private var collection = [RecipeModel]()
    
    init(with collection: [RecipeModel] = []) {
        self.queue.async(flags: .barrier) {
            self.collection = collection
        }
    }
    
    public func append(_ element: RecipeModel) {
        self.queue.async(flags: .barrier) {
            self.collection.append(element)
        }
    }
    
    public func removeAll(){
        self.queue.async(flags: .barrier) {
            self.collection.removeAll()
        }
    }
    
    public var count: Int {
        var count = 0
        
        self.queue.sync {
            count = self.collection.count
        }
        
        return count
    }
    
    public subscript(index: Int) -> RecipeModel {
        get {
            var item = RecipeModel(RecipeDownloadModel(searchRequest: nil, id: -1, name: "", imagePath: "", course: "", cousine: "", readyTimeMin: 0, instructions: "", ingredients: []))
            self.queue.sync {
                item = self.collection[index]
            }
            return item
        }
        
        set (newModel) {
            queue.async(flags: .barrier) {
                self.collection[index] = newModel
            }
        }
    }
}
