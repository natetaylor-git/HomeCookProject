//
//  RecipeDetailedPresenter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class RecipeDetailsPresenter: RecipeDetailsInteractorOutputProtocol {
    var interactor: RecipeDetailsInteractorInputProtocol?
    weak var view: RecipeDetailsPresenterOutputProtocol?
    
    func prepareInfo(about recipeObject: DetailedRecipeEntity) {
        let imageData = recipeObject.recipeImageData
        let recipeInfo = recipeObject.recipe
        
        if let image = UIImage(data: imageData) {
            self.view?.setupImageView(with: image)
        }
        
        let stringMinutes = String(recipeInfo.readyTimeMin)
        let instructions = String(recipeInfo.instructions)
//        let test = "sddasdasdasd asd asd asd as fasdfsdfas adsf asdf asd fagalgsjadj fsja lasdg jasldgkja;sldkj g;alsdj gl;asjdgklsadjg jkljw wej lkjq;t jtql lllll o ooooo aasaaaaa"
        let infoForView = [(name: "Name", value: recipeInfo.name),
                           (name: "Course", value: recipeInfo.course),
                           (name: "Cuisine", value: recipeInfo.cousine),
                           (name: "Time in minutes", value: stringMinutes),
                           (name: "Instructions", value: recipeInfo.instructions)]
        
        self.view?.setupDetailsViews(with: infoForView)
    }
    
    func updateUIForEntityExistedInLocalStorage() {
        self.view?.activateUIElementsForEntityExistance()
    }
    
}

extension RecipeDetailsPresenter: RecipeDetailsPresenterInputProtocol {
    func viewLoaded() {
        self.interactor?.getRecipeInfo()
        self.interactor?.checkExistanceOfRecipeEntity()
    }
    
    func buyButtonActive() {
        self.interactor?.addRecipeToLocalStorage()
    }
    
    func buyButtonNotActive() {
        self.interactor?.deleteRecipeFromLocalStorageIfExists()
    }
}
