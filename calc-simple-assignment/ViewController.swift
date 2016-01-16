//
//  ViewController.swift
//  calc-simple-assignment
//
//  Created by Anthony Torrero Collins on 1/8/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

/*
    This calculator was created as part of the Udemy.com course, 
    "iOS 9 and Swift 2: From Beginner to Paid Professional," by 
    Mark Price, lectures 40-41.

    I chose to implement a traditional 10-key desk calculator with
    the following features:

        Combination On/Clear/Off button
        Added a decimal.
        5 numeric operations (add, subtract, divide, multiply, and percent)
        Four single-register memory keys (clear, add to, subtract from, and recall).

    Some limitations.
        
        The LCD does not respond perfectly to overrange. It appends '...' to numbers 
        that are too large (or small) for the display.

        I played around with the autolayout for quite a while. I wanted it to grow or 
        shrink to a percentage of the host device. I was unsuccessful with that, and 
        I ended up having to use fixed values for some elements to ensure alignment 
        and position.
*/

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //MARK: Local Variables
    var btnSound :AVAudioPlayer!        //When a button is pressed
    var runningNumberStr: String = "0"  //Always reflects the display during number entry. Cleared on +, -, /, *, =, and any mem button
    var leftSideStr: String = "0"       //Contains the display value after operator entry. Cleared on =
    var rightSideStr: String = "0"      //Contains the value in numeric display after 2nd/subsequent operator entry. Cleared on =
    var currOp: NumericOperation = .NoOp   //Contains the earlier queued operator
    var onState: Bool = false              //True iff the calculator is on
    var onStateClickCount: Int = 0      //The number of times the On/Clear button has been clicked
    var memoryVal: String = "0"         //The value in calc memory

    //MARK: Outlets
    @IBOutlet weak var lblTotal: UILabel!
    
    //MARK: Numeric Operations
    /*
        Pre:
            The calculator is ON.
            A number button has been pressed.
        Post:
            Update the display and the running number with
             the added digit.
    */
    @IBAction func numberButtonPressed(btn: UIButton) {

        guard(onState)
            else {
                return
        }
        
        playButtonSound()
        
//        if((runningNumberStr == "0") || (runningNumberStr == "0.0")) {
        if(runningNumberStr == "0") {
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
            The calculator is ON.
            One of +, -, x, \u{00F7}, % is pressed.
        Post
            Complete any right-hand calculations,
            Put the result in the left-hand register,
             and reset the right-hand register.
            Also, if this is not '=', set the currOp value.
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
        }
        
        lblTotal.text = result
        rightSideStr = "0"
        leftSideStr = result
        
        if(op != .Equals) {
            currOp = op
        } else {
           // keep the currOp as is
        }
        
        return
    }
    
    
    //MARK: Button Actions
    /* 
        Note that in order to make the equals button work with an immediate
        operator after (such as '1+5=*4=' ... I moved some of the logic
        from processNumericOp into the actions. Some duplication, but 
        it made it simpler to follow the code.
    */
    
    
    /*
        If there is a calculation queued,
        complete the calculation, 
        and reset the right-hand register.
        Otherwise, just stop the running input and
        set the leftSideStr for a future calculation.
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
            //currOp is never set to .Equals
        }
        
        return
    }

    /*
        Start an add operation.
        Complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register.
        Otherwise, just stop the running input,
        set the leftSideStr for a future calculation, 
        and set the currOp value.
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
        
        return
    }

    /*
        Start a percent operation.
        Complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register.
        Otherwise, just stop the running input,
        set the leftSideStr for a future calculation,
        and set the currOp value.
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
        
        return
    }
    
    /*
        Start a multiply operation.
        Complete any right-hand calculations,
        Put the result in the left-hand register,
        and reset the right-hand register.
        Otherwise, just stop the running input,
        set the leftSideStr for a future calculation,
        and set the currOp value.
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
        
        return
    }
    
    /*
        Start a divide operation.
        Complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register.
        Otherwise, just stop the running input,
        set the leftSideStr for a future calculation,
        and set the currOp value.
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
        
        return
    }
    
    /*
        Start a subtract operation.
        Complete any right-hand calculations,
        put the result in the left-hand register,
        and reset the right-hand register.
        Otherwise, just stop the running input,
        set the leftSideStr for a future calculation,
        and set the currOp value.
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
        
        return
    }

    /*
        Pre:
            The label may or may not have a value
        Post:
            The lable has whatever its current value is, with the terminating decimal.
            If the value is zero, the display is '0.'
        Notes:
            Invoke the decimal.
            This effectively places a decimal inline.
            The number buttons are run on the Tag property, which is only an integer value.
    */
    @IBAction func btnDecimal_Press(btn:UIButton) {
        
        playButtonSound()

//        if((runningNumberStr == "0") || (runningNumberStr == "0.0")) {
        
        if(runningNumberStr == "0") {
            runningNumberStr = "0."
        } else if (!runningNumberStr.containsString(".")) {
            runningNumberStr += "."
        }
        
        lblTotal.text = runningNumberStr
        onStateClickCount = 1
        
        return
    }

    
    //MARK: Power and Memory Buttons
    
    /* 
        Pre:
            The calculator is ON
            One of the four memory buttons has been pressed
        Post:
            The appropriate memory operation is complete
    */
    func processMemoryOperation(op: NumericOperation) {
        
        guard(onState)
            else {
                return
        }
        
        playButtonSound()
        
        if (op == .MemRcl) {
            runningNumberStr = memoryVal
            leftSideStr = lblTotal.text!
            lblTotal.text = memoryVal
            //skip setting runningNumberString to 0 if
            // the recall is done right after an operator
            if(currOp != .NoOp ) {
                return
           }
            
        } else if (op == .MemClr) {
            memoryVal = "0"
        } else if (op == .MemAdd) {
            memoryVal = "\(Double(memoryVal)! + Double(lblTotal.text!)!)"
        } else if (op == .MemSub) {
            memoryVal = "\(Double(memoryVal)! - Double(lblTotal.text!)!)"
        }
        
        runningNumberStr = "0"
        
        return
    }
    
    
    //MARK: Memory Button Actions
    /*
        Clear the value from the memory register.
    */
    @IBAction func btnMemoryClear(btn: UIButton) {
        processMemoryOperation(.MemClr)
        
        return
    }
    
    /*
        Add a value to the current memory register.
    */
    @IBAction func btnMemoryAdd(btn: UIButton) {
        processMemoryOperation(.MemAdd)
        
        return
    }
    
    /*
        Subtract a value from the current memory register.
    */
    @IBAction func btnMemorySubtract(btn: UIButton) {
        processMemoryOperation(.MemSub)
        
        return
    }
    
    /*
        Replace the value in the display with value from the memory register.
    */
    @IBAction func btnMemoryRecall(btn: UIButton) {
        processMemoryOperation(.MemRcl)
        
        return
    }


    /*
        Turn the calculator on and off.
        Also used to clear the current values.
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
        } else { //turn off
            onStateClickCount = 0
            onState = false
            runningNumberStr = "0"
            leftSideStr = "0"
            rightSideStr = "0"
            lblTotal.text = "0"
            memoryVal = "0"
        }
        
        return
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
            a. The AVAudioPlayer is set up
            b. A sound may or may not already be playiing
        Post:
            Only one sound is playing
    
        Notes:
            We do this because quick clicks may result in
            choppy button click sounds.
    */
    func playButtonSound() {
        if(btnSound.playing) {
            btnSound.stop()
        }
        
        btnSound.play()
        
        return
    }
    
    
    //MARK: Overrides

    /*
        Pre:
            The view elements are loaded
        Post:
            Labels, sounds, other use interface
            elements are set up.
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
        
        
        return
    }
    
    
}