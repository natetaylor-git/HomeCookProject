//
//  DetailedRecipeBuyButton.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 03/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class ImageButton: UIButton {
    let customImageView = UIImageView()
    private let colors: [UIColor] = [.black, .blue]
    private var currentColor: Int = 0
    private var shadowMakeActive = false
    private var useShadowOption = false
    
    init(frame: CGRect, imageName: String, shadow: Bool = false) {
        super.init(frame: frame)
        self.customImageView.frame = self.bounds
        self.customImageView.image = UIImage(named: imageName)
        let templateImage = self.customImageView.image?.withRenderingMode(.alwaysTemplate)
        self.customImageView.image = templateImage
        self.customImageView.contentMode = .scaleAspectFit
        self.useShadowOption = shadow
        changeImageColor(with: .black)
        self.addSubview(customImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeImageColor(with color: UIColor) {
        self.customImageView.tintColor = color
    }
    
    private func changeShadow() {
        if self.shadowMakeActive {
            self.layer.shadowColor = self.colors[currentColor].cgColor
            self.layer.shadowOffset = .zero
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 5
        } else {
            self.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    func changeImageColor() {
        let index = abs(self.currentColor - 1)
        changeImageColor(with: self.colors[index])
        self.currentColor = index
        if self.useShadowOption {
            self.shadowMakeActive = !self.shadowMakeActive
            self.changeShadow()
        }
    }
}
