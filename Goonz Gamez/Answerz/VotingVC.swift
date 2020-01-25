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
    
    var selectedIndex: Int = -1
    
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
    
    var answers: [Answer] = []
    var visibleAnswers: [Answer] = []
    
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
        //let flowLayout = BouncyLayout(style: .prominent)
        let flowLayout = CollectionViewFlowLayout()
        self.answerCollection.setCollectionViewLayout(flowLayout, animated: true)
    
        //Start showing the answers
        visibleAnswers = []
        generateAnswers()
        self.answerCollection.isUserInteractionEnabled = false
        displayAnswers()
        checkIfDone()
    }
    
    
    func generateAnswers() {
        for i in 0...sampleAnswers.count - 1 {
            let answerObject = Answer()
            answerObject.uid = ""
            answerObject.text = sampleAnswers[i]
            answerObject.index = i
            
            self.answers.append(answerObject)
        }
        
    }

    
    // MARK: - Displaying answers
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func displayAnswers() {
        self.triggerAction()
         //Repeating delays must be done recursively like this.
        delayWithSeconds(0.7) {
            if self.visibleAnswers.count < self.answers.count {
                self.displayAnswers()
            } else {
                //Once the answers are out, allow the user to select.
                print("Done.")
                self.answerCollection.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        //triggerAction()
        //displayAnswers()
    }
    
    @objc func triggerAction(){
           print("Displaying next answer")
        if self.visibleAnswers.count < self.answers.count {
            let next = self.sampleAnswers.count - self.visibleAnswers.count - 1
               self.displayNextAnswer(index: next)
           }
       }

   func displayNextAnswer(index: Int) {
        print("Displaying answer \(index)")
        let nextAnswer = self.answers[index]
        self.visibleAnswers.insert(nextAnswer, at: 0)
        let myNSIndexPath = [NSIndexPath(row: 0, section: 0)]
        self.answerCollection.insertItems(at: myNSIndexPath as [IndexPath])
        //self.answerCollection.reloadData()
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
        return self.visibleAnswers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = answerCollection.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
               self.setStructure(for: cell)
        //Set cell properties
        cell.answerLabel.text = self.visibleAnswers[indexPath.row].text
        cell.index = self.visibleAnswers[indexPath.row].index
        print("cell.index = \(cell.index!)")
        cell.parentVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width - 60
        let text = self.visibleAnswers[indexPath.row].text
        let height: CGFloat = estimateFrameForText(text: text).height + 20
        print("Rendering cell with height \(height)")
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
    
      // MARK: - Handling selection
    func handleSelection(selectedIndex: Int) {
        
        for index in 0...self.visibleAnswers.count {
            //Deselect everything else
            if index != selectedIndex {
                let indexPath = IndexPath(row: index, section: 0)
                
                if let cell = answerCollection.cellForItem(at: indexPath) as? AnswerCell {
                   cell.automaticDeselect()
                }
            }
        }
    }
    
}
