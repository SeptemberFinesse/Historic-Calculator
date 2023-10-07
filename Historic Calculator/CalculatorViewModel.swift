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
    func handleNumberButton(_ button: String) {
        if equalsPressedFlag {
            clear()
            equalsPressedFlag = false
        }
        // If the last input was a number or it's the start, then we can add more numbers
//        if lastInputType == .number || operationsAndGroupings.isEmpty {
        
        if button == "." && currentGrouping.rawInput.contains(".") { return }
        if button == "." {
//            currentGrouping.rawInput += button
//            currentGrouping.value += button
            handleDecimalButton(button)
//            displayValue += button
        } else {
            handleDisplayText(button)
            lastInputType = .number
        }
//        else if lastInputType == .number || lastInputType == .operation || operationsAndGroupings.isEmpty {
//            currentGrouping.rawInput += button
//            currentGrouping.value += button
//            displayValue += button
//        }
        
    }
    func handleDisplayText(_ buttonInput: String) {
        displayValue += buttonInput
        currentGrouping.rawInput += buttonInput
        currentGrouping.value += buttonInput
        
    }
    
    func handleDecimalButton(_ button: String) {
        if lastInputType == .number {
            handleDisplayText(button)
            lastInputType = .number
        }
        if lastInputType == .operation {
            handleDisplayText("0" + button)
            lastInputType = .number
        }
//        if button == "." && currentGrouping.rawInput.contains(".") { return }
//        if currentGrouping.rawInput.contains(".") { return }
        
        
    }

    func handleOperationButton(_ operation: String) {
        equalsPressedFlag = false
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
        equalsPressedFlag = true
        // Add the current grouping to the list
        operationsAndGroupings.append(currentGrouping.value)

        // Evaluate
        let expression = operationsAndGroupings.joined()
        if let evaluationResult = evaluateExpression(expression) {
            result = evaluationResult
            history[expression] = evaluationResult
        }

        // Reset
//        operationsAndGroupings = []
        currentGrouping = Grouping()
//        displayValue = ""
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

