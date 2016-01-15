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

    //MARK: Local Variables
    var btnSound :AVAudioPlayer!    //when a button is pressed
    var runningNumberStr: String = "0"  //always reflects the display during number entry. Cleared on + - / * =
    var leftSideStr: String = "0"       //contains the display value after operator entry. Cleared on =
    var rightSideStr: String = "0"      //contains the value in numeric display after 2nd/subsequent operator entry. Cleared on =
    var currOp: NumericOperation = .NoOp   //contains the earlier queued operator
    var onState: Bool = false              //true iff the calculator is on
    var onStateClickCount: Int = 0      //the number of times the On/Clear button has been clicked
    var memoryVal: String = "0"         //the value in calc memory

    //MARK: Outlets
    @IBOutlet weak var lblTotal: UILabel!
    
    //MARK: Numeric Operations
    /*
        Pre:
            the calculator is ON
            a number button has been pressed
        Post:
            update the display and the running number with 
            the added digit
    */
    @IBAction func numberButtonPressed(btn: UIButton) {

        guard(onState)
            else {
                return
        }
        
        playButtonSound()
        
        if((runningNumberStr == "0") || (runningNumberStr == "0.0")) {
            runningNumberStr = "\(btn.tag)"
        } else {
            runningNumberStr += "\(btn.tag)"
        }
        
        lblTotal.text = runningNumberStr
        onStateClickCount = 1

        return
    }
    
    /*
        Pre
            One of +, -, x, \u{00F7}, % is pressed
        Post
            complete any right-hand calculations,
            put the result in the left-hand register,
            and reset the right-hand register
    
    */
    func processNumericOp(op: NumericOperation) {
        
        var result: String = "0"            //contains the result of a calculation
        
        playButtonSound()
        onStateClickCount = 1
        
        
        rightSideStr = runningNumberStr
        runningNumberStr = "0"
        
        if(currOp == .Plus) {
            result = "\(Double(leftSideStr)! + Double(rightSideStr)!)"
        } else if (currOp == .Minus) {
            result = "\(Double(leftSideStr)! - Double(rightSideStr)!)"
        } else if (currOp == .Times) {
            result = "\(Double(leftSideStr)! * Double(rightSideStr)!)"
        } else if (currOp == .DividedBy) {
            result = "\(Double(leftSideStr)! / Double(rightSideStr)!)"
        } else {
            print("Unknown Operation in processNumericOp!")
        }
        
        lblTotal.text = result
        rightSideStr = "0"
        leftSideStr = result
        
        if(op != .Equals) {
            currOp = op
        } else {
           // leftSideStr = "0"
        }
        
    }
    
    
    //MARK: Button Actions
    /* 
        note that in order to make the equals button work with an immediate
        operator after (such as '1+5=*4=' ... I moved some of the logic
        from processNumericOp into the actions. Some duplication, but 
        it made it simpler.
    */
    
    
    /*
        if there is a calculation queued,
        complete the calculation, 
        and reset the right-hand register.
        otherwise, just stop the running input
    */
    @IBAction func btnEquals_Press(btn: UIButton) {
        guard(onState)
            else {
                return
        }
        if(currOp != .NoOp) {
            processNumericOp(.Equals)
            currOp = .NoOp
        } else {
            playButtonSound()
            leftSideStr = lblTotal.text!
            runningNumberStr = "0"
            //currOp already .NoOp
        }
    }

    /*
        start an add operation
        complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register
    */
    @IBAction func btnAdd_Press(btn: UIButton) {
        guard(onState)
            else {
                return
        }
        if(currOp != .NoOp) {
            processNumericOp(.Plus)
        } else {
            playButtonSound()
            leftSideStr = lblTotal.text!
            runningNumberStr = "0"
            currOp = .Plus
        }
    }

    /*
        start a percent operation
        complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register
    */
    @IBAction func btnPercent_Press(btn: UIButton) {
        guard(onState)
            else {
                return
        }
        if(currOp != .NoOp) {
            processNumericOp(.Percent)
        } else {
            playButtonSound()
            leftSideStr = lblTotal.text!
            runningNumberStr = "0"
            currOp = .Percent
        }
    }
    
    /*
        start a multiply operation
        complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register
    */
    @IBAction func btnMultiply_Press(btn: UIButton) {
        guard(onState)
            else {
                return
        }
        if(currOp != .NoOp) {
            processNumericOp(.Times)
        } else {
            playButtonSound()
            leftSideStr = lblTotal.text!
            runningNumberStr = "0"
            currOp = .Times
        }
    }
    
    /*
        start a divide operation
        complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register
    */
    @IBAction func btnDivide_Press(btn: UIButton) {
        guard(onState)
            else {
                return
        }
        if(currOp != .NoOp) {
            processNumericOp(.DividedBy)
        } else {
            playButtonSound()
            leftSideStr = lblTotal.text!
            runningNumberStr = "0"
            currOp = .DividedBy
        }
    }
    
    /*
        start a subtract operation
        complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register
    */
    @IBAction func btnSubtract_Press(btn: UIButton) {
        guard(onState)
            else {
                return
        }
        if(currOp != .NoOp) {
            processNumericOp(.Minus)
        } else {
            playButtonSound()
            leftSideStr = lblTotal.text!
            runningNumberStr = "0"
            currOp = .Minus
        }
    }

    
    //MARK: Power and Memory Buttons
    
    /* 
        Pre:
            the calculator is ON
            one of the four memory buttons has been pressed
        Post:
            the appropriate memory operation is complete
    */
    func processMemoryOperation(op: NumericOperation) {
        
        guard(onState)
            else {
                return
        }
        
        playButtonSound()
        
        if (op == .MemRcl) {
            if(currOp != .NoOp ) {
                leftSideStr = memoryVal
                runningNumberStr = memoryVal
                lblTotal.text = leftSideStr
            } else {
                rightSideStr = memoryVal
                runningNumberStr = memoryVal
                lblTotal.text = rightSideStr
            }
        } else if (op == .MemClr) {
            memoryVal = "0"
        } else if (op == .MemAdd) {
            memoryVal = "\(Double(memoryVal)! + Double(lblTotal.text!)!)"
        } else if (op == .MemSub) {
            memoryVal = "\(Double(memoryVal)! - Double(lblTotal.text!)!)"
        } else {
            print("Unknown Operation in processMemoryOperation!")
        }
        runningNumberStr = "0"
    }
    
    
    /*
        clear the value from the memory register
    */
    @IBAction func btnMemoryClear(btn: UIButton) {
        processMemoryOperation(.MemClr)
    }
    
    /*
        add a value to the current memory register
    */
    @IBAction func btnMemoryAdd(btn: UIButton) {
        processMemoryOperation(.MemAdd)
    }
    
    /*
        subtract a value from the current memory register
    */
    @IBAction func btnMemorySubtract(btn: UIButton) {
        processMemoryOperation(.MemSub)
    }
    
    /*
        replace the value in the display with value from the memory register
    */
    @IBAction func btnMemoryRecall(btn: UIButton) {
        processMemoryOperation(.MemRcl)
    }


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
            runningNumberStr = "0"
        } else if (onStateClickCount == 1) { //clear the current value only
            //inc and set to zero in ones

            onStateClickCount = 2 //one more to turn off
            lblTotal.text = "0"
            runningNumberStr = "0"
            rightSideStr = "0"
        } else {
            //turn off
            onStateClickCount = 0
            onState = false
            runningNumberStr = "0"
            leftSideStr = "0"
            rightSideStr = "0"
            lblTotal.text = "0"
            memoryVal = "0"
        }
    }

    
    
    
    //MARK: Enums
    /*
        One enum for each non-numeric button.
        Note that with the video example, the Equals was 
            suppressed as not needed. I found that you need it 
            when you click the = button to get an answer.
    */
    enum NumericOperation {
        case Plus
        case Minus
        case Times
        case DividedBy
        case Percent
        case Equals
        case NoOp
        case MemClr
        case MemAdd
        case MemSub
        case MemRcl
    }
    
    
    
    //MARK:Utility
    
    /*
        Pre:
            a. the AVAudioPlayer is set up
            b. a sound may or may not already be playiing
        Post:
            only one sound is playing
    
        Notes:
            we do this because quick clicks may result in 
            choppy button click sounds
    */
    func playButtonSound() {
        if(btnSound.playing) {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    
    //MARK: Overrides

    /*
        Pre:
            the view elements are loaded
        Post:
            labels, sounds, other use interface
            elements are set up
    */
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
    
    
}