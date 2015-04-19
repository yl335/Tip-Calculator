//
//  ViewController.swift
//  Tip
//
//  Created by Yanwei Lin on 4/11/15.
//  Copyright (c) 2015 AppleSeed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Constraints
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var billBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var billHeightConstraint: NSLayoutConstraint!
    

    var tempBillBottomConstraint: NSLayoutConstraint!
    var actualBillBottomConstraint: NSLayoutConstraint!
    var tempBillHeightConstraint: NSLayoutConstraint!
    
    // Containers
    @IBOutlet weak var billContainer: UIView!
    @IBOutlet weak var tipContainer: UIView!
    @IBOutlet weak var totalContainer: UIView!
    
    // Labels and Fields
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    // Borders
    @IBOutlet weak var KeyboardBorder: UIView!
    
    // Constants
    var bottomLayoutConstant: CGFloat = 0.0
    
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
        tipControl.alpha = 0
        tipContainer.alpha = 0
        totalContainer.alpha = 0
        
        tempBillHeightConstraint = billHeightConstraint
        
        // Expand the bill container to full screen
        tempBillBottomConstraint = NSLayoutConstraint(item: billContainer, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: KeyboardBorder, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        actualBillBottomConstraint = NSLayoutConstraint(item: billContainer, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: tipContainer, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)

        view.removeConstraint(billBottomConstraint)
        view.addConstraint(tempBillBottomConstraint)
        view.removeConstraint(billHeightConstraint)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!        
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
        
        bottomLayoutConstant = CGRectGetMaxY(view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
        bottomLayoutConstraint.constant = bottomLayoutConstant
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
                
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.1, animations: {
                    self.tipControl.alpha = 0
                    self.tipContainer.alpha = 0
                    self.totalContainer.alpha = 0
                    
                })

                self.view.removeConstraint(self.tempBillHeightConstraint)
                self.view.removeConstraint(self.actualBillBottomConstraint)
                self.view.addConstraint(self.tempBillBottomConstraint)
                
                UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.9, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            // If there is a bill, show tip & total
            else {
                self.view.removeConstraint(self.tempBillBottomConstraint)
                self.view.addConstraint(self.actualBillBottomConstraint)
                self.view.addConstraint(self.tempBillHeightConstraint)

                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.7, animations: {
                    self.view.layoutIfNeeded()
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.8, relativeDuration: 0.2, animations: {
                    self.tipControl.alpha = 1
                    self.tipContainer.alpha = 1
                    self.totalContainer.alpha = 1
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

