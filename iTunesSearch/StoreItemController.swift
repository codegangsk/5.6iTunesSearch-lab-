//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Sophie Kim on 2020/11/12.
//  Copyright © 2020 Caleb Hicks. All rights reserved.
//

import Foundation

class StoreItemController {
    func fetchItems(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {
        let baseURL = URL(string: "https://itunes.apple.com/search?")!
        
        guard let url = baseURL.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    print(String(decoding: jsonData, as: UTF8.self))
                } else {
                    print("json data malformed")
                }
            }
            
            guard let data = data,
                  let storeItems = try? JSONDecoder().decode(StoreItems.self, from: data)
            else {
                print("Either no data was returned, or data was not serialized.")
                completion(nil)
                return
            }

            completion(storeItems.results)
        }
        task.resume()
    }
}
