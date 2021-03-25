//
//  UIView+Extension.swift
//  Notes
//
//  Created by Mohit Gupta on 25/03/21.
//


import UIKit
// seting cornerRadius for next button
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {return cornerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
