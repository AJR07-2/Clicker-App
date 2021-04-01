//
//  ViewController3.swift
//  Lesson 1- Clicker App
//
//  Created by Ang Jun Ray on 30/3/21.
//

import UIKit
import FirebaseFirestore

class ViewController3: UIViewController {

    @IBOutlet weak var Leaderboards: UITableView!
    
    var data:[String] = []
    override func viewDidLoad() {
        refreshLeaderboard()
        super.viewDidLoad()
        //Delegate and dataSource of table view
        Leaderboards.delegate = self
        Leaderboards.dataSource = self
    }
    
    @IBAction func goHome(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    func refreshLeaderboard(){
        let database = FirebaseFirestore.Firestore.firestore()
        var subData:[String] = []
        database.collection("User").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    subData.append("\(document.data()["username"] as! String): \(document.data()["highestCount"] as! Int)")
                }
            }
            data = subData
            data.sort()
            var count2 = 0
            for i in data{
                count2 += 1
                data[count2-1] = "\(count2). \(i)"
            }
            Leaderboards.reloadData()
        }
    }
}

extension ViewController3: UITableViewDelegate {
    //TODO: handle events for table view
}

extension ViewController3: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        refreshLeaderboard()
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Leaderboards.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath[1]]
        return cell
    }
}
