//
//  ViewController.swift
//  Calculator
//
//  Created by 计 炜 on 2017/6/5.
//  Copyright © 2017年 计 炜. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(symbol: operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
            
        }
//        switch operate {
//        case "×":
//            performOperation { $0 * $1 }
//        case "÷":
//            performOperation { $1 / $0 }
//        case "+":
//            performOperation { $0 + $1 }
//        case "−":
//            performOperation { $1 - $0 }
//        case "√":
//            performOperation { sqrt($0) }
//            
//        default:
//            break
//        }
    }
    
//    @objc(performOperationWithTwoOperand:) func performOperation(operation: (Double, Double) -> Double) {
//        if operandStack.count >= 2 {
//            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter()
//        }
//    }
//    
//    @objc(performOperationWithOneOperand:) func performOperation(operation: (Double) -> Double) {
//        if operandStack.count >= 1 {
//            displayValue = operation(operandStack.removeLast())
//            enter()
//        }
//    }
    
//    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
//        operandStack.append(displayValue)
//        print("operandStack = \(operandStack)")
        if let result = brain.pushOperand(operand: displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }

    var displayValue: Double {
        get {
            //return Double(display.text!)!
            let num = NumberFormatter()
            return num.number(from: display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

}

