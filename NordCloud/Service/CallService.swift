//
//  CallService.swift
//  NordCloud
//
//  Created by Mikhail Danilov on 23.01.2022.
//

import Foundation
import UIKit

class CallService {

    static let Decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(NetworkDateFormatter())
        return jsonDecoder
    }()

    func getCalls(completion: @escaping (Calls?) -> Void) {
        let urlString = "https://5e3c202ef2cb300014391b5a.mockapi.io/testapi"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error")
                completion(nil)
                return
            }

            do {
                let calls = try CallService.Decoder.decode(Calls.self, from: data)
                completion(calls)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
}
