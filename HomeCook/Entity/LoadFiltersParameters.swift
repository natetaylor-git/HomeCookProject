//
//  LoadFiltersParameters.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 04/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class FilterParameters {
    var name: String
    var values: [String]
    
    init(name: String, values: [String]) {
        self.name = name
        self.values = values
    }
}
