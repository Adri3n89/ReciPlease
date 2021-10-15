//
//  DetailController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var recipeImageview: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var effectView: UIView!
    @IBOutlet private weak var ingredientTableView: UITableView!
    
    var hit: Hit?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        setupTableview()
    }
    
    private func setupOutlets() {
        effectView.addGradient(colors: [UIColor.clear, UIColor.darkGray])
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(setFavorite))
        guard let recipe = hit?.recipe else { return }
        recipeImageview.setImage(url: recipe.image)
        recipeNameLabel.text = recipe.label
        likeLabel.text = "\(recipe.yield)"
        timeLabel.text = "\(recipe.totalTime)"
    }
    
    @objc private func setFavorite() {
        
    }
    
    private func setupTableview() {
        ingredientTableView.register(UINib.init(nibName: "IngredientCell", bundle: nil), forCellReuseIdentifier: "ingredientCell")
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
    }

    @IBAction func getDirectionPressed(sender: Any) {
        guard let recipe = hit?.recipe else { return }
        let newController = WebViewController()
        newController.urlStr = recipe.url
        self.navigationController?.pushViewController(newController, animated: true)
    }
    
    @IBAction func addFavorites(sender: Any) {
        let favorites = FavoriteRecipe.all.filter { $0.url == hit?.links.linksSelf.href }
        if favorites.count == 0 {
            let favorite = FavoriteRecipe(context: AppDelegate.viewContext)
            favorite.url = hit?.links.linksSelf.href
            try? AppDelegate.viewContext.save()
        } else {
            let context = AppDelegate.viewContext
            for recipe in FavoriteRecipe.all {
                if recipe.url == hit?.links.linksSelf.href {
                    context.delete(recipe)
                }
            }
        }
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = hit?.recipe else { return 0 }
        return recipe.ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        guard let recipe = hit?.recipe else { return UITableViewCell() }
        cell.setupLabel(ingredient: recipe.ingredientLines[indexPath.row])
        return cell
    }
    
    
    
    
    
    
    
}
