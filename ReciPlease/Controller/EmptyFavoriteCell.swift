//
//  EmptyFavoriteCell.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 17/10/2021.
//

import UIKit

class EmptyFavoriteCell: UITableViewCell {

    @IBOutlet private weak var emptyFavoriteLabel: UILabel!
    @IBOutlet private weak var cellImageView: UIImageView!
    
    func setup(text: String, image: String) {
        emptyFavoriteLabel.text = text
        cellImageView.image = UIImage(named: image)
    }
    
}
