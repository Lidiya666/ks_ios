import Foundation
import Alamofire

class VkService {
    let baseUrl = "https://api.vk.com"
    
    //метод для загрузки данных, в качестве аргументов получает токен, юзера, метод и поля
    func loadVkData(path: String, fields: String) {
    
        let session = Session.instanse
        
        //параметры
        let parameters: Parameters = [
            "access_token": session.token,
            "user_id": session.userId,
            "v": 5.95,
            "fields": fields,
            "extended": 1
        ]
        
        let url = baseUrl + path
        
        //делаем запрос
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
//
//            do {
//                let users = try JSONDecoder().decode(ResponseRoot.self, from: data)
//                print("1")
//                print(users)
//            } catch {
//                print("2")
//                print(error)
//            }
//            let jsonString = String(data: data, encoding: .utf8)
//            print("JSON: \(jsonString)")
//        }
            let stud = try! JSONDecoder().decode(AnyDecodable.self, from: data).value as! [String: Any]
            print(stud)
        }
    }
}

public struct AnyDecodable: Decodable {
    public var value: Any
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        init?(stringValue: String) { self.stringValue = stringValue }
    }
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var result = [String: Any]()
            try container.allKeys.forEach { (key) throws in
                result[key.stringValue] = try container.decode(AnyDecodable.self, forKey: key).value
            }
            value = result
        } else if var container = try? decoder.unkeyedContainer() {
            var result = [Any]()
            while !container.isAtEnd {
                result.append(try container.decode(AnyDecodable.self).value)
            }
            value = result
        } else if let container = try? decoder.singleValueContainer() {
            if let intVal = try? container.decode(Int.self) {
                value = intVal
            } else if let doubleVal = try? container.decode(Double.self) {
                value = doubleVal
            } else if let boolVal = try? container.decode(Bool.self) {
                value = boolVal
            } else if let stringVal = try? container.decode(String.self) {
                value = stringVal
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
            }
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
        }
    }
}
