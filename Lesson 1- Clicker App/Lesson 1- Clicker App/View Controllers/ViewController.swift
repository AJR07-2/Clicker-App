//
//  ViewController.swift
//  Lesson 1- Clicker App
//
//  Created by Ang Jun Ray on 19/3/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let image = UIImage(named: "settingsIcon")
        Settings.frame = CGRect(x: 30, y: 40, width: 20, height: 20)
        Settings.setBackgroundImage(image, for: UIControl.State.normal)

        clickButton.layer.cornerRadius = 10
        congratsLabel.isHidden = true;
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        counter+=1
        if(counter == 1){
            clickButton.backgroundColor = .red
        }
        clickButton.setTitle("\(counter)", for: .normal)
        if(counter > 20 && counter < 40){
            congratsLabel.isHidden = false;
            congratsLabel.text = "KEEP IT UP 😀"
        }else if(counter > 40){
            congratsLabel.text = "WOW GOOD JOB!"
        }
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let secondVC = storyboard.instantiateViewController(withIdentifier: "VC2") as? ViewController2{
            self.present(secondVC, animated: true, completion: nil)
        }else{
            print("Something went wrong :(")
        }
    }
}

