//
//  Netwoking.swift
//  Pryaniky_Test
//
//  Created by Admin on 29.01.2021.
//  Copyright © 2021 DmitryChaschin. All rights reserved.
//

import UIKit

class NetworkManager {
    private let  urlString = "https://pryaniky.com/static/json/sample.json"
    
   func fetchData(completion: @escaping (PryanikyData) -> Void)  {
        guard  let url = URL(string: urlString) else { print("Error while create URL"); return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                let data = data,
                let elements = self.parseJSON(data) else { return }
            completion(elements)
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> PryanikyData? {
        let decoder = JSONDecoder()
        do {
            let pryanikiData = try decoder.decode(PryanikyData.self, from: data)
            return pryanikiData
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
        return nil
    }
    
}
