//
//  ControlTabController.swift
//  Headlight Controller
//
//  Created by Shuai on 1/26/21.
//

import UIKit
import Firebase
import FirebaseAuth
import DropDown

class ControlTabController: UIViewController{
    var button: UIButton?
    var authStateListenerHandle: AuthStateDidChangeListenerHandle!
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStateListenerHandle = Auth.auth().addStateDidChangeListener{(auth, user) in
            if (Auth.auth().currentUser == nil){
                print("There is no user, Go back to sign in ")
                self.navigationController?.popViewController(animated: true)
            }else {
                print("You are signed in already")
            }
            
        }
//        startListening()
    }
  
    @IBAction func pressedEditPatternButton(_ sender: Any) {
    }
    @IBAction func pressedSendPatternButton(_ sender: Any) {
    }
    @IBAction func pressedCreatNewButton(_ sender: Any) {
        performSegue(withIdentifier: "toAnimationDetailSegue", sender: self)
    }
    @IBAction func pressedSelectAnimaButton(_ sender: Any) {
        button = (sender as! UIButton)
        dropDown.dataSource = ["Welcome","Goodbay","Create a new one"]//4
        dropDown.anchorView = (sender as! AnchorView) //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
          guard let _ = self else { return }
            (sender as AnyObject).setTitle(item, for: .normal) //9
            if (item == "Create a new one"){
                self!.performSegue(withIdentifier: "toAnimationDetailSegue", sender: self)
            }
        }
    }
    
}
