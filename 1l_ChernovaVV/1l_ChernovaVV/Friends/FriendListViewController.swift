//
//  FriendListViewController.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 08/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct FriendVk {
    let city: String
    let first_name: String
    let id: Int
    let last_name: String
    //let online: Int
    let photo_100: String
    
    init(_ json: JSON) {
        self.city = json["city"]["title"].stringValue
        self.first_name = json["first_name"].stringValue
        self.id = json["id"].intValue
        self.last_name = json["last_name"].stringValue
       // self.online = json["online"].intValue
        self.photo_100 = json["photo_100"].stringValue
    }
    
}

class FriendListViewController: UIViewController {
    
    var fFriendsVk = [FriendVk]()
    var filterFriendsVk = [FriendVk]()
    
    var sectionNameVk = [String]()
    
    struct ObjectsVk {
        
        var sectionNameVk : String!
        var sectionObjectsVk : [FriendVk]!
    }
    
    var friendsVk = [String:[FriendVk]]()
    
    var objectArrayVk = [ObjectsVk]()
    
    let searchController = UISearchController (searchResultsController: nil )
    
    var friendVk = [FriendVk]() //запрос данных из json
    let getFriend = VkService()
    
    @IBOutlet weak var friendListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendListView.dataSource = self
        friendListView.delegate = self
        
        /////запрос друзей
        getFriend.loadVkData(path: "/method/friends.get", fields: "city,photo_100") { [weak self] friendVk in
            self?.friendVk = friendVk
            
            friendVk.forEach { friend in
                let key = String(describing: friend.last_name[friend.last_name.startIndex])
                
                guard (self?.friendsVk[key]) != nil else { self?.friendsVk[key] = [friend]; return }
                self?.friendsVk[key]?.append(friend)
            }
            
            for (key, value) in self!.friendsVk {
                self!.objectArrayVk.append(ObjectsVk(sectionNameVk: key, sectionObjectsVk: value))
            }
            
            self?.objectArrayVk = self!.objectArrayVk.sorted {$0.sectionNameVk < $1.sectionNameVk}
            
            for key in (self?.friendsVk.keys)! {
                self!.sectionNameVk.append(key)
                
                guard let data = self!.friendsVk[key] else { continue }
                
                for value in data {
                    self!.fFriendsVk.append(value)
                }
            }
            
            self?.friendListView.reloadData()
        }
        
        self.navigationController?.delegate = self
        self.friendListView.tableFooterView = UIView.init()
        
        // Настройка контроллера поиска
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Friends"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // если идентификатор segue равно "detailSegue"
        if segue.identifier == "detailSegue" {
            // создаем  dvc, которая будет равна контроллеру на который мы переходим с помощью segue
            //который обязательно будет типа  SegueViewController
           if let indexPath = friendListView.indexPathForSelectedRow {
                let dvc = segue.destination as! PhotoFriendViewController
                // теперь ты имеешь доступ к переменным в этом контроллере
                // и только те переменные которые ты тут передашь перейдут с тобой в новый контроллер
                if isFiltering() {
                    dvc.friendId = filterFriendsVk[indexPath.row].id
                } else {
                    dvc.friendId = objectArrayVk[indexPath.section].sectionObjectsVk[indexPath.row].id
                }
            }
            
        }
    }

}

extension FriendListViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard operation == .push else { return AnimatedTransitioningForPop() }
        return AnimatedTransitioningForPush()

    }

}


extension FriendListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering(){
            return 1
        } else {
            return objectArrayVk.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filterFriendsVk.count
        } else {
            return objectArrayVk[section].sectionObjectsVk.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendListTableViewCell
        
        if isFiltering() {
            let friendVks = filterFriendsVk[indexPath.row]
            cell.configure(with: friendVks) ///почему нельзя вынести из условия?
        } else {
            let friendVks = objectArrayVk[indexPath.section].sectionObjectsVk[indexPath.row]
            cell.configure(with: friendVks)
        }
        
        //cell.configure(with: friendVks)???
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                           titleForHeaderInSection section: Int) -> String?{
        if isFiltering() {
            return nil
        } else {
            return objectArrayVk[section].sectionNameVk
        }
    }
}

extension FriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "TableViewHeaderFriends")
            return header
    }
}

extension FriendListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
       filterFriendsVk = fFriendsVk.filter({( friend : FriendVk) -> Bool in
            return ("\(friend.first_name.lowercased()) \(friend.last_name.lowercased())").contains(searchText.lowercased())
        })
        
        friendListView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
