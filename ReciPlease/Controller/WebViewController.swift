//
//  WebController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 06/10/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet private weak var webView: WKWebView!
    
    // MARK: Variable
    var urlStr = ""

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlStr) {
            let req = URLRequest(url: url)
            webView.load(req)
        }
    }

}
