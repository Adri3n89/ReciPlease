//
//  SearchController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var ingredientTextField: UITextField!
    @IBOutlet private weak var emptyFridgeView: UIView!
    @IBOutlet private weak var ingredientTableView: UITableView!
    
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
        guard ingredients.count > 0 else {
            self.alert(text: Constante.needOneIngredient)
            return
        }
            searchManager.searchRecipe(ingredients: ingredients)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let ingredient = ingredientTextField.text {
            ingredients.append(ingredient)
            ingredientTableView.reloadData()
            if ingredients.count != 0 {
                emptyFridgeView.isHidden = true
            }
            ingredientTextField.text = ""
            closeKeyboard()
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        ingredients.removeAll()
        ingredientTableView.reloadData()
        emptyFridgeView.isHidden = false
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        cell.setupLabel(ingredient: ingredients[indexPath.row])
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

extension SearchViewController: SearchManagerDelegate {
    func searchRecipeSuccess(response: SearchResponse) {
        let newController = ResultViewController()
        newController.researchResult = response
        self.navigationController?.pushViewController(newController, animated: true)
    }
    
    func searchRecipeError(error: String) {
        self.alert(text: error)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeKeyboard()
        return true
    }
}
