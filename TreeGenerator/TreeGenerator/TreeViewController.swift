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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.screenTapped(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(self.autoRefresh), userInfo: nil, repeats: true)
    }
    
    func screenTapped(sender: UIView) {
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchUpdated(sender: UISwitch) {
        if sender.on {
            shouldAutoRefresh = true
        } else {
            shouldAutoRefresh = false
        }
    }
    
    func autoRefresh() {
        if shouldAutoRefresh {
            refresh()
        }
    }
    
    func refresh() {
        view.setNeedsDisplay()
    }
 
}

