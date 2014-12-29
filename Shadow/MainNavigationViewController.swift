//
//  MainNavigationViewController.swift
//  Shadow
//
//  Created by Dx on 28/12/14.
//  Copyright (c) 2014 Dx. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol MainNavigationViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class MainNavigationViewController: UIViewController, SidePanelViewControllerDelegate {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var creatorLabel: UILabel!
    
    var delegate: MainNavigationViewControllerDelegate?
    
    override func viewDidLoad() {
        var albumsVC: AlbumsViewController!
        albumsVC = UIStoryboard.albumsViewController()
        addChildViewController(albumsVC)
    }
    
    @IBAction func menuTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    func menuItemSelected(menuItem: MenuItem) {
        imageView.image = menuItem.image
        titleLabel.text = menuItem.title
        
        delegate?.collapseSidePanels?()
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func albumsViewController() -> AlbumsViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("AlbumsViewController") as? AlbumsViewController
    }
    
    class func mainNavigationViewController() -> MainNavigationViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MainNavigationViewController") as? MainNavigationViewController
    }
}