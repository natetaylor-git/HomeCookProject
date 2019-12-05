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
    let valueLabel = UITextField()
    let defaultText = "---"
    
    init(title: String, frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGreen.cgColor
        
        self.titleLabel.frame = CGRect(origin: .zero,
                                       size: CGSize(width: frame.width, height: frame.height / 2))
        self.titleLabel.text = title
        self.titleLabel.textAlignment = .center
        self.titleLabel.backgroundColor = .white
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        self.valueLabel.delegate = self
        self.valueLabel.frame = CGRect(origin: CGPoint(x: 0, y: self.titleLabel.frame.maxY),
                                       size: self.titleLabel.frame.size)
        self.valueLabel.textAlignment = .center
        self.valueLabel.backgroundColor = .lightGreen
        self.valueLabel.text = self.defaultText
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text == "" {
            textField.text = self.defaultText
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
            return true
        } else {
            return false
        }
    }
}
