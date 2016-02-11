//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Xamarin on 2/10/16.
//  Copyright © 2016 Ces. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    /// Enumeration that contains a Double Operand or unary operation or Binary Operation
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UnaryOperation(let symbol, _):
                        return symbol
                    case .BinaryOperation(let symbol, _):
                        return symbol
                }
            }
        }
    }
    
    /// Stack of operations of type Op
    private var opStack = [Op]() // Other way is: Array<Op>
    
    /// Dictionary that contains known Operations KVP of String and Op
    private var knownOps = [String:Op]() // Other Way is: Dictionary<String, Op>
    
    /// Initializations
    init() {
        
        //knownOps["×"] = Op.BinaryOperation("×", *)
        
        /// Instead create a function inside a function
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") {$1 / $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 * $0})
        learnOp(Op.UnaryOperation("√", sqrt))
    }
    
    /// Recursive function that evaluates the operations stack
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
                
                case .Operand(let operand):
                    
                    return (operand, remainingOps)
                
                case .UnaryOperation(_, let operation):
                    
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                
                case .BinaryOperation(_, let operation):
                
                    let op1Evaluation = evaluate(remainingOps)
                    
                    if let operand1 = op1Evaluation.result {
                        
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
                
            }
            
        }
        
        return (nil, ops)
        
    }
    
    /// Call the evaluate recursive function and returns the result
    func evaluate() -> Double? {
        
        //let (result, remainder) = evaluate(opStack)
        let eval = evaluate(opStack)
        
        print("\(opStack) = \(eval.result) with \(eval.remainingOps) left over")
        
        return eval.result
        
    }
    
    /// Saves operand in stack
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        //sprint("\(opStack)")
        return evaluate()
    }
    
    /// Performs actual operation based on symbol
    func performOperation(symbol: String) -> Double?{
        
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        
        return evaluate()
        
    }
    
}