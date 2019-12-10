//
//  IngredientTableViewCell.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 08/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    var ingredient: IngredientView?
    
    override func prepareForReuse() {
        self.ingredient?.amountLabel.text = ""
        self.ingredient?.unitLabel.text = ""
        self.ingredient?.nameLabel.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }
    
    func setValues(name: String, amount: String, unit: String) {
        self.ingredient = IngredientView(frame: self.bounds)
        self.ingredient?.setup(frame: self.bounds, name: name, amount: amount, unit: unit)
        self.ingredient?.clipsToBounds = true
        self.contentView.addSubview(ingredient!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.ingredient?.changeLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
