//
//  AudienceSelectionViewController.swift
//  extensionsample
//
//  Created by Dx on 12/10/14.
//  Copyright (c) 2014 Dx. All rights reserved.
//

import UIKit

@objc(AudienceSelectionViewControllerDelegate)
protocol AudienceSelectionViewControllerDelegate{
    optional func audienceSelectionViewController(
        sender: AudienceSelectionViewController,
        selectedValue: String)
}

class AudienceSelectionViewController: UITableViewController {
    
    struct TableViewValues{
        static let identifier = "Cell"
    }
    
    enum Audience: String{
        case Interesting = "Interesting"
        case Secret = "Secret"
        case Dropbox = "Dropbox"
        static let allValues = [Interesting, Secret, Dropbox]
    }
    
    var delegate: AudienceSelectionViewControllerDelegate?
    
    var audience = Audience.Interesting.rawValue
    
    class func defaultAudience() -> String{
        return Audience.Interesting.rawValue
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        tableView.registerClass(UITableViewCell.classForCoder(),
            forCellReuseIdentifier: TableViewValues.identifier)
        title = "Choose Folder"
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return Audience.allValues.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(
                TableViewValues.identifier,
                forIndexPath: indexPath) as UITableViewCell
            
            let text = Audience.allValues[indexPath.row].rawValue
            
            cell.textLabel.text = text
            
            if text == audience{
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            return cell
    }
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            if let theDelegate = delegate{
                let selectedAudience = Audience.allValues[indexPath.row].rawValue
                theDelegate.audienceSelectionViewController!(self,
                    selectedValue: selectedAudience)
                
            }
            
    }
    
}

