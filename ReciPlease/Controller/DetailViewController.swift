//
//  DetailController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var recipeImageview: UIImageView!
    @IBOutlet private weak var recipeNameLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var effectView: UIView!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var ingredientTableView: UITableView!
    
    var hit: Hit?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOutlets()
        setupTableview()
        effectView.addGradient(colors: [.yellow, .red])
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(setFavorite))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let favorites = FavoriteRecipe.getAll(context: AppDelegate.viewContext).filter { $0.uri == hit?.recipe.uri }
        navigationItem.rightBarButtonItem?.image = favorites.count == 0 ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
    }
    
    private func setupOutlets() {
        effectView.addGradient(colors: [UIColor.clear, UIColor.darkGray])
        guard let recipe = hit?.recipe else { return }
        recipeImageview.setImage(url: recipe.image)
        recipeNameLabel.text = recipe.label
        likeLabel.text = "\(recipe.yield)"
        timeLabel.text = "\(recipe.totalTime)"
        infoView.layer.borderWidth = 2
        infoView.layer.borderColor = Constante.greenColor.cgColor
        infoView.layer.cornerRadius = 5
        infoView.backgroundColor = Constante.blueColor
    }
    
    @objc private func setFavorite() {
        var favorites = FavoriteRecipe.getAll(context: AppDelegate.viewContext).filter { $0.uri == hit?.recipe.uri }
        if favorites.count == 0 {
            let favorite = FavoriteRecipe(context: AppDelegate.viewContext)
            favorite.uri = hit?.recipe.uri
            try? AppDelegate.viewContext.save()
        } else {
            FavoriteRecipe.deleteRecipe(uri: hit!.recipe.uri, context: AppDelegate.viewContext)
                    // delete all FavoriteRecipe in CoreData
//                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteRecipe")
//                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//                    do {
//                        try context.execute(deleteRequest)
//                    } catch let error as NSError {
//                    }
        }
        favorites = FavoriteRecipe.getAll(context: AppDelegate.viewContext).filter { $0.uri == hit?.recipe.uri }
        navigationItem.rightBarButtonItem!.image = favorites.count == 0 ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
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
