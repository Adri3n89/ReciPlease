//
//  DetailController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var recipeImageview: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    var ingredients = [
        "50g de fromage",
        "100g de tomate",
        "6 olives",
        "2 tranches de jambon"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient(view: effectView)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(setFavorite))
        setupTableview()
    }
    
    
    private func setupTableview() {
        ingredientTableView.register(UINib.init(nibName: "IngredientCell", bundle: nil), forCellReuseIdentifier: "ingredientCell")
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
    }
    
    @objc private func setFavorite() {
        
    }

    @IBAction func getDirectionPressed(sender: Any) {
        print("go to directions")
    }
    
    func addGradient(view: UIView){
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = view.frame.size
        gradient.colors = [UIColor.clear.cgColor, UIColor.darkGray.cgColor] //Or any colors
        view.layer.addSublayer(gradient)
    }

}

extension DetailController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        cell.ingredientLabel.text = "- " + ingredients[indexPath.row]
        return cell
    }
    
    
    
    
    
    
    
}
