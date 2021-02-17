//
//  mainSideViewController.swift
//  Headlight Controller
//
//  Created by Haoxuan Sun on 2/17/21.
//

import UIKit
import Firebase

class mainSideViewController: UIViewController {
    @IBAction func pressedLogoutButton(_ sender: Any) {
        dismiss(animated: false)
        do{
            print("Start log out")
            try Auth.auth().signOut()
         }catch {
            print("Sign out error")
         }
    }
    
    var tableViewController: AnimationTabController{
        get {
            let navController = presentingViewController as! UINavigationController
            return navController.viewControllers.last as! AnimationTabController
        }
    }
}
