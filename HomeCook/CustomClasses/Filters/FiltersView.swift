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
    let dropFilterHeight: CGFloat = 200
    let simpleFilterHeight: CGFloat = 100
    
    func setup(filtersData: [(name: String, values: [String])], frame: CGRect) {
        self.frame = frame
        self.bounces = false
        self.showsVerticalScrollIndicator = false
        
        titleLabel.frame = CGRect(origin: .zero,
                                  size: CGSize(width: frame.width, height: frame.height / 10))
        titleLabel.text = "Filters"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.backgroundColor = .red
        
        let paddingAfterTitleLabel: CGFloat = 20
        let paddingBetweenFilters: CGFloat = 10
        let baseHeight = titleLabel.frame.maxY + paddingAfterTitleLabel
        let filterWidth = self.frame.width
        
        var lastFilterMaxY: CGFloat = baseHeight
        for filterData in filtersData {
            let origin = CGPoint(x: 0, y: lastFilterMaxY)
            if filterData.values.count != 0 {
                let filterSize = CGSize(width: filterWidth, height: self.dropFilterHeight)
                let dropFilter = FilterViewOfDropType(title: filterData.name,
                                                      frame: CGRect(origin: origin, size: filterSize),
                                                      values: filterData.values)
                dropFilter.backgroundColor = .yellow
                self.dropFilters.append(dropFilter)
                self.addSubview(dropFilter)
                
                lastFilterMaxY = dropFilter.frame.maxY + paddingBetweenFilters
            } else {
                let filterSize = CGSize(width: filterWidth, height: self.simpleFilterHeight)
                let simpleFilter = FilterViewOfSimpleType(title: filterData.name,
                                                          frame: CGRect(origin: origin, size: filterSize))
                simpleFilter.backgroundColor = .green
                self.simpleFilters.append(simpleFilter)
                self.addSubview(simpleFilter)
                
                lastFilterMaxY = simpleFilter.frame.maxY + paddingBetweenFilters
            }
        }
        
        self.contentSize = CGSize(width: self.frame.width, height: lastFilterMaxY)
        self.backgroundColor = .blue
        self.addSubview(titleLabel)
    }
}
