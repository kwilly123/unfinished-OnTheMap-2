//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-10.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
//        setLoggingIn(true)
        fieldsChecker()
        UdacityClient.login(self.emailTextField.text!, self.passwordTextField.text!) {(successful, error) in
            if successful {
                print("success")
                DispatchQueue.main.async {
                    let mapVC = self.storyboard?.instantiateViewController(identifier: "TabBarController") as! UITabBarController
                    self.navigationController?.pushViewController(mapVC, animated: true)
                }
            } else {
                let invalidLogin = UIAlertController(title: "Invalid Access", message: "Invalid Email or Password", preferredStyle: .alert)
                invalidLogin.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                    return
                }))
                self.present(invalidLogin, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let url = UdacityClient.Endpoints.signUp.url
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    private func fieldsChecker(){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
            let alert = UIAlertController(title: "Fill the auth info", message: "Please fill both email and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) { //function handles all of the UI Elements states
        if loggingIn {
            activityIndicator.startAnimating()
            print("loggin in")
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}

