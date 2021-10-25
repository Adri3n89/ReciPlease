//
//  FavoriteController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit

class FavoriteViewController: UITableViewController {

    var favorites: [FavoriteRecipe] = []
    var favoriteRecipes: [Hit] = []
    var favoriteManager = FavoriteService()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
        tableView.register(UINib.init(nibName: "EmptyFavoriteCell", bundle: nil), forCellReuseIdentifier: "EmptyFavoriteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favorites = FavoriteRecipe.getAll(context: AppDelegate.viewContext)
        favoriteRecipes = []
        if favorites.count > 0 {
            favoriteManager.loadFavorite(recipes: favorites) { result in
                switch result {
                    case .success(let recipes):
                        self.favoriteRecipes = recipes
                        self.tableView.reloadData()
                    case .failure(let error):
                        self.alert(text: error.localizedDescription)
                }
            }
        } else {
            tableView.reloadData()
        }
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
            let emptyFavoriteCell = tableView.dequeueReusableCell(withIdentifier: "EmptyFavoriteCell", for: indexPath) as! EmptyFavoriteCell
            emptyFavoriteCell.setup(text: Constante.noFavoriteString, image: Constante.noFavoriteImage)
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
        if favoriteRecipes.count > 0 {
            if editingStyle == .delete {
                FavoriteRecipe.deleteRecipe(uri: favoriteRecipes[indexPath.row].recipe.uri, context: AppDelegate.viewContext)
                favoriteRecipes.remove(at: indexPath.row)
                tableView.reloadData()
            }
        } else {
            // sinon ne pas pouvoir swipe la cell ??
        }
    }
    
}

