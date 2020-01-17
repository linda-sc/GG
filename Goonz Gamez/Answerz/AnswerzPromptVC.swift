//
//  AnswerzPromptVC.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/16/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit
import Foundation

class AnswerzPromptVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var charCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        answerTextView.delegate = self
        answerTextView.isScrollEnabled = false
        submitButton.layer.cornerRadius = 10
        self.promptLabel.text = Question().generatePrompt()
    }

    // MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if isValidAnswer(answer: answerTextView.text){
            print("ANSWER:")
            print(answerTextView.text ?? "No answer...")
            
            self.performSegue(withIdentifier: "GoToWaitingLobby1", sender: self)
                         print("GoToWaitingLobby1 segue triggered.")
        }
        
    }
    
    // MARK: - TextView Delegate Protocol
    func textViewDidBeginEditing(_ textView: UITextView) {
        //If there is placeholder text, then make the bio empty. Otherwise don't.
        if answerTextView.text == "Type your answer here" {
            answerTextView.text = ""
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = answerTextView.sizeThatFits(size)
        textView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height * 1.5 >= 60 {
                    constraint.constant = estimatedSize.height * 1.5
                } else {
                    constraint.constant = 60
                }
            }
        }
        updateCharCount()
    }
    
    func updateCharCount() {
        charCountLabel.text = " \(200 - answerTextView.text.count) characters left"
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        //If the user didn't type a valid bio, then put up the placeholder text.
        if isValidAnswer(answer: answerTextView.text ?? "") == false {
            answerTextView.text = "Type your answer here"
        }
        answerTextView.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            answerTextView.resignFirstResponder()
            return false
        }
        return textView.text.count + (text.count - range.length) <= 200
    }
    
    
    
    func isValidAnswer(answer: String) -> Bool {
        var valid = true
        let rawAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        if rawAnswer == "" {
            valid = false
        } else if answer == "" {
            valid = false
        } else if answer == "Type your answer here" {
            valid = false
        }
        print("Answer is valid? \(valid)")
        return valid
    }

}
