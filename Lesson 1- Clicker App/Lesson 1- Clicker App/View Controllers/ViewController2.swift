//
//  ViewController2.swift
//  Lesson 1- Clicker App
//
//  Created by Ang Jun Ray on 30/3/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController2: UIViewController {
    @IBOutlet weak var SucessLabel: UILabel!

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Log In"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let userName: UITextField = {
        let userName = UITextField()
        userName.placeholder = "Username"
        userName.layer.borderWidth = 1
        userName.layer.borderColor = UIColor.black.cgColor
        userName.autocapitalizationType = .none
        userName.leftViewMode = .always
        userName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return userName
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.placeholder = "Email Address"
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.autocapitalizationType = .none
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return emailField
    }()
    
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.layer.borderWidth = 1
        passwordField.isSecureTextEntry = true
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        return passwordField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("continue", for: .normal)
        return button
    }()
    
    private let SignOutbutton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log Out", for: .normal)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(userName)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        if FirebaseAuth.Auth.auth().currentUser != nil{
            label.isHidden = true
            userName.isHidden = true
            emailField.isHidden = true
            passwordField.isHidden = true
            button.isHidden = true
            
            view.addSubview(SignOutbutton)
            SignOutbutton.frame = CGRect(x: 20, y: 150, width: view.frame.size.width - 40, height: 52)
            SignOutbutton.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
        }
    }
    
    @objc private func logOutTapped(){
        do{
            try FirebaseAuth.Auth.auth().signOut()
            
            label.isHidden = false
            emailField.isHidden = false
            userName.isHidden = false
            passwordField.isHidden = false
            button.isHidden = false
            
            SignOutbutton.removeFromSuperview()
        }catch{
            print("An error occurred")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 50)
        
        userName.frame = CGRect(x: 20, y: label.frame.origin.y + label.frame.size.height + 10, width: view.frame.size.width - 60, height: 50)

        emailField.frame = CGRect(x: 20, y: userName.frame.origin.y + userName.frame.size.height + 10, width: view.frame.size.width - 60, height: 50)

        passwordField.frame = CGRect(x: 20, y: emailField.frame.origin.y + emailField.frame.size.height + 10, width: view.frame.size.width - 60, height: 50)

        button.frame = CGRect(x: 20, y: passwordField.frame.origin.y + passwordField.frame.size.height + 10, width: view.frame.size.width - 60, height: 50)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser == nil {
            emailField.becomeFirstResponder()
        }
    }
    
    @objc private func didTapButton(){
        print("continue button tapped")
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let userName = userName.text, !userName.isEmpty
        else{
            print("Missing Field Data")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self]result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                //show acc creation
                strongSelf.showCreateAccount(email: email, password: password, username: userName)
                
                return
            }
            
            print("Sign in sucessful")
            strongSelf.label.isHidden = true
            strongSelf.button.isHidden = true
            strongSelf.userName.isHidden = true
            strongSelf.emailField.isHidden = true
            strongSelf.passwordField.isHidden = true
            
            strongSelf.emailField.resignFirstResponder()
            strongSelf.passwordField.resignFirstResponder()
            
            self?.SucessLabel.isHidden = false
        })
    }
    
    func showCreateAccount(email: String, password: String, username: String){
        let alert  = UIAlertController(title: "Create Account", message: "Would you like to create an account", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else {
                    //show acc creation
                    print("Account creation failed")
                    return
                }
                
                print("Sign in sucessful")
                strongSelf.label.isHidden = true
                strongSelf.button.isHidden = true
                strongSelf.emailField.isHidden = true
                strongSelf.passwordField.isHidden = true
                
                strongSelf.emailField.resignFirstResponder()
                strongSelf.passwordField.resignFirstResponder()
                
                //update firebase
                let db = FirebaseFirestore.Firestore.firestore()
                db.collection("User").document(email).setData([
                    "username": username,
                    "email": email,
                    "highestCount": 0
                ])
                
                
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in

        }))
        
        present(alert, animated: true)
    }

    @IBAction func goHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
