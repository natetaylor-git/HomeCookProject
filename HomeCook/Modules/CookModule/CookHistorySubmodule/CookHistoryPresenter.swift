//
//  CookHistoryPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class CookHistoryPresenter: CookHistoryInteractorOutputProtocol {
    var interactor: CookHistoryInteractorInputProtocol?
    weak var view: CookHistoryPresenterOutputProtocol?
    
    func takeHistory(_ models: [DetailedRecipeEntity]) {
        if models.count > 0 {
            var historyRecipeCellModels = Dictionary<String, [RecipeCellModel]>()
            var cellModels = [(String, [RecipeCellModel])]()
            
            for model in models {
                let image = UIImage(data: model.recipeImageData)
                let cellModel = RecipeCellModel(id: model.recipe.id,
                                                name: model.recipe.name,
                                                image: image)
                if var course = historyRecipeCellModels[model.recipe.course] {
                    course.append(cellModel)
                    historyRecipeCellModels[model.recipe.course] = course
                } else {
                    historyRecipeCellModels[model.recipe.course] = [cellModel]
                }
            }
            
            let sorted = historyRecipeCellModels.sorted{ $0.0 < $1.0 }
            for (course, courseCellModels) in sorted {
                cellModels.append((course, courseCellModels))
            }
            
            DispatchQueue.main.async {
                self.view?.showHistory(cellModels)
            }
        }
    }
    
    func takeRecipeInfo(_ entity: DetailedRecipeEntity) {
        self.view?.callCompletion(with: entity)
    }
}

extension CookHistoryPresenter: CookHistoryPresenterInputProtocol {
    func viewLoaded() {
        self.interactor?.getHistory()
    }
    
    func clickedOnRecipe(id: Int) {
        self.interactor?.getDetailedRecipe(id: id)
    }
}
