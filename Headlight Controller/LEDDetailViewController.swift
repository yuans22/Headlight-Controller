//
//  LEDDetailViewController.swift
//  Headlight Controller
//
//  Created by Haoxuan Sun on 2/17/21.
//

import UIKit
import Firebase

class LEDDetailViewController: UIViewController{
    @IBOutlet weak var NoLEDLabel: UILabel!
    @IBOutlet weak var ducycycleValueLabel: UILabel!
    var button: UIButton?
    var currentFramePattern: [Int]?
    
    @IBAction func dutySlide(_ sender: Any) {
        let slide = sender as! UISlider
        ducycycleValueLabel.text = "Duty Cycle: " + String(format: "%.0f",slide.value*1023)
        tableViewController.currentFramePattern[button!.tag-1] = Int(slide.value*1023)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NoLEDLabel.text = "LED" + String(button!.tag)
    }
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(Bool)
    }
    @IBAction func pressedOKButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedCancelButton(_ sender: Any) {
        tableViewController.button?.setImage(tableViewController.offImage, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    var tableViewController: AnimationDetailViewController{
        get {
            let navController = presentingViewController as! UINavigationController
            return navController.viewControllers.last as! AnimationDetailViewController
        }
    }
}

