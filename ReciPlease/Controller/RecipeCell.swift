//
//  RecipeCell.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit
import SDWebImage

class RecipeCell: UITableViewCell {

    @IBOutlet private weak var recipeImageview: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var recipeDetailLabel: UILabel!
    @IBOutlet private weak var yieldLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var effectView: UIView!
    
    func setup(image: String, name: String, detail: String, yield: Float, time: Int) {
        recipeNameLabel.text = name
        recipeDetailLabel.text = detail
        yieldLabel.text = "\(yield)"
        timeLabel.text = time == 0 ? "??" : "\(time)"
        recipeImageview.setImage(url: image)
        effectView.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 15)
        effectView.addGradient(colors: [UIColor.clear, UIColor.black])
    }
    
}
