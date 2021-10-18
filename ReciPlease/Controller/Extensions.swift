//
//  Extensions.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 07/10/2021.
//

import UIKit
import SDWebImage

extension UIView {
    func addGradient(colors: [UIColor]) {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.frame.size
        gradient.colors = colors
        self.layer.addSublayer(gradient)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
    
}

extension UIViewController {
    func alert(text: String) {
        let alert = UIAlertController(title: Constante.error, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: Constante.ok, style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    func setImage(url: String) {
        self.sd_setImage(with: URL(string: url), placeholderImage: nil,
                                         options: SDWebImageOptions.highPriority,
                                         context: nil,
                                         progress: nil,
                                         completed: { _, downloadException, _, downloadURL in
                                     })
    }
}
