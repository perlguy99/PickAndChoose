//
//  ViewController.swift
//  Example
//
//  Created by Brent Michalski on 1/19/19.
//  Copyright © 2019 Perlguy, Inc. All rights reserved.
//

import UIKit
import PickAndChoose

class ViewController: UIViewController {

    @IBOutlet weak var button1: PickAndChoose!
    @IBOutlet weak var button2: PickAndChoose!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button1.fieldName = "Button 1"
        button2.fieldName = "Category"
        
        button1.bgColor = .orange
        button2.bgColor = .brown
        
        button1.placeholderText = "Placeholder 1"
        button2.placeholderText = "Placeholder 2"
        
        button1.myImage = UIImage(named: "image")
        button2.myImage = UIImage(named: "image")
    }


}

