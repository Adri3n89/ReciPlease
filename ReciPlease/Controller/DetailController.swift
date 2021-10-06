//
//  DetailController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 05/10/2021.
//

import UIKit
import SDWebImage

class DetailController: UIViewController {
    
    @IBOutlet weak var recipeImageview: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    var recipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient(view: effectView)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(setFavorite))
        recipeImageview.sd_setImage(with: URL(string: recipe!.image), placeholderImage: nil,
                                    options: SDWebImageOptions.highPriority,
                                    context: nil,
                                    progress: nil,
                                    completed: { _, downloadException, _, downloadURL in
                                })
        recipeNameLabel.text = recipe!.label
        likeLabel.text = "\(recipe!.yield)"
        timeLabel.text = "\(recipe!.totalTime)"
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
        guard let recipe = recipe else { return }
        let newController = WebController()
        newController.urlStr = recipe.url
        print(recipe.url)
        self.navigationController?.pushViewController(newController, animated: true)
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
        return (recipe?.ingredientLines.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
        cell.ingredientLabel.text = "- " + (recipe?.ingredientLines[indexPath.row])!
        return cell
    }
    
    
    
    
    
    
    
}
