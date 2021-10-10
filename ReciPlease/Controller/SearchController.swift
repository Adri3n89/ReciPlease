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
    var searchManager: SearchManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        ingredientTextField.delegate = self
        searchManager = SearchManager(delegate: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    private func setupTableView() {
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        ingredientTableView.register(UINib.init(nibName: "IngredientCell", bundle: nil), forCellReuseIdentifier: "ingredientCell")

    }

    @IBAction func searchPressed(_ sender: Any) {
        searchManager.searchRecipe(ingredients: ingredients)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let ingredient = ingredientTextField.text {
            ingredients.append(ingredient)
            ingredientTableView.reloadData()
            if ingredients.count != 0 {
                emptyFridgeLabel.isHidden = true
            }
            ingredientTextField.text = ""
            closeKeyboard()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
}

extension SearchController: searchManagerDelegate {
    func searchRecipeSuccess(response: SearchResponse) {
        let newController = ResultController()
        newController.researchResult = response
        self.navigationController?.pushViewController(newController, animated: true)
    }
}

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeKeyboard()
        return true
    }
}
