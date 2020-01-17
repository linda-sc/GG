//
//  WaitingLobby1VC.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/16/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class WaitingLobby1VC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var waitingTable: UITableView!
    var waitingList = Question().goonz
    var numberOfPeople = Question().goonz.count
    
    var counter = 0
    var timer = Timer()

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressContainer.layer.cornerRadius = 20
        waitingTable.delegate = self
        waitingTable.dataSource = self
        waitingTable.register(UINib(nibName: "WaitingCell", bundle: nil), forCellReuseIdentifier: "WaitingCell")
        
        //Remove random people
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(triggerAction), userInfo: nil, repeats: true)
    }
    
    
    @objc func triggerAction(){
        print("Removing random person")
        if self.waitingList.count > 0 {
            let random = Int.random(in: 0...self.waitingList.count - 1)
            self.removeFromWaitTable(row: random)
        }
    }

    func removeFromWaitTable(row: Int) {
        self.waitingList.remove(at: row)
        let myNSIndexPath = [NSIndexPath(row: row, section: 0)]
        self.waitingTable.deleteRows(at: myNSIndexPath as [IndexPath], with:UITableView.RowAnimation.fade)
        
        let progress: Float = Float((numberOfPeople - waitingList.count)/numberOfPeople)
           progressView.setProgress(progress, animated: true)
    }
    

    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.waitingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = waitingTable.dequeueReusableCell(withIdentifier: "WaitingCell", for: indexPath) as! WaitingCell
        cell.nameLabel.text = Question().goonz[indexPath.row]
        return cell
    }
    
}
