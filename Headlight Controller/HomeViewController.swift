//
//  HomeViewController.swift
//  MovieQuotes
//
//  Created by Shuai on 1/18/21.
//

import UIKit
import Firebase
//impor`    AQ234567890-=-0987651`1t FirebaseAuth

class HomeViewController: UIViewController{
    
    var authStateListenerHandle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItem.Style.plain,
                                                            target: self,
                                                            action: #selector(showMenu))

    }
    
    @objc func showMenu() {
        print("You pressed the add button")
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Control", style: UIAlertAction.Style.default) { (action) in
            //TODO: Control Tab
            print("Control tab")
        })
        
        alertController.addAction(UIAlertAction(title: "Animation", style: UIAlertAction.Style.default) { (action) in
            //TODO: Animation Tab
            print("Animation tab")
        })
        
        alertController.addAction(UIAlertAction(title: "Configuration", style: UIAlertAction.Style.default) { (action) in
            //TODO: Configuration Tab
            print("Configuration tab")
        })
        
        alertController.addAction(UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.destructive) { (action) in
            do{
                try Auth.auth().signOut()
            } catch {
                print("Sign out error")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
//        alertController.view.tintColor = UIColor.red
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authStateListenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if (Auth.auth().currentUser == nil) {
                print("There is no user. Go back to the login page")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("You are signed in. Stay on this page!")
            }
        })
//        startListening()
    }
    
//    func startListening(){
//        if(movieQuoteListener != nil){
//            movieQuoteListener.remove()
//        }
//        var query = movieQuotesRef.order(by: "created", descending: true).limit(to: 50)
//        if !isShowingAllQuotes {
//            query = query.whereField("author", isEqualTo: Auth.auth().currentUser!.uid)
//        }
//        movieQuoteListener = query.addSnapshotListener { (querySnapshot, error) in
//            if let querySnapshot = querySnapshot{
//                self.movieQuotes.removeAll()
//                querySnapshot.documents.forEach { (documentSnapshot) in
//                    self.movieQuotes.append(MovieQuote(documentSnapshot: documentSnapshot))
//                }
//                self.tableView.reloadData()
//            } else {
//                print("Error getting movie quotes \(error!)")
//                return
//            }
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        movieQuoteListener.remove()
        Auth.auth().removeStateDidChangeListener(authStateListenerHandle)
    }
    
    @IBAction func pressedControl(_ sender: Any) {
        print("Current location: Control tab")
    }
    
    
    @IBAction func pressedAnimation(_ sender: Any) {
        print("Current location: Aimation tab")
    }
    
    @IBAction func pressedConfiguration(_ sender: Any) {
        print("Current location: Configuration tab")
    }
    
}
