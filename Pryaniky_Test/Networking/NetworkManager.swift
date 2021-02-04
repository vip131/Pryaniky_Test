//
//  NetworkManager.swift
//  Pryaniky_Test
//
//  Created by Admin on 31.01.2021.
//  Copyright © 2021 DmitryChaschin. All rights reserved.
//

import Foundation

protocol UIUpdateProtocol {
    func updateUI(_ networkManager : NetworkManager, data: PryanikyData)
}


class NetworkManager {
    private let urlString = "https://pryaniky.com/static/json/sample.json"
    var delegate : UIUpdateProtocol?
    func fetchData()  {
        guard  let url = URL(string: urlString) else { print("Error"); return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {  (data, response, error) in
            if error != nil {
                print("\(error!.localizedDescription)")
                return }
                if let safeData = data {
              if let model = self.parseJSON(safeData) {
            self.delegate?.updateUI(self, data: model)
                    }
        }
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
