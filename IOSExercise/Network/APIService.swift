import Foundation

class APIService {

    static let shared = APIService()
    private init() {}

    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        guard let url = Endpoint.characters.url() else {
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
                let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
