//
//  WelcomeThreeViewController.swift
//  OthersMobile
//
//  Created by Andrew Tuzson on 2/13/18.
//  Copyright © 2018 Andrew Tuzson. All rights reserved.
//

import UIKit

class WelcomeThreeViewController: UIViewController {
    
    @IBOutlet weak var swipeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swipeImageView.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displaySwipeView()
    }
    
    func displaySwipeView() {
        swipeImageView.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 3.0, options: [], animations: {
            self.swipeImageView.alpha = 1
        }, completion: nil)
    }
    
}
