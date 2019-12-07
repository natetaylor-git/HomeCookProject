//
//  BuyView.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 05/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {
    var presenter: BuyPresenterInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let data = try? NSKeyedArchiver.archivedData(withRootObject: set, requiringSecureCoding: false)
//        if let data = data {
//            UserDefaults.standard.set(data, forKey: "CurrentRecipesIds")
//        }
    
//        if let gotData = UserDefaults.standard.data(forKey: "CurrentRecipesIds"),
//            let gotSet = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSSet.self, from: gotData) {
//            print(gotSet)
//        }
        
        let a = UserDefaultsService()
        
        let set = Set<Int>([1])
        a.saveSet(set: set)
        
//        let s: Set<Int>? = a.getSet()
//        print(s)
    }
}

extension BuyViewController: BuyPresenterOutputProtocol {
    
}
