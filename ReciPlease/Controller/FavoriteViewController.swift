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
    var favoriteManager: FavoriteManager!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteManager = FavoriteManager(delegate: self)
        tableView.register(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = FavoriteRecipe.all
        favoriteRecipes = []
        guard favorites.count > 0 else {
            tableView.reloadData()
            return
        }
        for recipe in favorites {
            favoriteManager.loadFavorite(recipe: recipe.uri!)
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count > 0 ? favoriteRecipes.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favoriteRecipes.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
            let ingredients = favoriteRecipes[indexPath.row].recipe.ingredients.map { $0.food }
            let ingredientsString = ingredients.joined(separator: ", ")
            let recipe = favoriteRecipes[indexPath.row].recipe
            cell.setup(image: recipe.image, name: recipe.label, detail: ingredientsString, yield: recipe.yield, time: recipe.totalTime)
            return cell
        } else {
            let emptyFavoriteCell = UITableViewCell()
            var content = emptyFavoriteCell.defaultContentConfiguration()
            content.attributedText = NSAttributedString(string: "Oups!\nIt looks like you don't have a favorite recipe yet.\nDo a search, select a recipe and click on the favorites button to find the recipe on this tab")
            emptyFavoriteCell.contentConfiguration = content
            return emptyFavoriteCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if favoriteRecipes.count > 0 {
            let newController = DetailViewController()
            newController.hit = favoriteRecipes[indexPath.row]
            self.navigationController?.pushViewController(newController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FavoriteRecipe.deleteRecipe(uri: favoriteRecipes[indexPath.row].recipe.uri)
            favoriteRecipes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
}

extension FavoriteViewController: FavoriteManagerDelegate {
    func loadFavoriteSuccess(recipe: Hit) {
        favoriteRecipes.append(recipe)
        tableView.reloadData()
    }
    
    func loadFavoriteError(error: String) {
        self.alert(text: error)
    }
    
    
}


