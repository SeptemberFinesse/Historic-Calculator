//
//  ContentView.swift
//  Historic Calculator
//
//  Created by Lorenzo Llamas on 9/27/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



//
//    func numberButton(_ label: String) -> some View {
//        Button(action: {
//            viewModel.numberPressed(label)
//        }) {
//            Text(label)
//                .frame(width: 70, height: 70)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(35)
//        }
//    }
//    func operationButton(_ symbol: String) -> some View {
//        Button(action: {
//            switch symbol {
//            case "+":
//                viewModel.operationPressed(.add)
//            case "-":
//                viewModel.operationPressed(.subtract)
//            case "x":
//                viewModel.operationPressed(.multiply)
//            case "/":
//                viewModel.operationPressed(.divide)
//            default:
//                break
//            }
//        }) {
//            Text(symbol)
//                .frame(width: 100, height: 70)
//                .background(Color.orange)
//                .foregroundColor(.white)
//                .cornerRadius(35)
//        }
//    }



//
extension CalculatorViewModel {
    // Number button pressed
    func numberPressed(_ value: String) {
        if let number = Double(value) {
            if equalResult == 0 || (selectedOperation != nil && currentNumber == nil) {
                currentNumber = number
            } else {
                currentNumber = currentNumber! * 10 + number
            }
            equalResult = currentNumber!
            print(equalResult)
        }
    }
    
    // Operation button pressed
    func operationPressed(_ operation: Operation) {
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
            previousNumber = equalResult
            currentNumber = nil
            selectedOperation = nil
        } else {
            previousNumber = currentNumber
            currentNumber = nil
            selectedOperation = operation
        }
    }
    
    // Equals button pressed
    func equalsPressed() {
        operationPressed(selectedOperation ?? .none)
    }
