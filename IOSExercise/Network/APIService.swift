import Foundation

struct CharacterResponse: Decodable {
    let results: [Character]
}

struct PlanetResponse: Decodable {
    let results: [Planet]
}

struct StarshipResponse: Decodable {
    let results: [Starship]
}

class APIService {
    static func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        guard let url = URL(string: "https://swapi.info/api/people") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1001)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 1002)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Character].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Erro no decode: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func fetchStarships(completion: @escaping (Result<[Starship], Error>) -> Void) {
        guard let url = URL(string: "https://swapi.info/api/starships") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1001)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 1002)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Starship].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Erro no decode: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    static func fetchPlanets(completion: @escaping (Result<[Planet], Error>) -> Void) {
        guard let url = URL(string: "https://swapi.info/api/planets") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1001)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 1002)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Planet].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Erro no decode: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}
