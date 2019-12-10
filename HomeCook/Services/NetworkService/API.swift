//
//  API.swift
//  HomeCook
//
//  Created by nate.taylor_macbook on 30/11/2019.
//  Copyright © 2019 natetaylor. All rights reserved.
//

import Foundation

class API {
    private static let baseUrl = "http://cousine.gbezyuk.ru:8098/api/graphql"
    private static let imageBaseUrl = "http://cousine.gbezyuk.ru:8098/media/"
    static let batchSize: Int = 5
    
    static func getImageUrl(relativePath: String) -> URL? {
        let url = URL(string: imageBaseUrl + relativePath)
        return url
    }
    
    static func getRecipeInfo(id: Int) -> URL {
        guard var components = URLComponents(string: baseUrl) else {
            return URL(string: baseUrl)!
        }
        let query = URLQueryItem(name: "query", value: "{recipe(id: \(id)) { name cousine{name} courseType{name} instructions readyInTime recipeIngridients{ amount unit{name} ingridient {name} }}}")
        
        components.queryItems = [query]
        
        return components.url!
    }
    
    static func getRecipes(searchString: String, offset: Int = 0, maxTime: Int = 0, cuisineId: Int = 0, courseTypeId: Int = 0) -> URL {
        guard var components = URLComponents(string: baseUrl) else {
            return URL(string: baseUrl)!
        }
        let amount = batchSize
        let query = URLQueryItem(name: "query", value: "{recipes(searchTerm: \"\(searchString)\", offset: \(offset), first: \(amount), cousineId: \(cuisineId), courseTypeId: \(courseTypeId), readyInTimeMax: \(maxTime)) {id name cousine{name}  courseType{name} instructions readyInTime ingridients{name} image}}")
        
        components.queryItems = [query]
        
        return components.url!
    }
    
    static func getCuisineFilterValues(amount: Int = 100) -> URL {
        guard var components = URLComponents(string: baseUrl) else {
            return URL(string: baseUrl)!
        }
        let query = URLQueryItem(name: "query", value: "{cousines(first: \(amount)) { id name }}")
        components.queryItems = [query]
        
        return components.url!
    }
    
    static func getCourseFilterValues(amount: Int = 100) -> URL {
        guard var components = URLComponents(string: baseUrl) else {
            return URL(string: baseUrl)!
        }
        let query = URLQueryItem(name: "query", value: "{courseTypes(first: \(amount)) { id name }}")
        components.queryItems = [query]
        
        return components.url!
    }
}
