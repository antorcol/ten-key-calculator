//
//  Comments-and-scratch.swift
//  calc-simple-assignment
//
//  Created by Anthony Torrero Collins on 1/10/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

// if zero in display, pressing 0 and then another number enables leading zero

//import Foundation

/*


/*
Calculation error, set all digits to '-;
*/
func setError() {
lblTotal.text = "-----"
}


/*
Check bounds of number -- incoming or outgoing
*/
func validateNumber(whichNum:Double) -> Bool {
guard(onState)
else {
return false
}

guard (!whichNum.isNaN)
else {
return false
}



return true
}


//NOTE: These could all be one closure, I think
/*
Each operation should:
get the displayed value
combine the new value with the previous running total into a subtotal
set the subtotal to 0.0
set the display to 0.0
set the curTotal to 0.0

On equals
make the final subTotal calculation
make the final curTotal value from subTotal and the accumulator
set accumulator to 0.0
set subTotal to 0.0
display the curTotal
*/

//MARK: Power and Memory Buttons

@IBAction func btnOnOffClear(sender: UIButton) {

if(!onState) {
lblTotal.text = "0.0"
onStateClickCount++
onState = true
} else if (onStateClickCount == 1) {
//inc and set to zero in ones
onStateClickCount++
lblTotal.text = "0.0"
accumulator = 0.0
} else {
//turn off
onStateClickCount = 0
onState = false
reset()
}
}

@IBAction func btnMemoryClear(sender: UIButton) {
memoryVal = 0.0
print(memoryVal)
}

@IBAction func btnMemoryAdd(sender: UIButton) {
guard (!lblTotal.text!.isEmpty)
else {
return
}

guard let tmpVal = Double(lblTotal.text!)
else {
return
}

memoryVal += tmpVal
print(memoryVal)
}

@IBAction func btnMemorySubtract(sender: UIButton) {
guard (!lblTotal.text!.isEmpty)
else {
return
}

guard let tmpVal = Double(lblTotal.text!)
else {
return
}

memoryVal -= tmpVal
print(memoryVal)
}

@IBAction func btnMemoryRecall(sender: UIButton) {

setLCDToNumber(memoryVal)
currTotal = memoryVal
}



//        guard onState
//            else {
//                return
//        }

//        guard validateNumber(whichNum)
//            else {
////                setError()
//                return
//        }



func reset() {
lblTotal.text = ""
currTotal = 0.0
accumulator = 0.0
}


/*
If the value of the label can be converted to a Double,
return true and the Double. Otherwise, return false and -1.0
*/
func validateStringDouble(theLbl: UILabel?) -> (Bool, Double) {

let tmpStr:String? = theLbl!.text

var retVal = (false, -1.0)

guard (!tmpStr!.isEmpty)
else {
return retVal
}

guard let rTot = Double(tmpStr!)
else {
return retVal
}

accumulator = rTot

retVal = (true, accumulator)
return retVal
}

guard let currValueStr = lblTotal.text
else {
print("text is nil")
return
}

guard !currValueStr.isEmpty
else {
print("text is '' ")
return
}

guard let currValueDbl = Double(currValueStr)
else {
print("text is not a double")
return
}

if(currValueDbl == 0.0) {
lblTotal.text = String(sender.tag)
} else {
if(currOp != .NoOp) {
lblTotal.text?.appendContentsOf(String(sender.tag))
}
}

var onState: Bool = true       //is the calculator on?
var onStateClickCount: Int = 0  //one button both turns on/off and clears - I see why on/clear and off are more common
var subTotal: Double = 0.0      //the value of one calculation among a number of calcs
var memoryVal: Double = 0.0     //the value in calc memory


/*
Set the digital display to a double number
*/
func setLCDToNumber(whichNum:Double) {

lblTotal.text = String(whichNum);
}


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

@IBOutlet weak var lblTotal: UILabel!

//MARK: Properties
var runningNumberStr: String = ""  //the value of all calculations before displaying currTotal
var leftSideStr: String = ""
var rightSideStr: String = ""
var subTotalStr: String = ""

var currOp: MyOps = .NoOp       //enum holding the current operation
var btnSound :AVAudioPlayer!         //when a button is pressed

//MARK: Loading Funcs
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


//text setup
lblTotal.text = runningNumberStr

}


//MARK: Number Buttons
/*
when a number button is pressed
if the current operator is .noOp
if the total is not zero
append the number
otherwise
replace the zero
otherwise
put the current value into left side
*/
@IBAction func buttonPressed(sender: UIButton) {
playButtonSound()

if (currOp == .NoOp) {

if(runningNumberStr != "0") {
runningNumberStr += "\(sender.tag)"
} else {
runningNumberStr = "\(sender.tag)"
}
} else {
leftSideStr = runningNumberStr
runningNumberStr = "\(sender.tag)"
}

lblTotal.text = runningNumberStr
}


/*
An operator has been pressed.
If the operator is equals
apply the current operator with the left and right sides
display the total
set runningNumberStr
clear the operator
othewise
replace the current operator
set subTotal

*/
func doOperation (op:MyOps) {


playButtonSound()

if(currOp == .Equals) {
guard (!leftSideStr.isEmpty && leftSideStr != "")
else {
return
}
}

if(currOp != .NoOp) {

rightSideStr = runningNumberStr
runningNumberStr = ""

if(currOp == .Plus) {
subTotalStr = "\(Double(leftSideStr)! + Double(rightSideStr)!)"
} else if (currOp == .Minus) {
subTotalStr = "\(Double(leftSideStr)! - Double(rightSideStr)!)"
} else if (currOp == .Times) {
subTotalStr = "\(Double(leftSideStr)! * Double(rightSideStr)!)"
} else if (currOp == .DividedBy) {
subTotalStr = "\(Double(leftSideStr)! / Double(rightSideStr)!)"
}

leftSideStr = subTotalStr
lblTotal.text = leftSideStr

} else {
leftSideStr = runningNumberStr
print("NoOp")  //temp
runningNumberStr = ""
}

currOp = op
}





//MARK: Operations
@IBAction func btnEquals(sender: UIButton) {
doOperation(currOp)
}

@IBAction func btnAdd(sender: UIButton) {
doOperation(.Plus)
}

@IBAction func btnPercent(sender: UIButton) {
doOperation(.Percent)
}

@IBAction func btnMultiply(sender: UIButton) {
doOperation(.Times)
}

@IBAction func btnDivide(sender: UIButton) {
doOperation(.DividedBy)
}

@IBAction func btnSubtract(sender: UIButton) {
doOperation(.Minus)
}





//MARK: Operation Enum
enum MyOps {
case Plus
case Minus
case Times
case DividedBy
case Percent
case Equals
case NoOp
}

func playButtonSound() {
if(btnSound.playing) {
btnSound.stop()
}

btnSound.play()

}



}


*/