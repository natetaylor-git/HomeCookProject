//
//  BuyIngredientHeaderView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 09/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

protocol BuyIngredientHeaderDelegate: UITableViewDelegate {
    func changeVisibility(for section: Int, hide: Bool)
}

class BuyIngredientHeaderView: UIView {
    private var section: Int
    private var hideSection: Bool
    var gestureRecognizer: UITapGestureRecognizer?
    let textLabel = UILabel()
    weak var delegate: BuyIngredientHeaderDelegate?
    
    init(frame: CGRect, section: Int, text: String, hide: Bool) {
        self.section = section
        self.hideSection = hide
        super.init(frame: frame)
        
        self.backgroundColor = .darkGreen
        self.textLabel.font = UIFont.boldSystemFont(ofSize: 30)
        self.textLabel.textAlignment = .left
        self.textLabel.text = text
        self.textLabel.textColor = .white
        
        self.textLabel.frame = CGRect(origin: .zero, size: self.bounds.size)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedHeader))
        self.gestureRecognizer = gestureRecognizer
        self.gestureRecognizer?.numberOfTapsRequired = 2
        
        self.addSubview(textLabel)
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tappedHeader() {
        self.hideSection = !self.hideSection
        self.delegate?.changeVisibility(for: self.section, hide: self.hideSection)
    }
}
