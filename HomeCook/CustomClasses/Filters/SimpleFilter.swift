//
//  SimpleFilter.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 03/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class FilterViewOfSimpleType: UIView {
    let titleLabel = UILabel()
    let valueLabel: UITextField
    
    init(title: String, frame: CGRect) {
        self.titleLabel.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.height / 2))
        self.titleLabel.text = title
        self.valueLabel = UITextField(frame: CGRect(origin: CGPoint(x: 0, y: self.titleLabel.frame.maxY), size: self.titleLabel.frame.size))
        super.init(frame: frame)
        
        self.valueLabel.delegate = self
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterViewOfSimpleType: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
