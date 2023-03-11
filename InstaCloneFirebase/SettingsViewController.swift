//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Muhammet Kadir on 5.03.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func logoutClick(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("error")
        }
    }
    

}
