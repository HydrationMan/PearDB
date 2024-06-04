//
//  SupportViaKoFi.swift
//  PearDB
//
//  Created by Kane Parkinson on 13/05/2024.
//

import SwiftUI
import SwiftTipJar


struct SupportPearDB: View {
    @EnvironmentObject var tipJar: SwiftTipJar
    @State private var showingThankYou = false
    @State private var tipPending = true
    
    var body: some View {
         List {
             Section(header: Text("Available Tips")) {
                 ForEach(tipJar.tips, id:\.identifier) { tip in
                     Button {
                         tipJar.initiatePurchase(productIdentifier: tip.identifier)
                     } label: {
                         Text("\(tip.displayName) \(tip.displayPrice)")
                     }
                 }

             }
             Section(header: Text("Tip Status")) {
                 if (tipPending == true) {
                     Text("Pending Tip...")
                         .bold()
                 } else {
                     Text("Thank you! Tip Submitted Successfully!")
                         .bold()
                         .opacity(showingThankYou ? 1 : 0)
                 }
             }

         }
         .onAppear {
             tipJar.transactionSuccessfulBlock = {
                 // Will be called from background, but manipulates UI - has to run on main queue
                 DispatchQueue.main.async {
                     self.showingThankYou = true
                     self.tipPending = false
                 }
             }
             tipJar.transactionFailedBlock = {
                 // No need to do anything, user did tap cancel
             }
         }
         .padding(24)
     }
 }


#Preview {
    SupportPearDB()
}
