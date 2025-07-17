import Foundation

enum Endpoint: String {
    case characters = "people"
    case planets = "planets"
    case ships = "starships"
    
    func url(with id: Int? = nil) -> URL? {
        var path = "https://swapi.info/api/\(self.rawValue)"
        if let id = id {
            path += "/\(id)"
        }
        return URL(string: path)
    }
}
