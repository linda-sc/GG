//
//  Question.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/16/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import Foundation
import UIKit

//test comment

class Question {
    var person1: String = ""
    var person2: String = ""
    var person3: String = ""
    var prompt: String = ""
    
    let goonz: [String] = [ "Linda", "Daniel", "Michelle", "Aleksa", "Douglas", "Spencer", "Nina", "Eric", "Luke", "Jaison", "David", "Andrew"]
    
    func choosePeople() -> Int {
        let numPeople = 12 - 1
        let peopleArray = self.goonz
    
        //Choose num1
        let num1 = Int.random(in: 0...numPeople)
        //Choose num2
        var num2 = Int.random(in: 0...numPeople)
        while (num2 == num1) {
            num2 = Int.random(in: 0...numPeople)
        }
        //Choose num3
        var num3 = Int.random(in: 0...numPeople)
        while (num3 == num1 || num3 == num2) {
            num3 = Int.random(in: 0...numPeople)
        }
        
        person1 = peopleArray[num1]
        person2 = peopleArray[num2]
        person3 = peopleArray[num3]

        return numPeople
    }
    
    func generatePrompt() -> String {
        
        let numPeople = choosePeople()
        let randomNumber = Int.random(in: 1...3)
        var prompt = ""
        switch randomNumber {
        case 1:
            prompt = "\(person1) got arrested. What for?"
        case 2:
            prompt = "\(person1) got arrested. What for?"
        case 3:
            prompt = "What is \(person1)'s type?"
        case 4:
            prompt = "What is \(person1)'s secret fantasy?"
        default:
            prompt = "Why did \(person1) and \(person2) get in a fight?"
        }
        
        self.prompt = prompt
        return prompt
    }
}
