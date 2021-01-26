//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by Shuai on 1/25/21.
//

import UIKit
import FirebaseAuth
import Firebase
import Rosefire
import GoogleSignIn

class LoginViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    let ShowListSegueIndentifier = "ShowListSegue"
    let REGISTRY_TOKEN = "d53c6cf9-fabc-4b11-b172-ac48395f6251" // DONE go visit rosefire.csse.rose-hulman.edu to generate this!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        signInButton.style = .wide
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            print("Someone is already signed in! Just move on")
            self.performSegue(withIdentifier: self.ShowListSegueIndentifier, sender: self)
        }
    }

    @IBAction func pressedSignInNewUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error{
                print("Error creating a new user forEmail/Password \(error)")
                return
            }
            print("Signed in New User")
            self.performSegue(withIdentifier: self.ShowListSegueIndentifier, sender: self)

        }
    }
    
    @IBAction func pressedLogInExistingUser(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error{
                print("Error logging in an existing user forEmail/Password \(error)")
                return
            }
            print("Signed in existing User")
            self.performSegue(withIdentifier: self.ShowListSegueIndentifier, sender: self)
        }
    }
    
    @IBAction func pressedRosefireLogin(_ sender: Any) {
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
          if let err = err {
            print("Rosefire sign in error! \(err)")
            return
          }
//          print("Result = \(result!.token!)")
          print("Result = \(result!.username!)")
          print("Result = \(result!.name!)")
          print("Result = \(result!.email!)")
          print("Result = \(result!.group!)")
          Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
            if let error = error {
              print("Firebase sign in error! \(error)")
              return
            }
            // User is signed in using Firebase!
            self.performSegue(withIdentifier: self.ShowListSegueIndentifier, sender: self)
          }
        }

    }
    
}
