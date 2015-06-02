//
//  ViewController.swift
//  MemoryGame
//
//  Created by Dan Isacson on 18/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var testlabel: UILabel!
    var timer: NSTimer?
    var counter: Int = 0
   // var runloop = NSRunLoop.currentRunLoop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startClick() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: Selector("test"), userInfo: nil, repeats: true)
      /*  self.runloop.addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        self.runloop.addTimer(self.timer!, forMode: UITrackingRunLoopMode)*/

    }
    
    func test(){
        println(self.counter)
        self.testlabel.text = self.counter.description
        self.counter++
        if(counter>9){
            self.timer?.invalidate()
        }
    }
}

