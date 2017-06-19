//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 计 炜 on 2017/6/7.
//  Copyright © 2017年 计 炜. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperand(String, (Double) -> Double)
        case BinaryOperand(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperand(let symbol, _):
                    return symbol
                case .BinaryOperand(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(op: Op.BinaryOperand("×", *))
        learnOp(op: Op.BinaryOperand("÷") { $1 / $0 })
        learnOp(op: Op.BinaryOperand("+", +))
        learnOp(op: Op.BinaryOperand("−") { $1 - $0 })
        learnOp(op: Op.UnaryOperand("√", sqrt))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperand(_, let operation):
                let operandEvaluation = evaluate(ops: remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
                
            case .BinaryOperand(_, let operation):
                let op1Evaluation = evaluate(ops: remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(ops: op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil, ops)
    }
    

    func evaluate() -> Double? {
        let (result, remainder) = evaluate(ops: opStack)
        print("\(opStack) - \(String(describing: result)) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
