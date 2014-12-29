//
//  Animal.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
class MenuItem {
    
    let title: String
    let creator: String
    let image: UIImage?
    
    init(title: String, creator: String, image: UIImage?) {
        self.title = title
        self.creator = creator
        self.image = image
    }
    
    class func allMenuItems() -> Array<MenuItem> {
        return [ MenuItem(title: "Sleeping Cat", creator: "papaija2008", image: nil),
            MenuItem(title: "Pussy Cat", creator: "Carlos Porto", image: nil),
            MenuItem(title: "Korat Domestic Cat", creator: "sippakorn", image:nil),
            MenuItem(title: "Tabby Cat", creator: "dan", image: nil)]
    }
}