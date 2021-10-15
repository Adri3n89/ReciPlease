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
        tableView.rowHeight = 200
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
        var ingredientsString = ""
        for ingredient in result.hits[indexPath.row].recipe.ingredients {
            ingredientsString += "\(ingredient.food), "
        }
        ingredientsString.removeLast(2)
        let recipe = result.hits[indexPath.row].recipe
        cell.effectView.addGradient(colors: [UIColor.clear, UIColor.black])
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

extension ResultViewController: searchManagerDelegate {
    func searchRecipeSuccess(response: SearchResponse) {
        researchResult!.links.next.href = response.links.next.href
        for hit in response.hits {
            researchResult!.hits.append(hit)
        }
        tableView.reloadData()
    }
    
    func searchRecipeError(error: String) {
        self.alert(text: error)
    }
}
