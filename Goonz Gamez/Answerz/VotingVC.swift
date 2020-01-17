//
//  WaitingLobby1VC.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/16/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class VotingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var waitingCollection: UICollectionView!

    var waitingList = Question().goonz
    var numberOfPeople = Question().goonz.count
    
    var counter = 0
    var timer = Timer()

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressContainer.layer.cornerRadius = 5
        progressContainer.clipsToBounds = true
        progressView.clipsToBounds = true
        waitingCollection.delegate = self
        waitingCollection.dataSource = self
        waitingCollection.register(UINib(nibName: "WaitingCell", bundle: nil), forCellWithReuseIdentifier: "WaitingCell")
        
        
        //Set estimated item size
        if let flow = waitingCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        //Disappearing cells
        let flowLayout = BouncyLayout(style: .prominent)
        self.waitingCollection.setCollectionViewLayout(flowLayout, animated: true)
    
        checkIfDone()
    }
    
    
    // MARK: - Removing people
    @IBAction func screenTapped(_ sender: Any) {
        triggerAction()
        checkIfDone()
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
        self.waitingCollection.deleteItems(at: myNSIndexPath as [IndexPath])
        
        let peopleRemaining = Float(self.waitingList.count)
        let peopleFinished = Float(numberOfPeople) - peopleRemaining
        let total = Float(numberOfPeople)
        print("People finished: \(peopleFinished)")
        let progress: Float = peopleFinished/total
        print("Progress: \(progress)")
           progressView.setProgress(progress, animated: true)
    }
    

       
    private func setStructure(for cell: UICollectionViewCell) {
           cell.layer.borderWidth = 20
           cell.layer.borderColor = UIColor.clear.cgColor
           cell.layer.cornerRadius = 15
    }
    
    // MARK: - Checking to see if everyone is done
    func checkIfDone() {
        if self.waitingList.isEmpty {
            self.performSegue(withIdentifier: "GoToVoting", sender: self)
            print("GoToVoting segue triggered.")
        }
    }
    
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.waitingList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = waitingCollection.dequeueReusableCell(withReuseIdentifier: "WaitingCell", for: indexPath) as! WaitingCell
               self.setStructure(for: cell)
        cell.nameLabel.text = self.waitingList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width - 5
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
        }
}
