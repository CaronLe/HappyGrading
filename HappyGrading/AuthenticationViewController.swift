//
//  AuthenticationViewController.swift
//  HappyGrading
//
//  Created by Swift on 3/27/17.
//  Copyright © 2017 Swift. All rights reserved.
//

import UIKit
import Firebase
class AuthenticationViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var register: UIButton!
    weak var currentUser: FIRUser?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logIn(_ sender: Any)
    {
        
    }
    
    @IBAction func register(_ sender: UIButton)
    {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
