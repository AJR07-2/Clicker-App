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

    var timer:Timer? = Timer()
    var timeElapsed = 0.0
    @IBOutlet weak var Settings: UIButton!
    @IBOutlet weak var LeaderBoard: UIButton!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var History: UIButton!
    @IBOutlet weak var Mode: UISegmentedControl!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "settingsIcon")
        Settings.setBackgroundImage(image, for: UIControl.State.normal)
        
        let image2 = UIImage(named: "trophyIcon")
        LeaderBoard.setBackgroundImage(image2, for: UIControl.State.normal)
        
        let image3 = UIImage(named: "historyIcon")
        History.setBackgroundImage(image3, for: UIControl.State.normal)

        clickButton.layer.cornerRadius = 10
        congratsLabel.isHidden = true
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        counter+=1
        if(counter == 1){
            clickButton.backgroundColor = .red
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timerLabel.isHidden = false
        }
        if(Mode.selectedSegmentIndex == 1){
            counter += Int.random(in: -1..<3)
        }
        
        clickButton.setTitle("\(counter)", for: .normal)
        if(counter%20 == 0){
            congratsLabel.isHidden = false
            congratsLabel.text = Congrats.congrats[counter/20 - 1]
            congratsLabel.alpha = 3
            UIView.animate(withDuration: 3.0) {
                self.congratsLabel.alpha = 0
            }
        }
    }
    
    @objc func updateTimer(){
        timeElapsed += 0.1
        timerLabel.text = "Elapsed Time: \(Double(round(10*timeElapsed)/10))s"
        if(Double(round(10*timeElapsed)/10) == 60.0){
            print("Tmeeee's up!")
            timerLabel.text = "TIME'S UP!"
            timer?.invalidate()
            timer = nil
            timeElapsed = 0.0
            if(FirebaseAuth.Auth.auth().currentUser != nil){
                if(counter > 20){
                    let database = FirebaseFirestore.Firestore.firestore()

                    let date = Date()
                    
                    database.collection("User").document(FirebaseAuth.Auth.auth().currentUser!.email!).collection("History").document().setData([
                        "time": date,
                        "score": counter,
                        "mode": Mode.selectedSegmentIndex
                    ])
                    
                    let prevCounter = counter
                    print(counter)
                    //TODO: CHANGE USER HIGHEST COUNT
                    database.collection("User").getDocuments() { [self] (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                if(document.documentID == FirebaseAuth.Auth.auth().currentUser!.email!){
                                    let data:Int = document.data()["highestCount"] as! Int
                                    if data < prevCounter{
                                        database.collection("User").document(FirebaseAuth.Auth.auth().currentUser!.email!).updateData(["highestCount" : prevCounter])
                                    }
                                }
                            }
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
    
    @IBAction func goToHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let histVC = storyboard.instantiateViewController(withIdentifier: "VC4") as? HistoryViewController{
            self.present(histVC, animated: true, completion: nil)
        }else{
            print("Something went wrong :(")
        }
    }
    
}

