//
//  ViewController.swift
//  TestLyft
//
//  Created by Michael Bishoff on 9/7/16.
//  Copyright © 2016 Michael Bishoff. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("loggedIn", sender: nil)
    }

}

