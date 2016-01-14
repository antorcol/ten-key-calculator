//
//  ViewController.swift
//  calc-simple-assignment
//
//  Created by Anthony Torrero Collins on 1/8/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var btnSound :AVAudioPlayer!         //when a button is pressed
    var runningNumberStr: String = ""
    var leftSideStr: String = ""
    var rightSideStr: String = ""
    var currOp: NumericOperation = .NoOp
    var result: String = ""
    
    var onStateClickCount: Int = 0
    var onState: Bool = false

    var memoryVal: Double = 0.0     //the value in calc memory

    
    func processOperation(op: NumericOperation) {
        guard(onState)
            else {
                return
        }

        playButtonSound()

        if(currOp != .NoOp) {
            
            if(runningNumberStr != "") {
                rightSideStr = runningNumberStr
                runningNumberStr = ""
                
                if(currOp == .Plus) {
                    result = "\(Double(leftSideStr)! + Double(rightSideStr)!)"
                } else if (currOp == .Minus) {
                    result = "\(Double(leftSideStr)! - Double(rightSideStr)!)"
                } else if (currOp == .Times) {
                    result = "\(Double(leftSideStr)! * Double(rightSideStr)!)"
                } else if (currOp == .DividedBy) {
                    result = "\(Double(leftSideStr)! / Double(rightSideStr)!)"
                }
                
                leftSideStr = result
                lblTotal.text = result
                
            }
            currOp = op
            
        } else {
            leftSideStr = runningNumberStr
            runningNumberStr = ""
            currOp = op
        }
        onStateClickCount = 1
    }

    
    
    @IBOutlet weak var lblTotal: UILabel!
    
    
    /*
        a number button has been pressed
    */
    @IBAction func buttonPressed(btn: UIButton) {

        guard(onState)
            else {
                return
        }
        
        playButtonSound()
        runningNumberStr += "\(btn.tag)"
        lblTotal.text = runningNumberStr
        onStateClickCount = 1

        return
    }
    
    //MARK: Operations
    @IBAction func btnEquals_Press(btn: UIButton) {
        processOperation(currOp)
    }

    @IBAction func btnAdd_Press(btn: UIButton) {
        processOperation(.Plus)
    }

    @IBAction func btnPercent_Press(btn: UIButton) {
        processOperation(.Percent)
    }
    
    @IBAction func btnMultiply_Press(btn: UIButton) {
        processOperation(.Times)
    }
    
    @IBAction func btnDivide_Press(btn: UIButton) {
        processOperation(.DividedBy)
    }
    
    @IBAction func btnSubtract_Press(btn: UIButton) {
        processOperation(.Minus)
    }
    
    
    
    //MARK: Power and Memory Buttons
    
    /*
        turn the calculator on and off.
        also, clear the current value
    */
    @IBAction func btnOnOffClear(sender: UIButton) {
        
        playButtonSound()

        if(!onState) { //turn on if off
            lblTotal.text = "0"
            onStateClickCount = 1
            onState = true
            runningNumberStr = ""
            result = ""
        } else if (onStateClickCount == 1) { //clear the current value only
            //inc and set to zero in ones

            onStateClickCount = 2 //one more to turn off
            lblTotal.text = "0"
            runningNumberStr = ""
            result = ""
            rightSideStr = ""
        } else {
            //turn off
            onStateClickCount = 0
            onState = false
            runningNumberStr = ""
            leftSideStr = ""
            rightSideStr = ""
            result = ""
            lblTotal.text = ""
        }
    }

    
    @IBAction func btnMemoryClear(sender: UIButton) {
        guard(onState)
            else {
                return
        }

        playButtonSound()
        memoryVal = 0.0
        print(memoryVal)
    }
    
    @IBAction func btnMemoryAdd(sender: UIButton) {
        guard(onState)
            else {
                return
        }
        
        guard (!lblTotal.text!.isEmpty)
            else {
                return
        }
        
        guard let tmpVal = Double(lblTotal.text!)
            else {
                return
        }
        
        playButtonSound()
        memoryVal += tmpVal
        print(memoryVal)
    }
    
    @IBAction func btnMemorySubtract(sender: UIButton) {
        
        guard(onState)
            else {
                return
        }
        
        guard (!lblTotal.text!.isEmpty)
            else {
                return
        }
        
        guard let tmpVal = Double(lblTotal.text!)
            else {
                return
        }
        
        playButtonSound()
        memoryVal -= tmpVal
        print(memoryVal)
    }
    
    @IBAction func btnMemoryRecall(btn: UIButton) {
        guard(onState)
            else {
                return
        }
        
        playButtonSound()
        runningNumberStr += "\(btn.tag)"
        lblTotal.text = runningNumberStr
        
    }
    
    
    //MARK: Operation Enum
    enum NumericOperation {
        case Plus
        case Minus
        case Times
        case DividedBy
        case Percent
       // case Equals
        case NoOp
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sounds setup
        let btnSoundPath = NSBundle.mainBundle().pathForResource("laser", ofType: "wav")
        let btnSoundPathURL = NSURL(fileURLWithPath: btnSoundPath!)
        
        do {
            try
                btnSound = AVAudioPlayer(contentsOfURL: btnSoundPathURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        lblTotal.text = ""

    }
    
    func playButtonSound() {
        if(btnSound.playing) {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
}