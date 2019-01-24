//
//  ViewController.swift
//  Example
//
//  Created by Brent Michalski on 1/19/19.
//  Copyright © 2019 Perlguy, Inc. All rights reserved.
//

import UIKit
import PickAndChoose

class ViewController: UIViewController, PickAndChooseDelegate {
    var pickAndChooseData: PickAndChooseData? = ["Emergency2", "Complaint2", "Appointment2", "Information2"]
    
    // PickAndChooseDelegate
    func numberOfComponents(in picker: PickAndChoose) -> Int {
        return 1
    }
    
    func pickAndChoose(_ picker: PickAndChoose, numberOfRowsInComponent component: Int) -> Int {
        return pickAndChooseData?[component].count ?? 0
    }
    
    func getSelected() {
        
    }
    
    func pickAndChoose(_ picker: PickAndChoose, addItemToDataSource item: String) {
        pickAndChooseData?.append(item)
        picker.setSelectedValue(to: item)
        
        print("\nADD ITEM \(item) TO THE DATA SOURCE\n")
    }
    
    
    func pickAndChoose(_ picker: PickAndChoose, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickAndChooseData?.item(at: row)
//        return pickAndChooseData?[component].item(at: row)
    }
    

    @IBOutlet weak var button1: PickAndChoose!
    @IBOutlet weak var button2: PickAndChoose!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        button2.delegate   = self

        button1.fieldName = "Button 1"
//        button2.fieldName = "Category"
        
//        button2.allowsAddingValues = true
        
//        button1.bgColor = .orange
//        button2.bgColor = .brown
        
        button1.placeholderText = "Placeholder 1"
        button2.placeholderText = "Placeholder 2"
        
        button1.myImage = UIImage(named: "image")
        button2.myImage = UIImage(named: "image")
    }


}

