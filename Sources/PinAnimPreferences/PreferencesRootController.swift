//
//  File.swift
//  
//
//  Created by exerhythm on 09.05.2022.
//

import CepheiPrefs
import Cephei
import UIKit
import SwiftUI

class PAPRootListController: HBRootListController {
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "Root", target: self)
                setValue(specifiers, forKey: "_specifiers")
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = UIColor.systemGreen
        
    }
    
    override func tableViewStyle() -> UITableView.Style {
        return .grouped
    }
}
