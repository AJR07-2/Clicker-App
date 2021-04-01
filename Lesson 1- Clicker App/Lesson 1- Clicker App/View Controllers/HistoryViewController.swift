//
//  HistoryViewController.swift
//  Lesson 1- Clicker App
//
//  Created by Ang Jun Ray on 1/4/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HistoryViewController: UIViewController {

    @IBOutlet weak var history: UITableView!
    var data:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        history.delegate = self
        history.dataSource = self
    }
    
    @IBAction func goHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshLeaderboard(){
        let database = FirebaseFirestore.Firestore.firestore()
        var subData:[String] = []
        database.collection("User").document(FirebaseAuth.Auth.auth().currentUser?.email as! String).collection("History").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm E, d MMM y"

                    
                    let date:Timestamp = document.data()["time"] as! Timestamp
                    let convertedDate : Date = date.dateValue()
                    let reConvertedDate = dateFormatter.string(from: convertedDate)
                    
                    subData.append("Attempt on: \(reConvertedDate), Clicks: \(document.data()["score"] as! Int)")
                }
            }
            data = subData
            history.reloadData()
        }
    }

    
}

extension HistoryViewController: UITableViewDelegate {
    //TODO: handle events for table view
}

extension HistoryViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        refreshLeaderboard()
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = history.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(indexPath[1] + 1). \(data[indexPath[1]])"
        return cell
    }
}
