//
//  ViewController.swift
//  Lesson 1- Clicker App
//
//  Created by Ang Jun Ray on 19/3/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        counterLabel.layer.cornerRadius = 10
        clickButton.layer.cornerRadius = 10
        congratsLabel.isHidden = true;
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        counter+=1
        counterLabel.text = "Counts: \(counter)"
        if(counter > 20 && counter < 40){
            congratsLabel.isHidden = false;
            congratsLabel.text = "KEEP IT UP 😀"
        }else if(counter > 40){
            congratsLabel.text = "WOW GOOD JOB!"
        }
    }
    
    @IBAction func SignIn(_ sender: Any) {
    }
    
    @IBAction func SignOut(_ sender: Any) {
    }
}

