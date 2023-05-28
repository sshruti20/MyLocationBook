//
//  ViewController.swift
//  my-foursquare-clone
//
//  Created by Shruti S on 16/05/23.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: userNameText!.text!, password: passwordText!.text!) { user, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "unknown error")
                } else {
                    //Segue
                    print("welcome \(user?.username)")
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "Error!", message: "username/password missing")
        }
        
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        if userNameText.text == "" || passwordText.text == "" {
            makeAlert(title: "Error!", message: "username/password missing")
        } else {
            let user = PFUser()
            user.username = userNameText.text
            user.password = passwordText.text
            user.signUpInBackground { success, error in
                if error != nil {
                    print("Error")
                } else {
                    print("success - signed up!")
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }

}

