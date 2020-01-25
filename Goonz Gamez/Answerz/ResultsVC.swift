//
//  ResultsVC.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/25/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class ResultsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var answerTopMargin: NSLayoutConstraint!
    @IBOutlet weak var waitingTopMargin: NSLayoutConstraint!
    @IBOutlet weak var progressUIView: UIView!
    @IBOutlet weak var waitingLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var progressBarHeight: NSLayoutConstraint!
    @IBOutlet weak var waitingLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var resultsCollection: UICollectionView!
    
    var waitingList: [String] = []
    var numberOfPeople = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressUIView.layer.cornerRadius = 3
        self.progressUIView.clipsToBounds = true
        self.answerTopMargin.constant = 200
        self.waitingTopMargin.constant = 70
        self.progressBarHeight.constant = 0
        self.waitingLabelHeight.constant = 0
        self.nextButton.layer.cornerRadius = 12
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateResult()
        }
        
        // MARK: - Dynamic collectionview protocol
        resultsCollection.delegate = self
        resultsCollection.dataSource = self
        resultsCollection.register(UINib(nibName: "WaitingCell", bundle: nil), forCellWithReuseIdentifier: "WaitingCell")
        
        //Set estimated item size
        if let flow = resultsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        //Disappearing cells
        let flowLayout = BouncyLayout(style: .prominent)
        self.resultsCollection.setCollectionViewLayout(flowLayout, animated: true)
        
    }

    
    func animateResult() {
        self.progressBarHeight.constant = 15
        self.waitingLabelHeight.constant = 20
        
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("finished waiting")
            //self.finishedWaiting()
        }
    }
    
    func finishedWaiting(){
        
        self.waitingList = Question().goonz
        self.numberOfPeople = Question().goonz.count
        
        self.answerTopMargin.constant = 20
        self.waitingTopMargin.constant = 30
        self.progressBarHeight.constant = 0
        self.waitingLabelHeight.constant = 0
           
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.resultsCollection.reloadData()
        }
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        finishedWaiting()
    }
    
    // MARK: - Collection view data source
    private func setStructure(for cell: UICollectionViewCell) {
        cell.layer.borderWidth = 20
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.waitingList.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultsCollection.dequeueReusableCell(withReuseIdentifier: "WaitingCell", for: indexPath) as! WaitingCell
               self.setStructure(for: cell)
        cell.nameLabel.text = self.waitingList[indexPath.row] as? String
        let randomInt = Int.random(in: 0...25)
        cell.scoreLabel.text = String(randomInt)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width - 60
        let height: CGFloat = 60
        return CGSize(width: width, height: height)
        }
    
}


