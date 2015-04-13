//
//  ViewController.swift
//  Tip
//
//  Created by Yanwei Lin on 4/11/15.
//  Copyright (c) 2015 AppleSeed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billContainer: UIView!
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    let maxBillContainerHeight: CGFloat = 350.0
    let minBillContainerHeight: CGFloat = 168.0
    let minBillLabelY: CGFloat = 74.0
    let maxBillLabelY: CGFloat = 175.0
    let minBillFieldY: CGFloat = 64.0
    let maxBillFieldY: CGFloat = 165.0
    let minBillLabelFontSize: CGFloat = 14.0
    let maxBillLabelFontSize: CGFloat = 18.0
    
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
        
        // Hide tip and total labels
        billContainer.frame.size.height = self.maxBillContainerHeight
        tipControl.alpha = 0
        billLabel.frame.origin.y = maxBillLabelY
        billField.frame.origin.y = maxBillFieldY
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
            
            // Set field to empty if only '$' remains
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
        
        UIView.animateKeyframesWithDuration(1.0, delay: 0.5, options: nil, animations: {
            // If no bill, maximize screen for bill input
            if (billAmount.isZero) {
                
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.25, animations: {
                    self.tipControl.alpha = 0
                })

                UIView.addKeyframeWithRelativeStartTime(0.3, relativeDuration: 0.7, animations: {
                    self.billContainer.frame.size.height = self.maxBillContainerHeight
                    self.billLabel.frame.origin.y = self.maxBillLabelY
                    self.billField.frame.origin.y = self.maxBillFieldY
                })
            }
            // If there is a bill, show tip & total
            else {
                
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.7, animations: {
                    self.billContainer.frame.size.height = self.minBillContainerHeight
                    self.billLabel.frame.origin.y = self.minBillLabelY
                    self.billField.frame.origin.y = self.minBillFieldY
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.75, relativeDuration: 0.25, animations: {
                    self.tipControl.alpha = 1
                })
            }
            
        }, completion: { finished in
        })
    }
    
    @IBAction func onSwipeBill(sender: AnyObject) {
        billField.text = "$"
        onEditingChanged(sender)
    }
}

