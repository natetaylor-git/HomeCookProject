//
//  ImageScale.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 11/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

// MARK: - Extension for image scaling used at recipe details screen for better image representation
extension UIImageView {
    func findFitAspectInRect(_ rect: CGRect) -> CGRect {
        guard let image = self.image else {
            return self.frame
        }
        
        let actualSize = image.size
        let scale: CGFloat
        if actualSize.width >= actualSize.height {
            scale = rect.width / actualSize.width
        } else {
            scale = rect.height / actualSize.height
        }
        
        let size = CGSize(width: actualSize.width * scale, height: actualSize.height * scale)
        let x = (rect.width - size.width) / 2.0
        let y = (rect.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
