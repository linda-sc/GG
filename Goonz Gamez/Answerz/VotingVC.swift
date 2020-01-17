//
//  WaitingLobby1VC.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/16/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class VotingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var answerCollection: UICollectionView!
    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var sampleAnswers = [
    "daniel, but not for the ride",
    "positions other than missionary",
    "blockchain",
    "his secret fantasy of a threesome with daniel and spencer except he's only watching",
    "bagel holes",
    "bullshit about being a CEO and World Class Fencer, which works incredibly well on insecure small Asian girls",
    "(1) condoms for harvard men that she isn't going to use, (2) a machine learning textbook that she isn't going to read, (3) her iPhone with Hinge, Bumble, and Tinder on it.",
    "Adderall, fuccbois, and hair growth pills",
    "Condoms, plan B, and then probably a scale fo she can check her weight when she feel insecure about a guy not responding.",
    "A Harvard deferral letter",
    "His mother's pyramid scheme involving vitamins and Melissa",
    "Report her family to ICE to avoid paying child support",
    "colonize"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressContainer.layer.cornerRadius = 5
        progressContainer.clipsToBounds = true
        progressView.clipsToBounds = true
        answerCollection.delegate = self
        answerCollection.dataSource = self
        answerCollection.register(UINib(nibName: "AnswerCell", bundle: nil), forCellWithReuseIdentifier: "AnswerCell")
        
        
        //Set estimated item size
        if let flow = answerCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        //Disappearing cells
        let flowLayout = BouncyLayout(style: .prominent)
        self.answerCollection.setCollectionViewLayout(flowLayout, animated: true)
    
        checkIfDone()
    }

       
    private func setStructure(for cell: UICollectionViewCell) {
           cell.layer.borderWidth = 20
           cell.layer.borderColor = UIColor.clear.cgColor
           cell.layer.cornerRadius = 15
    }
    
    // MARK: - Checking to see if everyone is done
    func checkIfDone() {
        if false {
            self.performSegue(withIdentifier: "GoToVoting", sender: self)
            print("GoToVoting segue triggered.")
        }
    }
    
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sampleAnswers.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = answerCollection.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
               self.setStructure(for: cell)
        cell.answerLabel.text = self.sampleAnswers[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width - 60
        let text = self.sampleAnswers[indexPath.row]
        let height: CGFloat = estimateFrameForText(text: text).height + 20
        return CGSize(width: width, height: height)
        }
    
    // MARK: - Estimate cell height
    func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 1000
        //Set the width to the width of the text in the cell.
        let width: CGFloat = view.bounds.width - 80
        
        let size = CGSize(width: width, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}
