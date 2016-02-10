//
//  ViewController.swift
//  Calculator
//
//  Created by Xamarin on 2/10/16.
//  Copyright © 2016 Ces. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    @IBAction func appendDIgit(sender: UIButton) {
        let digit = sender.currentTitle! // let declares a constant, will not change after assigned
        //print("digit = \(digit)")
        
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        
    }

    @IBAction func operate(sender: UIButton) {
        
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        switch operation {
            case "×": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−": performOperation { $1 - $0 }
            case "√": performOperation { sqrt($0)}
            default: break
        }
        
    }
    
    private func performOperation(operation: (Double, Double) -> Double){
        
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
        
    }
    
    private func performOperation(op: (Double) -> Double){
        if operandStack.count >= 1 {
            displayValue = op(operandStack.removeLast())
            enter()
        }
    }
    
    /*
    func multiply(op1: Double, op2:Double) -> Double {
        return op1 * op2
    }*/
    
    
    var operandStack: Array<Double> = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}



