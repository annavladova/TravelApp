//
//  ForgotPasswordViewController.swift
//  Lesson9
//
//  Created by macbook on 8/26/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
//    MARK: - OUTLETS
    
    @IBOutlet weak var loginButton: UIButton!
    
//    MARK: - LIFECIRCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad ForgotPasswordViewController")
        roundCorners(button: loginButton, radius: 4)
    }
    
//    MARK: - FUNCTION
    
    func roundCorners(button: UIView , radius: CGFloat) {
        button.layer.cornerRadius = radius
    }
    
//    MARK: - ACTIONS
    
}
