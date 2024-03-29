//
//  LeftViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol SidePanelViewControllerDelegate {
    func menuItemSelected(menuItem: MenuItem)
}

class SidePanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SidePanelViewControllerDelegate?
    var menuItems: Array<MenuItem>!
    
    struct TableView {
        struct CellIdentifiers {
            static let MenuItemCell = "MenuItemCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.MenuItemCell, forIndexPath: indexPath) as MenuItemCell
        cell.configureForAnimal(menuItems[indexPath.row])
        return cell
    }
    
    // Mark: Table View Delegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let selectedMenuItem = menuItems[indexPath.row]
        delegate?.menuItemSelected(selectedMenuItem)
    }
    
}

class MenuItemCell: UITableViewCell {
    @IBOutlet weak var menuItemImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var imageCreatorLabel: UILabel!
    
    func configureForAnimal(menuItem: MenuItem) {
        menuItemImageView.image = menuItem.image
        imageNameLabel.text = menuItem.title
    }
}