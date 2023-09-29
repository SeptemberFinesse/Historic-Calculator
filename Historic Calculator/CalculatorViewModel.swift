import Foundation

class CalculatorViewModel: ObservableObject {
    // Published properties
    
    @Published var equalResult: Double = 0.0
    @Published var history: [String] = []
    @Published var arithmeticExpression: String = ""

//    @Published var currentEquation: String = ""
    
    // Private properties
    private var equalsPressedFlag: Bool = false

    @Published var currentNumber: Double? = nil
    @Published var previousNumber: Double? = nil
    @Published var selectedOperation: Operation? = nil
    
    // Enum to represent the different operations
    enum Operation {
        case add, subtract, multiply, divide, none
    }
}

extension CalculatorViewModel {
    // Number button pressed
    func numberPressed(_ value: String) {
        if equalsPressedFlag {
            clear()
            equalsPressedFlag = false
        }
        if let number = Double(value) {
            if selectedOperation == nil {
                currentNumber = currentNumber == nil ? number : currentNumber! * 10 + number
            } else {
                // If an operation is selected, reset the calculator's state
//                clear()
                currentNumber = number
            }
            equalResult = currentNumber!
            print(formatNumber(equalResult, decimalPlaces: 2))
        }
        arithmeticExpression += value
    }
    func formatNumber(_ number: Double, decimalPlaces: Int) -> String {
        return String(format: "%.\(decimalPlaces)f", number)
    }
    
    
    // Operation button pressed
    func operationPressed(_ operation: Operation) {
        if equalsPressedFlag {
            clear()
            equalsPressedFlag = false
        }
        // Only store the selected operation and the current number
        previousNumber = currentNumber
        currentNumber = nil
        selectedOperation = operation
        switch operation {
            case .add:
                arithmeticExpression += " + "
            case .subtract:
                arithmeticExpression += " - "
            case .multiply:
                arithmeticExpression += " x "
            case .divide:
                arithmeticExpression += " / "
            default:
                break
            }
    }
    
    // Equals button pressed
    func equalsPressed() {
        if let previous = previousNumber, let current = currentNumber, let operation = selectedOperation {
            switch operation {
            case .add:
                equalResult = previous + current
            case .subtract:
                equalResult = previous - current
            case .multiply:
                equalResult = previous * current
            case .divide:
                equalResult = current != 0 ? previous / current : Double.nan
            default:
                break
            }
            
            addToHistory(operation: operation, result: equalResult)
            print(history)
            previousNumber = equalResult
            currentNumber = nil
            selectedOperation = nil
            print(formatNumber(equalResult, decimalPlaces: 2))
        }
        equalsPressedFlag = true
        print(formatNumber(equalResult, decimalPlaces: 2))
        //thisVar = equalResult
        //after hitting "=," store thisVar and continue to do the operations
        
//        arithmeticExpression = String(equalResult)
    }
    
    // Add to history
    func addToHistory(operation: Operation, result: Double) {
        var operationSymbol: String
        switch operation {
        case .add:
            operationSymbol = "+"
        case .subtract:
            operationSymbol = "-"
        case .multiply:
            operationSymbol = "x"
        case .divide:
            operationSymbol = "/"
        default:
            operationSymbol = ""
        }
        
        history.append("\(previousNumber ?? 0) \(operationSymbol) \(currentNumber ?? 0) = \(result)")
        print(history)
    }
    
    // Clear or reset the calculator
    func clear() {
        equalResult = 0.0
        currentNumber = nil
        previousNumber = nil
        selectedOperation = nil
        arithmeticExpression = ""
    }
}
