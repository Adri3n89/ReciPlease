//
//  ResultController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 10/10/2021.
//

import UIKit

class ResultViewController: UITableViewController {
     
    // MARK: Private Variable
    private var searchManager = SearchService()
    
    // MARK: Variable
    var researchResult: SearchResponse? {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
        tableView.register(UINib.init(nibName: "EmptyFavoriteCell", bundle: nil), forCellReuseIdentifier: "EmptyFavoriteCell")
    }
    
    // MARK: ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }

    // MARK: Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = researchResult else { return 0 }
        return result.hits.count == 0 ? 1 : result.hits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let result = researchResult, result.count > 0 else {
            let emptyRecipeCell = tableView.dequeueReusableCell(withIdentifier: "EmptyFavoriteCell", for: indexPath) as! EmptyFavoriteCell
            emptyRecipeCell.setup(text: Constante.noRecipeString, image: Constante.noRecipeImage)
            return emptyRecipeCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        let ingredients = result.hits[indexPath.row].recipe.ingredients.map { $0.food }
        let ingredientsString = ingredients.joined(separator: ", ")
        let recipe = result.hits[indexPath.row].recipe
        cell.setup(image: recipe.image, name: recipe.label, detail: ingredientsString, yield: recipe.yield, time: recipe.totalTime)
        if indexPath.row == result.hits.count - 3 {
            guard let url = researchResult?.links.next?.href else { return UITableViewCell() }
            searchManager.loadNewPage(url: url) { result in
                switch result {
                    case .success(let recipe):
                        self.researchResult!.links.next!.href = recipe.links.next!.href
                        self.researchResult!.hits += recipe.hits.map{ $0 }
                        tableView.reloadData()
                    case .failure(let error):
                        self.alert(text: error.localizedDescription)
                    }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result = researchResult else { return }
        let newController = DetailViewController()
        newController.hit = result.hits[indexPath.row]
        self.navigationController?.pushViewController(newController, animated: true)
    }
    
}

