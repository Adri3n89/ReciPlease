//
//  WebController.swift
//  ReciPlease
//
//  Created by Adrien PEREA on 06/10/2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var urlStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: urlStr) {
            let req = URLRequest(url: url)
            webView.load(req)
        }
    }

}
