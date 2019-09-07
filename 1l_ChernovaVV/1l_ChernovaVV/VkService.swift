import Foundation
import Alamofire
import SwiftyJSON

class VkService {
    let baseUrl = "https://api.vk.com"
    
    //метод для загрузки данных, в качестве аргументов получает токен, юзера, метод и поля
    func loadVkData(path: String, fields: String, completion: @escaping ([FriendVk]) -> Void) {
    
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
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let friendJSONs = json["response"]["items"].arrayValue
                let friends = friendJSONs.map {FriendVk($0)}
                //friends.forEach { friend in print(friend)}
                completion(friends)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func loadUserVkData(path: String, fields: String, user_id: Int, completion: @escaping ([UserVk]) -> Void) {
        
        let session = Session.instanse
        
        //параметры
        let parameters: Parameters = [
            "access_token": session.token,
            "user_id": user_id,
            "v": 5.95,
            "fields": fields,
            "extended": 1
        ]
        
        let url = baseUrl + path
        
        //делаем запрос
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let userJSONs = json["response"].arrayValue
                let user = userJSONs.map {UserVk($0)}
                //user.forEach { user1 in print(user)}
                completion(user)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func loadGroupVkJSON(path: String, fields: String, completion: @escaping ([GroupVk]) -> Void) {
        
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
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let groupJSONs = json["response"]["items"].arrayValue
                let groups = groupJSONs.map {GroupVk($0)}
                //groups.forEach { group in print(groups)}
                completion(groups)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
}
