//
//  AppleDBView.swift
//  PearDB
//
//  Created by Kane Parkinson on 12/05/2024.
//
import SwiftUI
import CoreData

struct AppleDBView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.device, ascending: true)],animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var showingAddDeviceAlert = false
    @State private var deviceModel = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Model Number: \(item.device!)")
                    } label: {
                        Text(item.device!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        showingAddDeviceAlert = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .alert("Add Device", isPresented: $showingAddDeviceAlert) {
                Button("Save") {
                        addItem()
                    }
                Button("Cancel", role: .cancel, action: {})
                TextField("Device Model", text: $deviceModel)
            }
        }
        .navigationTitle("AppleDB")
    }

        private func addItem() {
        self.deviceModel = deviceModel
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.device = deviceModel

            do {
                try viewContext.save()
            } catch {
                // No, i wont catch the error properly :trolley:
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
                // No, i wont catch the error properly :trolley:
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

