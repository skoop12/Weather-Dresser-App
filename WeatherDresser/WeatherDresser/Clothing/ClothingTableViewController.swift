//
//  ClothingTableViewController.swift
//  WeatherDresser
//
//  Created by Sarah Koop on 3/8/19.
//  Copyright © 2019 Sarah Koop. All rights reserved.
//

import UIKit

class ClothingTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    var clothing: [String] = []
    var buttonsChecked: [String: Bool] = [:]
    let clothingView = ClothingView()
    var checkBoxCount: Int = 0
    let defaults = UserDefaults.standard
    var location: String?
    var isANewDay: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.checkBoxCount = self.clothing.count
        
        // Idea here is that once the user has checked off a clothing item (i.e. they have put the item on) the app should not refresh that item to appear unchecked unless it's a new day (even if the location changes)
        guard isANewDay else {
            for item in clothing {
                buttonsChecked[item] = defaults.bool(forKey: item)
            }
            return
        }
        
        for item in clothing {
            defaults.set(false, forKey: item)
            buttonsChecked[item] = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clothing.count
    }

    // https://stackoverflow.com/questions/27371194/set-action-listener-programmatically-in-swift
    // https://stackoverflow.com/questions/28894765/uibutton-action-in-table-view-cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ClothingTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clothingCell", for: indexPath) as! ClothingTableViewCell
        let clothingItem = clothing[indexPath.row]
        cell.clothingImage.image = UIImage(named: clothingItem)
        cell.clothingLabel.text = self.clothingView.getClothingLabel(for: clothingItem)
        cell.clothingBackground.layer.cornerRadius =  10.0
        cell.clothingBackground.layer.masksToBounds = true
        
        if buttonsChecked[clothingItem] == true {
            cell.checkButton.setImage(UIImage(named:"checked"), for: .normal)
        } else {
            cell.checkButton.setImage(UIImage(named:"unchecked"), for: .normal)
        }
        
        cell.checkButton.addTarget(self, action: #selector(self.checkButtonClicked(sender:)), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row

        return cell
    }

    // MARK: - Actions
    
    @objc func checkButtonClicked(sender: UIButton) {
        let cellItem = self.clothing[sender.tag]
        switch buttonsChecked[cellItem] {
        case true:
            defaults.set(false, forKey: cellItem)
            buttonsChecked[cellItem] = false
            sender.setImage(UIImage(named:"unchecked"), for: .normal)
        case false:
            defaults.set(true, forKey: cellItem)
            buttonsChecked[cellItem] = true
            sender.setImage(UIImage(named:"checked"), for: .normal)
        case .none:
            defaults.set(true, forKey: cellItem)
            buttonsChecked[cellItem] = true
            sender.setImage(UIImage(named:"checked"), for: .normal)
        case .some(_):
            return
        }
        for item in buttonsChecked.keys {
            if buttonsChecked[item] == false {
                return
            }
        }
        performSegue(withIdentifier: "showAllSetView", sender: self)

    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showAllSetSegue" {
            return self.checkBoxCount == self.clothing.count
        } else {
            return false
        }
    }
}
