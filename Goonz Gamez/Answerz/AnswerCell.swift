//
//  WaitingCell.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/16/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class AnswerCell: UICollectionViewCell {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var background: UIView!

    var parentVC: VotingVC?
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.clipsToBounds = true
        background.layer.cornerRadius = 10
        // Initialization code
    }
    
    
    @IBAction func cellTapped(_ sender: Any) {
        if self.isSelected {
            cellDeselected()
        } else {
            cellSelected()
        }
    }
    
    func cellSelected(){
        self.background.backgroundColor = Constants.colors.ghostViolet
        self.isSelected = true
        self.parentVC?.selectedIndex = self.index ?? -1
        //print("Selected index = \(self.index)")
        self.parentVC?.handleSelection(selectedIndex: self.index ?? -1)
        self.parentVC?.doneButton.isHidden = false
    }
    
    func cellDeselected(){
        self.background.backgroundColor = UIColor.black
        self.isSelected = false
        self.parentVC?.selectedIndex = -1
        self.parentVC?.doneButton.isHidden = true
    }
    
    func automaticDeselect(){
        self.background.backgroundColor = UIColor.black
        self.isSelected = false
    }
}
