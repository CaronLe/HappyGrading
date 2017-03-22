//
//  AlertForMissedRequiredField.swift
//  PitchPerfect
//
//  Created by Swift on 09/02/2017.
//  Copyright © 2017 Swift. All rights reserved.
//


import UIKit

class AlertForMissedRequiredField: UIViewController
{
  
  class func singleFieldMissedAlert(nameOfField: String) -> UIAlertController
    {
        let nameFieldMissedAlert = UIAlertController(title: "Missing \(nameOfField) SoundTrack", message: "Please enter your course's \(nameOfField)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        nameFieldMissedAlert.addAction(okAction)
        return nameFieldMissedAlert
    }
}

