//
//  ContentView.swift
//  PearDB
//
//  Created by Kane Parkinson on 30/07/2024.
//

import SwiftUI

struct ContentView: View {
//    @State private var isShowingNewHardware = false
    @State private var hardwareToEdit: Hardware?
    @FetchRequest(fetchRequest: Hardware.all()) private var hardware

    var provider = HardwareProvider.shared
    var body: some View {
        NavigationStack {
            ZStack {
                if hardware.isEmpty {
                    NoHardwareView()
                } else {
                    List {
                        Text("To edit devices, swipe on the row!")
                            .multilineTextAlignment(.center)
                        ForEach(hardware) { hardware in
                            ZStack(alignment: .leading) {
                                let viewModel = EditHardwareViewModel(provider: provider, hardware: hardware)
                                NavigationLink(destination: HardwareDetailView(vm: viewModel, hardware: hardware)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                HardwareRowView(hardware: hardware)
                                    .swipeActions(allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            do {
                                                try delete(hardware)
                                            } catch {
                                                print(error)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }.tint(.red)
                                        Button {
                                            hardwareToEdit = hardware
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        hardwareToEdit = .empty(context: provider.newContext)
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                    }
                }
            }
            .sheet(item: $hardwareToEdit,
                   onDismiss: {
                hardwareToEdit = nil
            }, content: { hardware in
                NavigationStack {
                    CreateHardwareView(vm: .init(provider: provider, hardware: hardware))
                }
            })
            .navigationTitle("Devices")
        }
    }
}

private extension ContentView {
    func delete(_ hardware: Hardware) throws {
        let context = provider.viewContext
        let existingHardware = try context.existingObject(with: hardware.objectID)
        context.delete(existingHardware)
        Task(priority: .background) {
            try await context.perform {
                try context.save()
            }
        }
    }
}
