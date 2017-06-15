//
//  ViewController.swift
//  TreeGenerator
//
//  Created by Cor Pruijs on 15-06-16.
//  Copyright © 2016 CorCoder. All rights reserved.
//

import UIKit

class TreeViewController: UIViewController, UIGestureRecognizerDelegate {

    var shouldAutoRefresh = true
    var shouldHyperRefresh = false
    
    let autoRefreshInterval = 2.0
    let hyperRefreshInterval = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Call refresh() when the screen is tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.refresh))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        // Autorefresh every autoRefreshInterval seconds
        Timer.scheduledTimer(timeInterval: autoRefreshInterval, target: self, selector: #selector(self.autoRefresh), userInfo: nil, repeats: true)
        
        // Hyperrefresh every hyperRefreshInterval seconds
        Timer.scheduledTimer(timeInterval: hyperRefreshInterval, target: self, selector: #selector(self.hyperRefresh), userInfo: nil, repeats: true)

    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    @IBAction func switchUpdated(_ sender: UISwitch) {
        
        if let id = sender.restorationIdentifier {
            switch id {
            case "autoRefresh": shouldAutoRefresh = sender.isOn
            case "hyperRefresh": shouldHyperRefresh = sender.isOn
            default: break
            }
        }
      
    }
    
    func refresh() {
        view.setNeedsDisplay()
    }
    
    func autoRefresh() {
        if shouldAutoRefresh {
            refresh()
        }
    }
    func hyperRefresh() {
        if shouldHyperRefresh {
            refresh()
        }
    }
 
}

