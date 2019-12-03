//
//  LocalImages.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class LocalImagesCollection {
    static var shared: LocalImagesCollection = {
        let localImages = LocalImagesCollection()
        return localImages
    }()
    
    var imagesDict: [Int: UIImage]
    
    private init() {
        self.imagesDict = [Int: UIImage]()
    }
}

class ImagesCollection {
    var imagesDict: [Int: Data]
    
    init() {
        self.imagesDict = [Int: Data]()
    }
}
