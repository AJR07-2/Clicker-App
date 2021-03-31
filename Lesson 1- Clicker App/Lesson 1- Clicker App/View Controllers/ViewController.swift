//
//  ViewController.swift
//  Lesson 1- Clicker App
//
//  Created by Ang Jun Ray on 19/3/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    var timer = Timer()
    var timeElapsed = 0.0
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var LeaderBoard: UIButton!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "settingsIcon")
        Settings.setBackgroundImage(image, for: UIControl.State.normal)
        
        let image2 = UIImage(named: "trophyIcon")
        LeaderBoard.setBackgroundImage(image2, for: UIControl.State.normal)

        clickButton.layer.cornerRadius = 10
        congratsLabel.isHidden = true;
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        counter+=1
        if(counter == 1){
            clickButton.backgroundColor = .red
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            timerLabel.isHidden = false
        }
        clickButton.setTitle("\(counter)", for: .normal)
        if(counter > 20 && counter < 40){
            congratsLabel.isHidden = false;
            congratsLabel.text = "KEEP IT UP 😀"
        }else if(counter > 40){
            congratsLabel.text = "WOW GOOD JOB!"
        }
    }
    
    @objc func updateCounter(){
        timeElapsed += 0.1
        timerLabel.text = "Elapsed Time: \(Double(round(10*timeElapsed)/10))s"
        if(Double(round(10*timeElapsed)/10) == 60.0){
            print("Tmeeee's up!")
            timerLabel.text = "TIME'S UP!"
            timer = Timer()
            timeElapsed = 0.0
            if(FirebaseAuth.Auth.auth().currentUser != nil){
                if(counter > 20){
                    let database = FirebaseFirestore.Firestore.firestore()

                    let date = Date()
                    let calendar = Calendar.current
                    let year = calendar.component(.year, from: date)
                    let month = calendar.component(.month, from: date)
                    let day = calendar.component(.day, from: date)
                    let hour = calendar.component(.hour, from: date)
                    let minutes = calendar.component(.minute, from: date)
                    
                    database.collection("User").document(FirebaseAuth.Auth.auth().currentUser!.email!).collection("History").document().setData([
                        "time": [year, month, day, hour, minutes],
                        "score": counter,
                    ])
                    
                    //TODO: CHANGE USER HIGHEST COUNT
                    let doc = database.collection("User").document(FirebaseAuth.Auth.auth().currentUser!.email!)
                    doc.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                        } else {
                            print("Document does not exist")
                        }
                    }
                    
                    let alert  = UIAlertController(title: "Added to user history!", message: "Your score is \(counter)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cool", style: .cancel, handler: {_ in
                        
                    }))
                    present(alert, animated: true)
                }else{
                    let alert  = UIAlertController(title: "It seems you are afk, your counts are very low", message: "It shall not be added to history", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
                        
                    }))
                    present(alert, animated: true)
                }
                
            }else{
                let alert  = UIAlertController(title: "Could not add to user history, you are not signed in", message: "Your score is \(counter), to keep track of your clicks, please sign in in the future", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
                    
                }))
                present(alert, animated: true)
            }
            
            counter = 0
            clickButton.setTitle("Start", for: .normal)
            clickButton.backgroundColor = .yellow
        }
    }
    
    @IBAction func goToLeaderBoards(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let third = storyboard.instantiateViewController(withIdentifier: "VC3") as? ViewController3{
            self.present(third, animated: true, completion: nil)
        }else{
            print("Something went wrong :(1")
        }
    }
    
    
    @IBAction func goToUserSettings(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let secondVC = storyboard.instantiateViewController(withIdentifier: "VC2") as? ViewController2{
            self.present(secondVC, animated: true, completion: nil)
        }else{
            print("Something went wrong :(")
        }
    }
}

