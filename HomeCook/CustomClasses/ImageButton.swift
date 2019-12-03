//
//  DetailedRecipeBuyButton.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 03/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ImageButton: UIButton {
    let buyImageView = UIImageView()
    private let colors: [UIColor] = [.black, .blue]
    private var currentColor: Int = 0
    
    init(frame: CGRect, imageName: String) {
        super.init(frame: frame)
        self.buyImageView.frame = self.bounds
        self.buyImageView.image = UIImage(named: imageName)
        let templateImage = self.buyImageView.image?.withRenderingMode(.alwaysTemplate)
        self.buyImageView.image = templateImage
        self.buyImageView.contentMode = .scaleAspectFit
        changeImageColor(with: .black)
        self.addSubview(buyImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeImageColor(with color: UIColor) {
        self.buyImageView.tintColor = color
    }
    
    func changeImageColor() {
        let index = abs(self.currentColor - 1)
        changeImageColor(with: self.colors[index])
        self.currentColor = index
    }
}
