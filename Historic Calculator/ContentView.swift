//
//  ContentView.swift
//  Historic Calculator
//
//  Created by Lorenzo Llamas on 9/27/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //Handling arithmetic from buttons pressed
    //The @StateObject property wrapper indicates that this instance of CalculatorViewModel is the source of truth for your ContentView
    @StateObject private var viewModel = CalculatorViewModel()
//    @ObservedObject var viewModel: CalculatorViewModel()

    
    // Create a state property to track the current color index
    @State private var currentColorIndex = 0
    
    var body: some View {
        VStack(spacing: 20) {
            //Color Cycle Button
            Button(action: {
                self.currentColorIndex = (self.currentColorIndex + 1) % self.colors.count
            }) {
                Text("Cycle Color")
                    .padding()
                    .background(colors[currentColorIndex])
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            // Display
            Text(String(viewModel.result))
                .font(.largeTitle)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .lineLimit(1)
            
            // Buttons Grid
            buttonGrid
        }
        .padding()
    }

    private func bindingForColor(_ index: Int) -> Binding<Color> {
            Binding<Color>(
                get: {
                    // Get the color based on the current index
                    return self.colors[self.currentColorIndex]
                },
                set: { _ in }
            )
        }
    let turquoise = Color.init(UIColor(red: 0.18, green:0.84, blue:0.78, alpha: 1))
    let colors = [Color.black, Color.blue, Color.red, Color.green,
        Color.purple,
        Color.init(UIColor(red: 0.18, green:0.84, blue:0.78, alpha: 1))]

}

extension ContentView {
    func clearButton() -> some View {
        Button(action: {
            viewModel.clear()
        }) {
            Text("C")
                .frame(width: 77, height: 85)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    func currentEquation() -> some View {
        Text(viewModel.displayValue)
            .frame(width: 275, height: 85)
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
    var buttonGrid: some View {
        VStack(spacing: 10) {
            HStack(){
                clearButton().frame(maxWidth: .infinity, alignment: .leading)
                currentEquation()
            }
            //calculatorButton(label: "C").cornerRadius(2)
            HStack(spacing: 20) {
                calculatorButton(label: "7")
                calculatorButton(label: "8")
                calculatorButton(label: "9")
                calculatorButton(label: "/")
            }
            HStack(spacing: 20) {
                calculatorButton(label: "4")
                calculatorButton(label: "5")
                calculatorButton(label: "6")
                calculatorButton(label: "*")
            }
            HStack(spacing: 20) {
                calculatorButton(label: "1")
                calculatorButton(label: "2")
                calculatorButton(label: "3")
                calculatorButton(label: "-")
            }
            HStack(spacing: 20) {
                calculatorButton(label: "0")
                calculatorButton(label: ".")
                calculatorButton(label: "+")
                calculatorButton(label: "=")
            }
            //  can continue adding more HStacks for other functions like square, root, etc.
        }
    }
    
    func calculatorButton(label: String) -> some View {
        Button(action: {
//            viewModel.handle
            switch label {
            case "0"..."9":
                viewModel.handleNumberButton(label)
            case ".":
                viewModel.handleNumberButton(label)
//            case ".":
//                viewModel.decimalPointPressed()
            case "+":
                viewModel.handleOperationButton(label)
            case "-":
                viewModel.handleOperationButton(label)
            case "*":
                viewModel.handleOperationButton(label)
            case "/":
                viewModel.handleOperationButton(label)
            case "=":
                viewModel.handleEqualButton()
            case "C":
                viewModel.clear()
            default:
                break
            }
        }) {
            Text(label)
                .frame(width: 75, height: 75)
                .background(colors[currentColorIndex])
                .foregroundColor(.white)
                .cornerRadius(35)
        }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
