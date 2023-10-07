
import Foundation


class CalculatorViewModel: ObservableObject {
    // Published properties
    struct Grouping {
        var value: String = ""
        var hasDecimal: Bool = false
        var rawInput: String = ""
    }
    enum LastInputType {
        case number, operation
    }
    @Published var currentGrouping = Grouping()
    @Published var operationsAndGroupings: [String] = []  // This will store alternating operations and groupings.
    @Published var displayValue: String = ""
    @Published var history: [String: String] = [:]  // Key: Raw input, Value: Result
    @Published var result: String = ""  // This will display the final
    @Published var lastInputType: LastInputType = .number  // Default it to .number since calculator starts with a number
    @Published var equalResult: Int = 0
//    @Published var history: [String] = []
    @Published var arithmeticExpression: String = ""

//    @Published var currentEquation: String = ""
    
    // Private properties
    private var equalsPressedFlag: Bool = false

    @Published var currentNumber: Int? = nil
    @Published var previousNumber: Int? = nil
    @Published var selectedOperation: Operation? = nil
    
    // Enum to represent the different operations
    enum Operation {
        case add, subtract, multiply, divide, none
    }
}

extension CalculatorViewModel {
    func handleNumberButton(_ number: String) {
        // If the last input was a number or it's the start, then we can add more numbers
//        if lastInputType == .number || operationsAndGroupings.isEmpty {
        if lastInputType == .number || lastInputType == .operation {
            // Only allow one decimal point per grouping
            if number == "." && currentGrouping.hasDecimal { return }

            currentGrouping.value += number
            currentGrouping.rawInput += number
            if number == "." {
                currentGrouping.hasDecimal = true
            }

            displayValue += number
            lastInputType = .number
        }
        
    }

    func handleOperationButton(_ operation: String) {
        // Only allow an operation if the last input was a number
        if lastInputType == .number {
            // Save the current grouping
            operationsAndGroupings.append(currentGrouping.value)
            operationsAndGroupings.append(operation)
            displayValue += " " + operation + " "
            // Reset for the next grouping
            currentGrouping = Grouping()
            lastInputType = .operation
        }
        
    }

    func handleEqualButton() {
        // Add the current grouping to the list
        operationsAndGroupings.append(currentGrouping.value)

        // Evaluate
        let expression = operationsAndGroupings.joined()
        if let evaluationResult = evaluateExpression(expression) {
            result = evaluationResult
            history[expression] = evaluationResult
        }

        // Reset
        operationsAndGroupings = []
        currentGrouping = Grouping()
        lastInputType = .number  // Resetting to .number since after "=" we expect a number
        
    }
    func clear() {
        currentGrouping = Grouping()
        operationsAndGroupings = []
        displayValue = ""
        result = "0"
        lastInputType = .number
    }
}

extension CalculatorViewModel {
    func evaluateExpression(_ expression: String) -> String? {
        let nsExpression = NSExpression(format: expression)
        if let result = nsExpression.expressionValue(with: nil, context: nil) as? Double {
            return String(result)
        }
        return nil
    }
}

//extension CalculatorViewModel {
//    // Number button pressed
////    func numberPressed(_ value: String) {
////        if equalsPressedFlag {
////            clear()
////            equalsPressedFlag = false
////        }
////        if let number = Int(value) {
////            if selectedOperation == nil {
////                currentNumber = currentNumber == nil ? number : currentNumber! * 10 + number
////            } else {
////                // If an operation is selected, reset the calculator's state
//////                clear()
////                currentNumber = number
////            }
////            equalResult = currentNumber!
//////            print(formatNumber(equalResult, decimalPlaces: 2))
////        }
////        arithmeticExpression += value
////    }
//
//    func decimalPointPressed() {
//        if !arithmeticExpression.contains(".") {
//                arithmeticExpression += "."
//            }
//        print(arithmeticExpression)
//    }
//    func formatNumber(_ number: Double, decimalPlaces: Int) -> String {
//        return String(format: "%.\(decimalPlaces)f", number)
//    }
//
//
//    // Operation button pressed
//    func operationPressed(_ operation: Operation) {
//        if equalsPressedFlag {
//            clear()
//            equalsPressedFlag = false
//        }
//        // Only store the selected operation and the current number
//        previousNumber = currentNumber
//        currentNumber = nil
//        selectedOperation = operation
//        switch operation {
//            case .add:
//                arithmeticExpression += " + "
//            case .subtract:
//                arithmeticExpression += " - "
//            case .multiply:
//                arithmeticExpression += " x "
//            case .divide:
//                arithmeticExpression += " / "
//            default:
//                break
//            }
//    }
//
//    // Equals button pressed
//    func equalsPressed() {
//        if let previous = previousNumber, let current = currentNumber, let operation = selectedOperation {
//            switch operation {
//            case .add:
//                equalResult = previous + current
//            case .subtract:
//                equalResult = previous - current
//            case .multiply:
//                equalResult = previous * current
//            case .divide:
//                equalResult = current != 0 ? previous / current : Int.zero//: Double.nan
//            default:
//                break
//            }
//
//            addToHistory(operation: operation, result: equalResult)
//            print(history)
//            previousNumber = equalResult
//            currentNumber = nil
//            selectedOperation = nil
//
//            print(String(format: "%.\(2)f", equalResult))
//        }
//        equalsPressedFlag = true
//        print(String(format: "%.\(2)f", equalResult))
////        print(formatNumber(equalResult, decimalPlaces: 2))
//        //thisVar = equalResult
//        //after hitting "=," store thisVar and continue to do the operations
//
////        arithmeticExpression = String(equalResult)
//    }
//
//    // Add to history
//    func addToHistory(operation: Operation, result: Int) {
//        var operationSymbol: String
//        switch operation {
//        case .add:
//            operationSymbol = "+"
//        case .subtract:
//            operationSymbol = "-"
//        case .multiply:
//            operationSymbol = "x"
//        case .divide:
//            operationSymbol = "/"
//        default:
//            operationSymbol = ""
//        }
//
////        history.append("\(previousNumber ?? 0) \(operationSymbol) \(currentNumber ?? 0) = \(result)")
//        print(history)
//    }
    
    // Clear or reset the calculator
    
