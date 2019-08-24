//
//  DisclaimerViewController.swift
//  BMI Calculator
//
//  Created by Peter Wu on 8/24/19.
//  Copyright © 2019 Peter Wu. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var linkTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fillDisclaimer(label: disclaimerLabel)
    }
    

    @IBAction func okButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func fillDisclaimer(label: UILabel) {
        label.text = """
        DISCLAIMER
        
        Body Mass Index (BMI) is an index calculated based on a person’s weight and height.  It is an estimate, not a direct measurement, of a person’s body fat.  The accuracy of BMI is influenced by numerous traits such as gender, ethnicity, age, and athletes.  Therefore BMI by itself is not a good indicator of health or obesity.  Furthermore, BMI calculated by this Calculator is for adults 20 years and older only.  For more information, please visit CDC website at:
        """
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return false
    }
    
    


}
