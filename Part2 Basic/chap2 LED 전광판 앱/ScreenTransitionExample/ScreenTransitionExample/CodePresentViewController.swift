//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by κΉμν on 2022/07/04.
//

import UIKit

class CodePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
