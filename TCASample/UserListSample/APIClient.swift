//
//  APIClient.swift
//  TCASample
//
//  Created by パク on 2023/04/15.
//

import Foundation
import ComposableArchitecture

struct APIClient {

    static func fetchUsers() -> EffectPublisher<[User], Error> {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return EffectPublisher(error: URLError(.badURL))
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [User].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    }
}
