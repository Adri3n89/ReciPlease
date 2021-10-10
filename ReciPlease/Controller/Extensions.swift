//
//  Extensions.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 07/10/2021.
//

import UIKit

extension UIView {
    func addGradient(colors: [UIColor]) {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.frame.size
        gradient.colors = colors
        self.layer.addSublayer(gradient)
    }
}
