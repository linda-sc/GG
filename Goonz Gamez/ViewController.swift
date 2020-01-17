//
//  ViewController.swift
//  Goonz Gamez
//
//  Created by Linda Chen on 1/16/20.
//  Copyright © 2020 Synestha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "GoToAnswerzStoryboard", sender: self)
              print("Going to Answerz storyboard.")
    }

}

