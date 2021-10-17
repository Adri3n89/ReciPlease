//
//  ResultController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 10/10/2021.
//

import UIKit

class ResultViewController: UITableViewController {
        
    var researchResult: SearchResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    var searchManager: SearchManager!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchManager = SearchManager(delegate: self)
        tableView.register(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let result = researchResult else { return 0 }
        return result.hits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let result = researchResult else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        let ingredients = result.hits[indexPath.row].recipe.ingredients.map { $0.food }
        let ingredientsString = ingredients.joined(separator: ", ")
        let recipe = result.hits[indexPath.row].recipe
        cell.setup(image: recipe.image, name: recipe.label, detail: ingredientsString, yield: recipe.yield, time: recipe.totalTime)
        if indexPath.row == result.hits.count - 3 {
            searchManager.loadNewPage(url: (researchResult?.links.next.href)!)
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

extension ResultViewController: SearchManagerDelegate {
    func searchRecipeSuccess(response: SearchResponse) {
        researchResult!.links.next.href = response.links.next.href
        researchResult!.hits += response.hits.map{ $0 }
        tableView.reloadData()
    }
    
    func searchRecipeError(error: String) {
        self.alert(text: error)
    }
}
