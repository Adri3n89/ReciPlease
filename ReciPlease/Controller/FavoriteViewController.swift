//
//  FavoriteController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit
import Alamofire

class FavoriteViewController: UITableViewController {

    var favorites: [FavoriteRecipe] = FavoriteRecipe.all
    var favoriteRecipes: [Hit] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
        tableView.rowHeight = 200
        guard favorites.count > 0 else {return}
        for recipe in favorites {
            let request = AF.request(recipe.url!)
            request.responseDecodable(of: Hit.self) { response in
                guard let recipe = response.value else { return }
                self.favoriteRecipes.append(recipe)
                self.tableView.reloadData()
            }
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        cell.recipeNameLabel.text = favoriteRecipes[indexPath.row].recipe.label
        var ingredientsString = ""
        for ingredient in favoriteRecipes[indexPath.row].recipe.ingredients {
            ingredientsString += "\(ingredient.food), "
        }
        ingredientsString.removeLast(2)
        let recipe = favoriteRecipes[indexPath.row].recipe
        cell.setup(image: recipe.image, name: recipe.label, detail: ingredientsString, like: recipe.yield, time: recipe.totalTime)
        cell.effectView.addGradient(colors: [UIColor.clear, UIColor.black])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newController = DetailViewController()
        newController.hit = favoriteRecipes[indexPath.row]
        self.navigationController?.pushViewController(newController, animated: true)
    }
    
}


