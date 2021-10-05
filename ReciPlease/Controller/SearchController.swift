//
//  SearchController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var emptyFridgeLabel: UILabel!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    var ingredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        ingredientTableView.register(UINib.init(nibName: "IngredientCell", bundle: nil), forCellReuseIdentifier: "ingredientCell")

    }

    @IBAction func searchPressed(_ sender: Any) {
        self.navigationController?.pushViewController(FavoriteController(), animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let ingredient = ingredientTextField.text {
            ingredients.append(ingredient)
            ingredientTableView.reloadData()
            if ingredients.count != 0 {
                emptyFridgeLabel.isHidden = true
            }
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        ingredients.removeAll()
        ingredientTableView.reloadData()
        emptyFridgeLabel.isHidden = false
    }
    
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        cell.ingredientLabel.text = "- " + ingredients[indexPath.row]
        return cell
    }
    
    
}
