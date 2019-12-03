//
//  NetworkService.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 01/12/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

protocol NetworkServiceInputProtocol {
    func getData(at path: URL, completion: @escaping (Data?) -> Void)
}

/// Service for getting data from web using paths in url or string formats
class NetworkService: NetworkServiceInputProtocol {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getData(at path: URL, completion: @escaping (Data?) -> Void) {
        let dataTask = session.dataTask(with: path) { data, _, _ in
            completion(data)
        }
        dataTask.resume()
    }
}

