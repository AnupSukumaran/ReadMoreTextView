//
//  ViewController.swift
//  ReadMoreText
//
//  Created by Manu Puthoor on 20/07/20.
//  Copyright © 2020 Manu Puthoor. All rights reserved.
//

import UIKit
import Foundation
import SASReadMoreTxtView

class ViewController: UIViewController {
    
  
    @IBOutlet weak var tv: SASReadMoreTxtView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tv.text = "👨‍👩‍👧‍👦👨‍👩‍👧‍👦👨‍👩‍👧‍👦👨‍👩‍👧‍👦 Lorem http://ipsum.com dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
       // let ss =  UIFont.boldSystemFont(ofSize: 16)
//        let readMoreTextAttributes: [NSAttributedString.Key: Any] = [
//            NSAttributedString.Key.foregroundColor: view.tintColor!,
//            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
//        ]
//        tv.attributedReadMoreText = NSAttributedString(string: "... Read more", attributes: readMoreTextAttributes)
//        tv.maximumNumberOfLines = 6
//        tv.shouldTrim = true
    }
    
    
    @IBAction func btnAction(_ sender: UIButton) {
       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
                     //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SecondViewController") as! SecondViewController
                         
                     //vc.modalPresentationStyle = .fullScreen
                             present(vc, animated: true, completion: nil)
    }
    
}

extension ViewController: TextViewTapActionProtocol {
    func tapAction() {
       let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
  
        present(vc, animated: true, completion: nil)
    }
    
    
}
