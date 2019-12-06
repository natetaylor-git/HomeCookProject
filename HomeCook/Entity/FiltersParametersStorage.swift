//
//  LoadFiltersParameters.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 04/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol FilterParametersStorageProtocol {
    static var shared: FilterParametersStorage { get set }
    var collection: [String: FilterParameters] { get set }
}

class FilterParametersStorage: FilterParametersStorageProtocol {
    var collection: [String : FilterParameters]
    
    static var shared: FilterParametersStorage = {
        let object = FilterParametersStorage()
        return object
    }()
    
    private init() {
        let filter1 = FilterParameters(id: 0, name: "Maximum time", type: .oneValue)
        let filter2 = FilterParameters(id: 1, name: "Cuisine type", type: .manyValues)
        let filter3 = FilterParameters(id: 2, name: "Course type", type: .manyValues)
        self.collection = [filter1.name: filter1,
                            filter2.name: filter2,
                            filter3.name: filter3]
    }
}

extension FilterParametersStorage: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

class FilterParameters {
    var type: ParameterType
    var name: String
    var values: [ParameterValue]
    var id: Int
    private var current: ParameterValue
    
    init(id: Int, name: String, type: ParameterType) {
        self.id = id
        self.name = name
        self.type = type
        if self.type == .manyValues {
            let defaultValue = ParameterValue(id: 0, val: "All")
            self.values = [defaultValue]
            self.current = defaultValue
        } else {
            self.values = []
            self.current = ParameterValue(id: 0, val: "0")
        }
    }
    
    func isEmpty() -> Bool {
        if self.type == .oneValue && self.values.count == 0 {
            return true
        }
        
        if self.type == .manyValues && self.values.count <= 1 {
            return true
        }
        
        return false
    }
    
    func currentIsEqualTo(value: String) -> Bool {
        return self.current.val == value
    }
    
    func setCurrent(called name: String) {
        if self.type == .manyValues {
            for value in self.values {
                if value.val == name {
                    self.current = value
                    break
                }
            }
        } else {
            self.current = ParameterValue(id: 0, val: name) 
        }
    }
    
    func getCurrent() -> ParameterValue {
        return self.current
    }
}

enum ParameterType {
    case oneValue
    case manyValues
}

struct ParameterValue {
    let id: Int
    let val: String
}
