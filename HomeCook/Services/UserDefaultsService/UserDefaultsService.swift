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
    func resetAllCustomKeys()
    func checkStatusOfHintForBuyScreen() -> Bool
    func setHintStatusToNeeded()
    func setHintStatusToNotNeeded()
}

// MARK: - Extension for methods with default values in arguments
extension UserDefaultsServiceProtocol {
    func getSet<T>() -> Set<T>? {
        return getSet(key: nil)
    }
    
    func saveSet<T>(set: Set<T>) -> Bool {
        return saveSet(set: set, key: nil)
    }
}

/// Service that allows to interact with UserDefaults class (defaults system)
class UserDefaultsService: UserDefaultsServiceProtocol {
    /// Most used keys
    private var currentRecipesKey = "CurrentRecipesIds"
    var historyKey = "HistoryRecipesIds"
    var hintAtBuyScreenKey = "HintIsNeeded"
    var boughtIngredientsKey = "BoughtIngredients"
    
    /// Method that saves a set of values (type T) by UserDefaults for given key
    ///
    /// - Parameters:
    ///   - set: set to be saved
    ///   - key: key for set of values (default is currentRecipesKey)
    /// - Returns: returns success status
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
    
    /// Method that returns a set of values (type T) by UserDefaults for given key
    ///
    /// - Parameter key: key for set of values (default is currentRecipesKey)
    /// - Returns: set of values got by userDefaults for given key
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
    
    /// Method that is used to reset values for currentRecipesKey, historyKey and hintAtBuyScreenKey
    func resetAllCustomKeys() {
        UserDefaults.standard.removeObject(forKey: self.currentRecipesKey)
        UserDefaults.standard.removeObject(forKey: self.historyKey)
        UserDefaults.standard.set(true, forKey: self.hintAtBuyScreenKey)
    }
    
    /// Method that returns value for hintAtBuyScreenKey
    ///
    /// - Returns: true if hint is needed, false if hint is not needed anymore
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
