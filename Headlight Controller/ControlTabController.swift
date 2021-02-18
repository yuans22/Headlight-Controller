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
    var LEDPatternRef: CollectionReference!
    var AnimationListener: ListenerRegistration!
    var currentPattern: String?
    let dropDown = DropDown()
    var patternName = [String]()
    var isEdit = false

    override func viewDidLoad() {
        super.viewDidLoad()
        LEDPatternRef = Firestore.firestore().collection("Animation")
        setupInitial()
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
        startListening()
    }
    func startListening(){
        if (AnimationListener != nil){
            AnimationListener.remove()
        }
//        let query = groupChatRef.order(by: "created", descending: true).limit(to:50)
        
        AnimationListener = LEDPatternRef.addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self.patternName.removeAll()
                querySnapshot.documents.forEach { (documentSnapshot) in
                    self.patternName.append(documentSnapshot.documentID)
                }
                self.patternName.append("Create a new one")
            }else{
                print("error getting movie qu \(error!)")
                return
            }
        }
    }
    @IBAction func pressedEditPatternButton(_ sender: Any) {
        isEdit = true
        performSegue(withIdentifier: "toAnimationDetailSegue", sender: self)
    }
    @IBAction func pressedSendPatternButton(_ sender: Any) {
        LEDPatternRef.document(currentPattern!).updateData(["turnOnOff": "on"])
    }
    @IBAction func pressedCreatNewButton(_ sender: Any) {
        isEdit = false
        performSegue(withIdentifier: "toAnimationDetailSegue", sender: self)
    }
    @IBAction func pressedSelectAnimaButton(_ sender: Any) {
        button = (sender as! UIButton)

        dropDown.dataSource = patternName//["welcome","goodbay","Create a new one"]//4
        dropDown.anchorView = (sender as! AnchorView) //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
          guard let _ = self else { return }
            (sender as AnyObject).setTitle(item, for: .normal) //9
            self?.currentPattern = item
            if (item == "Create a new one"){
                self!.performSegue(withIdentifier: "toAnimationDetailSegue", sender: self)
            }
        }
    }
    func setupInitial(){
        let tempRef = LEDPatternRef.document("welcome")
        tempRef.setData([
            "frame": "24",
            "turnOnOff": "Off"        ])
        let tempRef2 = LEDPatternRef.document("goodbay")
        tempRef2.setData([
            "frame": "24",
            "turnOnOff": "Off"
        ])
        var patternTemp = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
        var patternTemp2 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
        for i in 0...23{
            patternTemp[i] = 1
            patternTemp2[patternTemp2.count - i - 1] = 1
            tempRef.updateData([
                String(i+1): patternTemp
            ])
            tempRef2.updateData([
                String(i+1): patternTemp2
            ])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLEDDetailSegue" && isEdit == true{
            (segue.destination as! AnimationDetailViewController).singleLEDRef = LEDPatternRef.document(currentPattern!)
            LEDPatternRef.document(currentPattern!).getDocument { (docu, error) in
                (segue.destination as! AnimationDetailViewController).currentFramePattern = docu?.get("1") as! [Int] //?.data("1")
            }
//            (segue.destination as! AnimationDetailViewController).currentFramePattern =
        }
    }
    
    
}
