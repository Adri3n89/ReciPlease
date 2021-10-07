//
//  FavoriteController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit

class FavoriteController: UITableViewController {
    
    var favorite = true
    var researchResult: APIResponse? {
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
        cell.recipeNameLabel.text = result.hits[indexPath.row].recipe.label
        var ingredientsString = ""
        for ingredient in result.hits[indexPath.row].recipe.ingredients {
            ingredientsString += "\(ingredient.food), "
        }
        ingredientsString.removeLast(2)
        let recipe = result.hits[indexPath.row].recipe
        cell.setup(image: recipe.image, name: recipe.label, detail: ingredientsString, like: recipe.yield, time: recipe.totalTime)
        addGradient(view: cell.effectView)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let result = researchResult else { return }
        let newController = DetailController()
        newController.recipe = result.hits[indexPath.row].recipe
        self.navigationController?.pushViewController(newController, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !favorite {
            let position = scrollView.contentOffset.y
            if position > tableView.contentSize.height - 100 - scrollView.frame.size.height {
                print("load data")
                searchManager.loadNewPage(url: (researchResult?.links.next.href)!)
            }
        }
    }
    
    func addGradient(view: UIView){
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = view.frame.size
        gradient.colors = [UIColor.clear.cgColor,UIColor.black.cgColor,UIColor.black.cgColor, UIColor.black.cgColor] //Or any colors
        view.layer.addSublayer(gradient)
    }
    
}

extension FavoriteController: searchManagerDelegate {
    func searchRecipeSuccess(response: APIResponse) {
        researchResult!.links.next.href = response.links.next.href
        for hit in response.hits {
            researchResult!.hits.append(hit)
        }
        tableView.reloadData()
    }
}
