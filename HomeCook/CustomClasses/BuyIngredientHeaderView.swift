//
//  BuyIngredientHeaderView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 09/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol BuyIngredientHeaderDelegate: UITableViewDelegate {
    func changeVisibility(for section: Int, to alpha: CGFloat)
}

class BuyIngredientHeaderView: UIView {
    private var section: Int
    private var alphaOfCellsInSection: CGFloat = 1.0
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedHeader))
    let textLabel = UILabel()
    weak var delegate: BuyIngredientHeaderDelegate?
    
    init(frame: CGRect, section: Int, text: String) {
        self.section = section
        super.init(frame: frame)
        
        self.textLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.textLabel.textAlignment = .left
        self.textLabel.text = text
        self.gestureRecognizer.numberOfTapsRequired = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedHeader() {
        self.alphaOfCellsInSection = abs(1 - self.alphaOfCellsInSection)
        self.delegate?.changeVisibility(for: self.section, to: self.alphaOfCellsInSection)
    }
}
