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
    @IBOutlet weak var doneButton: UIButton!
    
    var selectedIndex: Int = -1
    
    var sampleAnswers = [
    "daniel, but not for the ride",
    "positions other than missionary",
    "blockchain",
    "his secret fantasy involving daniel and spencer except he's only watching",
    "bagel holes",
    "bullshit about being a CEO and World Class Fencer, which works incredibly well on insecure girls",
    "(1) protection that she isn't going to use, (2) a machine learning textbook that she isn't going to read, (3) her iPhone with Hinge, Bumble, and Tinder on it.",
    "Adderall and hair growth pills",
    "Korean food, plan B, and then probably a scale so she can check her weight when she feels insecure about a guy not responding.",
    "A Harvard deferral letter",
    "A pyramid scheme involving vitamins and Melissa",
    "Not paying child support",
    "colonize"
    ]
    
    var answers: [Answer] = []
    var visibleAnswers: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressContainer.layer.cornerRadius = 5
        progressContainer.clipsToBounds = true
        progressView.clipsToBounds = true
        doneButton.layer.cornerRadius = 12
        doneButton.clipsToBounds = true
        doneButton.isHidden = true
        
        
        // MARK: - Dynamic collection view protocol
        
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
    
        // MARK: - Stepwise logic
        
        //Start showing the answers
        visibleAnswers = []
        generateAnswers()
        //Disable touches until all the answers are done animating
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
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        checkIfDone()
    }
    
    func checkIfDone() {
        if selectedIndex != -1 {
            self.performSegue(withIdentifier: "GoToResults", sender: self)
            print("GoToResults segue triggered.")
        }
    }
    
    
    // MARK: - Collection view protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.visibleAnswers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = answerCollection.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
               self.setStructure(for: cell)
        
        //Set cell properties
        cell.answerLabel.text = self.visibleAnswers[indexPath.row].text
        cell.index = self.visibleAnswers[indexPath.row].index
        //print("cell.index = \(cell.index!)")
        cell.parentVC = self
        
        if self.selectedIndex == cell.index {
            cell.isSelected = true
            cell.background.backgroundColor = Constants.colors.ghostViolet
        } else {
            cell.isSelected = false
            cell.background.backgroundColor = UIColor.black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let answerCell = cell as! AnswerCell
        if self.selectedIndex == answerCell.index {
                   answerCell.isSelected = true
                   answerCell.background.backgroundColor = Constants.colors.ghostViolet
               } else {
                   answerCell.isSelected = false
                   answerCell.background.backgroundColor = UIColor.black
               }
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
        
        for index in 0...self.answers.count - 1 {
            //Deselect everything else
            if index != selectedIndex {
                let indexPath = IndexPath(row: index, section: 0)
                
                if let cell = answerCollection.cellForItem(at: indexPath) as? AnswerCell {
                   cell.automaticDeselect()
                } 
            }
        }
    }
    
    // MARK: - NETWORK CALLS
    // MARK: - Given: User, game, turn, phase, and status
    // MARK: - Action: Submit vote for voting phase
    // MARK: - Confirmation: Proceed once responses are all submitted
    
}
