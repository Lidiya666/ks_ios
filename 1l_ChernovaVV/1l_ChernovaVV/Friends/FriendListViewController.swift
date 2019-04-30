//
//  FriendListViewController.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 08/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit

struct Friend {
    let image: String
    let name: String
}

class FriendListViewController: UIViewController {
    
    var friends = ["А": [Friend(image: "01", name: "Иван Андреич")],
                   "Б": [Friend(image: "02", name: "Ульяна Байбак"),
                         Friend(image: "03", name: "Злобный Боря")],
                   "Г": [Friend(image: "04", name: "Макс Голодный")],
                   "Д": [Friend(image: "05", name: "Аня Джулай")]]
    
    var filterFriends = [Friend]()
    var fFriends = [Friend]()
    
    var sectionName = [String]()
    
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [Friend]!
    }
    
    var objectArray = [Objects]()
    
    let searchController = UISearchController (searchResultsController: nil )
    
    @IBOutlet weak var friendListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendListView.dataSource = self
        friendListView.delegate = self
        
        let session = Session.instanse
        print(session.token)
        
        
        self.navigationController?.delegate = self

        
        self.friendListView.tableFooterView = UIView.init()
        
        for (key, value) in friends {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        objectArray = objectArray.sorted {$0.sectionName < $1.sectionName}
        
        for key in friends.keys {
            sectionName.append(key)
            
            guard let data = friends[key] else { continue }
            
            for value in data {
                fFriends.append(value)
            }
        }
        
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
                // и только те переменные которые ты тут передашь перейду с тобой в новый контроллер
                if isFiltering() {
                    dvc.friendNames = [filterFriends[indexPath.row].name]
                } else {
                    dvc.friendNames = [objectArray[indexPath.section].sectionObjects[indexPath.row].name]
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
            return objectArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filterFriends.count
        } else {
            return objectArray[section].sectionObjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendListTableViewCell
        
        if isFiltering() {
            cell.FriendName.text = filterFriends[indexPath.row].name
            cell.photoFriendMini.image = UIImage(named: filterFriends[indexPath.row].image)
        } else {
            cell.FriendName.text = objectArray[indexPath.section].sectionObjects[indexPath.row].name
            cell.photoFriendMini.image = UIImage(named: objectArray[indexPath.section].sectionObjects[indexPath.row].image)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                           titleForHeaderInSection section: Int) -> String?{
        if isFiltering() {
            return nil
        } else {
            return objectArray[section].sectionName
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
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
       filterFriends = fFriends.filter({( friend : Friend) -> Bool in
            return friend.name.lowercased().contains(searchText.lowercased())
        })
        
        friendListView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}
