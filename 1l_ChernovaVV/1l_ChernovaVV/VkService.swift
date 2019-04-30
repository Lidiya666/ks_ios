import Foundation
import Alamofire

class VkService {
    let baseUrl = "https://api.vk.com"
    
    //метод для загрузки данных, в качестве аргументов получает токен, юзера, метод и поля
    func loadVkData(access_token: String, user_id: String, path: String, fields: String) {
    
        //параметры
        let parameters: Parameters = [
            "access_token": access_token,
            "user_id": user_id,
            "v": 5.95,
            "fields": fields
        ]
        
        let url = baseUrl + path
        
        print(url)
        
        //делаем запрос
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            print(response.value)
        }
    }
}
