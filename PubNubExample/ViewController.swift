//
//  ViewController.swift
//  PubNubExample
//
//  Created by Blake Tsuzaki on 5/3/18.
//  Copyright © 2018 HCDE439. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let pubnub = PubNubCoordinator()
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = ""
        pubnub.delegate = self
    }
    @IBAction func didTapBuzzButton(_ sender: Any) {
        pubnub.send("buzzer")
    }
    @IBAction func didTapLEDButton(_ sender: Any) {
        pubnub.send("led")
    }
}

extension ViewController: PubNubDelegate {
    func didReceiveMessage(message: String) {
        label.text = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.label.text = ""
        }
    }
}
