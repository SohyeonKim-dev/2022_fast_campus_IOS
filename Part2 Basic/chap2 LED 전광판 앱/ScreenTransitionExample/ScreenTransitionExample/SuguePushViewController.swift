//
//  SuguePushViewController.swift
//  ScreenTransitionExample
//
//  Created by κΉμν on 2022/07/04.
//

import UIKit

class SuguePushViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
