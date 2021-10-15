//
//  RecipeCell.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit
import SDWebImage

class RecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImageview: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeDetailLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var effectView: UIView!
    
    func setup(image: String, name: String, detail: String, yield: Float, time: Int) {
        recipeNameLabel.text = name
        recipeDetailLabel.text = detail
        yieldLabel.text = "\(yield)"
        timeLabel.text = time == 0 ? "??" : "\(time)"
        recipeImageview.sd_setImage(with: URL(string: image), placeholderImage: nil,
                                         options: SDWebImageOptions.highPriority,
                                         context: nil,
                                         progress: nil,
                                         completed: { _, downloadException, _, downloadURL in
                                     })
        effectView.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 15)
    }
    
}
