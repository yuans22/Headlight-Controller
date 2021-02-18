//
//  AnimationDetailViewController.swift
//  Headlight Controller
//
//  Created by Haoxuan Sun on 2/17/21.
//

import UIKit
import Firebase
import PopupDialog

class AnimationDetailViewController: UIViewController {
    var LEDPatternRef: CollectionReference!
    var pattern = [Int]()
    var groupCellIdentifier = "GroupCell"
    var GroupListener: ListenerRegistration!
    var singleLEDRef: DocumentReference!
    var button: UIButton?
    @IBOutlet var allButtons: [UIButton]!
    var onImage: UIImage!
    var offImage: UIImage!
    var currentFrame = 0
    var totalFrame = 0
    var currentFramePattern = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @IBOutlet weak var animationNameField: UITextField!
    @IBOutlet weak var pageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onImage = #imageLiteral(resourceName: "light_on.png")
        offImage = #imageLiteral(resourceName: "light_off.png")
        self.pageLabel.text = "Frame 1/1"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddPatternNameDialog))
        LEDPatternRef = Firestore.firestore().collection("Animation")
        
        
//        if singleLEDRef != nil{
//            singleLEDRef.getDocument { (documentSnapshop, error) in
//                if ((documentSnapshop?.exists) != nil){
//                    let temp = documentSnapshop!.get("frame")
//                    self.pageLabel.text = "Frame" + String(self.currentFrame) + "/" + (temp as! String)
//                }
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func pressedLEDButton(_ sender: Any) {
        button = (sender as! UIButton)
        button?.setImage(onImage, for: .normal)
        performSegue(withIdentifier: "ToLEDDetailSegue", sender: self)
    }
    @IBAction func pressedPreviousButton(_ sender: Any) {
        currentFrame -= 1
        self.pageLabel.text = "Frame" + String(currentFrame) + "/" + String(totalFrame)
        singleLEDRef.getDocument { (documentSnapshop, error) in
            if ((documentSnapshop?.exists) != nil){
                let temp = documentSnapshop!.get(String(self.currentFrame)) as! [Int]
                print("patern array:   \(temp)")
                for i in 0...temp.count-1{
                    if temp[i] > 0{
                        self.allButtons[i].setImage(self.onImage, for: .normal)
                    }else{
                        self.allButtons[i].setImage(self.offImage, for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func pressedNextFrameButton(_ sender: Any) {
        let button = sender as! UIButton
        singleLEDRef.updateData([
            String(currentFrame): currentFramePattern,
            "frame": String(totalFrame+1)
        ])
        for buttonTemp in allButtons{
            buttonTemp.setImage(offImage, for: .normal)
        }
        currentFrame += 1
        if totalFrame < currentFrame{
            totalFrame += 1
        }
        self.pageLabel.text = "Frame" + String(currentFrame) + "/" + String(totalFrame)
        currentFramePattern = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        button.addTarget(self, action: #selector(self.loadData), for: .touchUpInside)
    }
    @objc func loadData() {
//        view.reloadData()
    }
    @objc func AddPatternNameDialog(){
        let alertController = UIAlertController(title: "Create a new Pattern", message: "", preferredStyle: .alert)
        
        alertController.addTextField{ (textField) in
            textField.placeholder = "New pattern"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Create", style: .default){ [self] (action) in
            let patternNameFields = alertController.textFields![0] as UITextField
            self.animationNameField.text = patternNameFields.text
            singleLEDRef = LEDPatternRef.document(patternNameFields.text!)
            singleLEDRef.setData([
                "frame": "1",
                "turnOnOff": "Off"
//                "1": patternTemp
            ])
            self.currentFrame = 1
            self.totalFrame = 1
        }
        alertController.addAction(submitAction)
        present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLEDDetailSegue"{
            (segue.destination as! LEDDetailViewController).button = self.button
            (segue.destination as! LEDDetailViewController).currentFramePattern = self.currentFramePattern
        }
    }
    
}







//        let message = "LED" + String(button.tag)
//        let popup = PopupDialog(title: caption, message: message, image: nil)
//        let slide = UISlider()
//        let buttonOne = CancelButton(title: "CANCEL") {
//            print("You canceled the car dialog.")
//        }
//        let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
//            print("What a beauty!")
//        }
//        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
//            print("Ah, maybe next time :)")
//        }
//        popup.addButtons([buttonOne, buttonTwo, buttonThree])
//        self.present(popup, animated: true, completion: nil)
