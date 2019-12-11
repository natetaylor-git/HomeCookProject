//
//  LocalImages.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

/// Collection of images that is used to cache downloaded images during recipe search process
class ImagesCollection {
    var imagesDict: [Int: Data]
    
    init() {
        self.imagesDict = [Int: Data]()
    }
}
