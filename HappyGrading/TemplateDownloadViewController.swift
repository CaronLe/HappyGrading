//
//  TemplateDownloadViewController.swift
//  FlickFinder
//
//  Created by Swift on 3/9/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class TemplateDownloadViewController: UIViewController {
    
 let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fullFieldsDownloadButton(_ sender: UIButton)
    {
        if let url = NSURL(string: "http://google.com") {
            UIApplication.shared.openURL(url as URL)
        }
    }

    @IBAction func onlyMultiChoiceDownloadButton(_ sender: UIButton)
    {
        if let url = NSURL(string: "http://google.com") {
            UIApplication.shared.openURL(url as URL)
        }
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
