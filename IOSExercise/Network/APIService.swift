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
    
struct PlanetResponce: Codable {
    let name: String
    // outros campos se quiser
}

struct SpeciesResponse: Codable {
    let name: String
    let url: String
    // outros campos se quiser
}



class APIService {
    static func fetchSpeciesName(from urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let species = try JSONDecoder().decode(Species.self, from: data)
                completion(species.name)
            } catch {
                print("Erro ao decodificar espécie: \(error)")
                completion(nil)
            }
        }.resume()
    }

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
    
    static func fetchPlanet(from url: String, completion: @escaping (Result<Planet, Error>) -> Void) {
        guard let planetURL = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 1003)))
            return
        }

        URLSession.shared.dataTask(with: planetURL) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 1004)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(Planet.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    static func fetchFilms(from urls: [String], completion: @escaping ([Film]) -> Void) {
        var films: [Film] = []
        let group = DispatchGroup()

        for urlString in urls {
            guard let filmURL = URL(string: urlString) else { continue }
            group.enter()

            URLSession.shared.dataTask(with: filmURL) { data, response, error in
                defer { group.leave() }
                if let data = data {
                    if let decoded = try? JSONDecoder().decode(Film.self, from: data) {
                        films.append(decoded)
                    }
                }
            }.resume()
        }

        group.notify(queue: .main) {
            completion(films)
        }
    }
    static func fetchPlanetURL(from urlString: String, completion: @escaping (Result<Planet, Error>) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1)))
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let planet = try JSONDecoder().decode(Planet.self, from: data)
                        completion(.success(planet))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
        
    static func fetchSpecies(from urlString: String, completion: @escaping (Result<Species, Error>) -> Void) {
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL da espécie é inválida."])))
                return
            }
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let species = try JSONDecoder().decode(Species.self, from: data)
                        DispatchQueue.main.async { // Voltar à main thread para o completion handler
                            completion(.success(species))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("Erro no decode da espécie: \(error)")
                            completion(.failure(error))
                        }
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
}
