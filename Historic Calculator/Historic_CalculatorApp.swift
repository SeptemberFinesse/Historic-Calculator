//
//  Historic_CalculatorApp.swift
//  Historic Calculator
//
//  Created by Lorenzo Llamas on 9/27/23.
//

import SwiftUI

@main
struct Historic_CalculatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
