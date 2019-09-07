//
//  GroupsViewController.swift
//  1l_ChernovaVV
//
//  Created by Lidiya on 09/03/2019.
//  Copyright © 2019 lidiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct GroupVk {
    let name: String
    let id: Int
    let photo_100: String
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        // self.online = json["online"].intValue
        self.photo_100 = json["photo_100"].stringValue
    }
    
}

class GroupsViewController: UIViewController {
    
    let getGroups = VkService()
    var groupGetVk = [GroupVk]() //запрос данных из json

    
    var groups = [
    ["Странный юмор", "g1"],
    ["Бумажный кораблик", "g2"]
    ]

    @IBOutlet weak var GroupsListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GroupsListView.dataSource = self
        // Do any additional setup after loading the view.
        
        getGroups.loadGroupVkJSON(path: "/method/groups.get", fields: "photo_100") { [weak self] groupGetVk in
            self?.groupGetVk = groupGetVk
            self?.GroupsListView.reloadData()
            
        }
        
        self.navigationController?.delegate = self
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        
        // Проверяем идентификатор, чтобы убедится, что это нужный переход
        if segue.identifier == "addGroup" {
            
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let addGroupController = segue.source as! AddGroupViewController
            
            // Получаем индекс выделенной ячейки
            if let indexPath = addGroupController.GroupsListView.indexPathForSelectedRow {
                // Получаем группу по индексу
                let group = addGroupController.groups[indexPath.row]
                // Проверяем, что такой группы нет в списке
                if !groups.contains(group) {
                    // Добавляем группу в список выбранных
                    groups.append(group)
                    
                    // Обновляем таблицу
                    GroupsListView.reloadData()
                }

            }
            
        }

    }

}


extension GroupsViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return CustomPushAnimator()
        } else if operation == .pop {
            return CustomPopAnimator()
        }
        return nil
    }
    
    
}

extension GroupsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupGetVk.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        
        let groupVks = groupGetVk[indexPath.row]
        cell.configure(with: groupVks)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если была нажата кнопка «Удалить»
        if editingStyle == .delete {
            // Удаляем город из массива
            groups.remove(at: indexPath.row)
            // И удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
