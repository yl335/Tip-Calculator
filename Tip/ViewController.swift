//
//  ViewController.swift
//  Tip
//
//  Created by Yanwei Lin on 4/11/15.
//  Copyright (c) 2015 AppleSeed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup placeholder text for bill
        var placeholder = NSAttributedString(string: "$0")
        billField.attributedPlaceholder = placeholder
        
        // Set the billField to active on load
        billField.becomeFirstResponder()
        
        // Initial values for labels
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onEditingChanged(sender: AnyObject) {
        
        // Get selected tip percentage
        var tipPercentages = [0.18, 0.2, 0.22]
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        // Remove the prefix '$'
        var billString = billField.text
        if billString.hasPrefix("$") {
            billString = billString.substringFromIndex(advance(billString.startIndex, 1))
            if billString.isEmpty {
                billField.text = nil
            }
        }
        else {
            billField.text = "$" + billField.text;
        }
        
        // Compute tip and total
        var billAmount = (billString as NSString).doubleValue
        var tip = billAmount * tipPercentage
        var total = billAmount + tip

        // Update values
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    @IBAction func onSwipeBill(sender: AnyObject) {
        billField.text = nil
    }
}

