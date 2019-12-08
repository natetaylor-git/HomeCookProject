//
//  FilterView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 03/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class FiltersView: UIScrollView {
    let titleLabel = UILabel()
    var dropFilters = [FilterViewOfDropType]()
    var simpleFilters = [FilterViewOfSimpleType]()
    
    let titleLabelHeight: CGFloat = 50
    let dropFilterHeight: CGFloat = 100
    let simpleFilterHeight: CGFloat = 80
    
    let paddingAfterTitleLabel: CGFloat = 20
    let paddingBetweenFilters: CGFloat = 20
    let paddingBottom: CGFloat = 10
    
    func setup(filtersData: [(name: String, values: [String], current: String)], frame: CGRect) {
        self.frame = frame
        self.bounces = false
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
//        addBottomBorder()
        
        titleLabel.frame = CGRect(origin: self.bounds.origin,
                                  size: CGSize(width: frame.width, height: titleLabelHeight))
        titleLabel.text = "Filters"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.backgroundColor = .white
        
        self.addSubview(titleLabel)
   
        let baseHeight = titleLabel.frame.maxY + paddingAfterTitleLabel
        let filterWidth = self.frame.width
        
        var lastFilterMaxY: CGFloat = baseHeight
        for filterData in filtersData {
            let origin = CGPoint(x: 0, y: lastFilterMaxY)
            if filterData.values.count != 0 {
                let filterSize = CGSize(width: filterWidth, height: self.dropFilterHeight)
                let dropFilter = FilterViewOfDropType(title: filterData.name,
                                                      frame: CGRect(origin: origin, size: filterSize),
                                                      values: filterData.values,
                                                      current: filterData.current)
                dropFilter.extraDeltaForBeauty = self.paddingBottom
                self.dropFilters.append(dropFilter)
                self.addSubview(dropFilter)
                
                lastFilterMaxY = dropFilter.frame.maxY + paddingBetweenFilters
            } else {
                let filterSize = CGSize(width: filterWidth, height: self.simpleFilterHeight)
                let simpleFilter = FilterViewOfSimpleType(title: filterData.name,
                                                          frame: CGRect(origin: origin, size: filterSize),
                                                          current: filterData.current)
                self.simpleFilters.append(simpleFilter)
                self.addSubview(simpleFilter)
                
                lastFilterMaxY = simpleFilter.frame.maxY + paddingBetweenFilters
            }
        }
        
        self.contentSize = CGSize(width: self.frame.width,
                                  height: lastFilterMaxY - paddingBetweenFilters + paddingBottom)
    }
    
//    func addBottomBorder() {
//        let bottomLine = CALayer()
//        let borderWidth: CGFloat = 5
//        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.height - borderWidth),
//                                  size: CGSize(width: self.frame.width, height: borderWidth))
//        bottomLine.backgroundColor = UIColor.groupTableViewBackground.cgColor
//        self.layer.addSublayer(bottomLine)
//    }
}
