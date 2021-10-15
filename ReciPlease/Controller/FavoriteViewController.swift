//
//  FavoriteController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit
import Alamofire

class FavoriteViewController: UITableViewController {

    var favorites: [FavoriteRecipe] = []
    var favoriteRecipes: [Hit] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = FavoriteRecipe.all
        guard favorites.count > 0 else {return}
        for recipe in favorites {
            favoriteRecipes = []
            let request = AF.request(recipe.url!)
            request.responseDecodable(of: Hit.self) { response in
                guard let recipe = response.value else { return }
                self.favoriteRecipes.append(recipe)
                self.tableView.reloadData()
            }
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        let ingredients = favoriteRecipes[indexPath.row].recipe.ingredients.map { $0.food }
        let ingredientsString = ingredients.joined(separator: ", ")
        let recipe = favoriteRecipes[indexPath.row].recipe
        cell.setup(image: recipe.image, name: recipe.label, detail: ingredientsString, yield: recipe.yield, time: recipe.totalTime)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newController = DetailViewController()
        newController.hit = favoriteRecipes[indexPath.row]
        self.navigationController?.pushViewController(newController, animated: true)
    }
    
}


