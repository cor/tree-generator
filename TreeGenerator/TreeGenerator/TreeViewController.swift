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
    let autoRefreshInterval = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Call refresh() when the screen is tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.refresh))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        // Autorefresh every autoRefreshInterval seconds
        NSTimer.scheduledTimerWithTimeInterval(autoRefreshInterval, target: self, selector: #selector(self.autoRefresh), userInfo: nil, repeats: true)
    }
    
    @IBAction func switchUpdated(sender: UISwitch) {
        shouldAutoRefresh = sender.on
    }
    
    func refresh() {
        view.setNeedsDisplay()
    }
    
    func autoRefresh() {
        if shouldAutoRefresh {
            refresh()
        }
    }
 
}

