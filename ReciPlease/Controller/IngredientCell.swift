//
//  IngredientCell.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    // MARK: IBOutlet
    @IBOutlet private weak var ingredientLabel: UILabel!
    
    // MARK: Method
    func setupLabel(ingredient: String) {
        ingredientLabel.text = "- \(ingredient)"
    }
    
}
