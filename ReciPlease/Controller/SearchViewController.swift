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
    @IBOutlet private weak var mealTypePicker: UIPickerView!
    @IBOutlet private weak var dishTypePicker: UIPickerView!
    
    var ingredients: [String] = []
    var searchManager = SearchService()
    var mealType = "All"
    var dishType = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPicker()
        ingredientTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    private func setupPicker() {
        mealTypePicker.delegate = self
        mealTypePicker.dataSource = self
        dishTypePicker.delegate = self
        dishTypePicker.dataSource = self
    }
    
    private func setupTableView() {
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        ingredientTableView.register(UINib.init(nibName: "IngredientCell", bundle: nil), forCellReuseIdentifier: "ingredientCell")
    }

    @IBAction func searchPressed(_ sender: Any) {
        guard ingredients.count > 0 else {
            alert(text: Constante.needOneIngredient)
            return
        }
        searchManager.searchRecipe(session: searchManager.sessionManager, ingredients: ingredients, mealType: mealType, dishType: dishType) { result in
            switch result {
                case .success(let recipe):
                    let newController = ResultViewController()
                    newController.researchResult = recipe
                    self.navigationController?.pushViewController(newController, animated: true)
                case .failure(let error):
                    self.alert(text: error.localizedDescription)
            }
        }
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

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeKeyboard()
        return true
    }
}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? Constante.mealType.count : Constante.dishType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Avenir Next", size: 15)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = pickerView.tag == 0 ? Constante.mealType[row] : Constante.dishType[row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.tag == 0 ? (mealType = Constante.mealType[row]) : (dishType = Constante.dishType[row])
    }
    
}
