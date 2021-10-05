//
//  FavoriteController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 04/10/2021.
//

import UIKit

class FavoriteController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "recipeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        cell.recipeNameLabel.text = "Pizza"
        cell.recipeDetailLabel.text = "Sauce tomate, olive, fromage"
        cell.likeLabel.text = "2,5k"
        cell.timeLabel.text = "30m"
        cell.recipeImageview.image = UIImage(named: "pizza")
        addGradient(view: cell.effectView)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DetailController(), animated: true)
    }
    
    func addGradient(view: UIView){
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = view.frame.size
        gradient.colors = [UIColor.clear.cgColor,UIColor.black.cgColor,UIColor.black.cgColor, UIColor.black.cgColor] //Or any colors
        view.layer.addSublayer(gradient)
    }
    
}
