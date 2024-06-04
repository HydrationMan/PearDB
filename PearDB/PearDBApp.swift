//
//  PearDBApp.swift
//  PearDB
//
//  Created by Kane Parkinson on 06/05/2024.
//

import SwiftUI
import SwiftTipJar

@main
struct PearDBApp: App {
    let persistenceController = PersistenceController.shared
    let tipJar: SwiftTipJar
    init() {
        tipJar = SwiftTipJar(tipsIdentifiers: Set([
            "com.hydrate.iap.SmallTip",
            "com.hydrate.iap.MediumTip",
            "com.hydrate.iap.LargeTip",
            "com.hydrate.iap.HugeTip"
        ]))
        tipJar.startObservingPaymentQueue()
        tipJar.productsRequest?.start()
    }
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(tipJar)
        }
    }
}
