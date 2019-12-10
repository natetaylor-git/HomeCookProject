//
//  UserDefaultsService.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 07/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    var historyKey: String { get }
    var boughtIngredientsKey: String { get }
    func saveSet<T>(set: Set<T>, key: String?) -> Bool
    func getSet<T>(key: String?) -> Set<T>?
    func clearAllCustomKeys()
    func checkStatusOfHintForBuyScreen() -> Bool
    func setHintStatusToNeeded()
    func setHintStatusToNotNeeded()
}

extension UserDefaultsServiceProtocol {
    func getSet<T>() -> Set<T>? {
        return getSet(key: nil)
    }
    
    func saveSet<T>(set: Set<T>) -> Bool {
        return saveSet(set: set, key: nil)
    }
}

class UserDefaultsService: UserDefaultsServiceProtocol {
    private var currentRecipesKey = "CurrentRecipesIds"
    var historyKey = "HistoryRecipesIds"
    var hintAtBuyScreenKey = "HintIsNeeded"
    var boughtIngredientsKey = "BoughtIngredients"
    
    func saveSet<T>(set: Set<T>, key: String? = nil) -> Bool {
        let actualKey = key ?? self.currentRecipesKey
        let data = try? NSKeyedArchiver.archivedData(withRootObject: set, requiringSecureCoding: false)
        if let data = data {
            UserDefaults.standard.set(data, forKey: actualKey)
            return true
        } else {
            return false
        }
    }
    
    func getSet<T>(key: String? = nil) -> Set<T>? {
        let actualKey = key ?? self.currentRecipesKey
        if let fetchedData = UserDefaults.standard.data(forKey: actualKey),
            let fetchedSet = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSSet.self,
                                                                     from: fetchedData),
            let set = fetchedSet as? Set<T> {
            return set
        } else {
            return nil
        }
    }
    
    func clearAllCustomKeys() {
        UserDefaults.standard.removeObject(forKey: self.currentRecipesKey)
        UserDefaults.standard.removeObject(forKey: self.historyKey)
        UserDefaults.standard.set(true, forKey: self.hintAtBuyScreenKey)
    }
    
    func checkStatusOfHintForBuyScreen() -> Bool {
        let status = UserDefaults.standard.bool(forKey: self.hintAtBuyScreenKey)
        return status
    }
    
    func setHintStatusToNotNeeded() {
        UserDefaults.standard.set(false, forKey: self.hintAtBuyScreenKey)
    }
    
    func setHintStatusToNeeded() {
        UserDefaults.standard.set(true, forKey: self.hintAtBuyScreenKey)
    }
}
