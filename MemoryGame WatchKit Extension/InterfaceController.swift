//
//  InterfaceController.swift
//  MemoryGame WatchKit Extension
//
//  Created by Dan Isacson on 18/03/15.
//  Copyright (c) 2015 dna. All rights reserved.
//

import WatchKit
import Foundation


enum boxColors: UInt32 {
    case yellow, green, blue, red
}



class InterfaceController: WKInterfaceController {
    
    @IBOutlet var currentScoreLabel: WKInterfaceLabel!
    @IBOutlet var highScoreLabel: WKInterfaceLabel!
    @IBOutlet var yellow: WKInterfaceButton!
    @IBOutlet var green: WKInterfaceButton!
    @IBOutlet var blue: WKInterfaceButton!
    @IBOutlet var red: WKInterfaceButton!
    @IBOutlet var start: WKInterfaceButton!
    
    var timer: NSTimer?
    
    var clickCounter: Int = 0
    var sequenceCounter: Int = 0
    var colorSequence: [boxColors] = []
    
    var isPlaying = false
    
    var userDefaults = NSUserDefaults(suiteName: "group.dna.memorygame")
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.disableAllButtons()
        self.enableStartButton()
        self.updateHighScoreLabel()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func startClick() {
        self.startSequence()
        self.start.setTitle("")
        self.start.setEnabled(false)
    }
    

    func startSequence(){
        self.sequenceCounter = 0
        let randomColor: boxColors = boxColors(rawValue: (arc4random() % 4))!
        self.colorSequence.append(randomColor)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.75, target:self, selector: Selector("showSequence"), userInfo: nil, repeats: true)
        self.disableAllButtons()
    }
    
    func lightButton(button: WKInterfaceButton){
        button.setEnabled(true)
    }
    
    func fadeButton(indata: NSTimer){
        var button = indata.userInfo as! WKInterfaceButton
        button.setEnabled(false)
    }

    func showSequence(){
        if(self.sequenceCounter < self.colorSequence.count){
            var button = self.colorToButton(self.colorSequence[self.sequenceCounter])
            self.lightButton(button)
            let fadeTimer = NSTimer.scheduledTimerWithTimeInterval(0.375, target:self, selector: Selector("fadeButton:"), userInfo: button, repeats: false)
            self.sequenceCounter++
        }else{
            self.enableAllButtons()
            self.timer?.invalidate()
        }
    }
    
    func disableAllButtons(){
        self.isPlaying = false
        self.yellow.setEnabled(false)
        self.green.setEnabled(false)
        self.blue.setEnabled(false)
        self.red.setEnabled(false)
    }
    
    func enableAllButtons(){
        self.isPlaying = true
        self.clickCounter = 0
        self.yellow.setEnabled(true)
        self.green.setEnabled(true)
        self.blue.setEnabled(true)
        self.red.setEnabled(true)
    }
    
    func colorToButton(color: boxColors)->WKInterfaceButton{
        switch(color){
        case .yellow:
            return self.yellow
        case .green:
            return self.green
        case .blue:
            return self.blue
        case .red:
            return self.red
        }
    }
    @IBAction func yellowClick() {
        self.checkColorWithSequence(.yellow)
    }
    
    @IBAction func greenClick() {
        self.checkColorWithSequence(.green)
    }
    
    @IBAction func blueClick() {
        self.checkColorWithSequence(.blue)
    }
    
    @IBAction func redClick() {
        self.checkColorWithSequence(.red)
    }
    
    func checkColorWithSequence(boxColor: boxColors){
        if(self.isPlaying){
            if(self.clickCounter < self.colorSequence.count){
                if(boxColor == self.colorSequence[self.clickCounter]){
                    //last element
                    if(self.clickCounter == self.colorSequence.count - 1){
                        self.nextLevel()
                    }else{
                        self.clickCounter++
                    }
                }else{
                    self.gameOver()
                }
            }
        }
    }
    
    func nextLevel(){
        let currentScore = self.colorSequence.count
        self.currentScoreLabel.setText("Current: \(currentScore)")
        self.startSequence()
        println("Next level")
    }
    
    func gameOver(){
        self.currentScoreLabel.setText("Current: 0")
        self.updateHighScore(self.colorSequence.count - 1)
        self.disableAllButtons()
        self.colorSequence = []
        self.enableStartButton()
        println("Game over")
    }
    
    func enableStartButton(){
        self.start.setTitle("Start")
        self.start.setEnabled(true)
    }
    
    func updateHighScore(score: Int){
        if let highscore = self.userDefaults?.integerForKey("highscore"){
            if(score > highscore){
                self.userDefaults?.setInteger(score, forKey: "highscore")
            }
        }else{
            self.userDefaults?.setInteger(score, forKey: "highscore")
        }
        self.updateHighScoreLabel()
    }
    
    func updateHighScoreLabel(){
        if let highscore = self.userDefaults?.integerForKey("highscore"){
            self.highScoreLabel.setText("Highscore: \(highscore)")
        }else{
            self.highScoreLabel.setText("Highscore: 0")
        }
    }
}
