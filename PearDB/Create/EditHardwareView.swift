//
//  EditHardwareView.swift
//  PearDB
//
//  Created by Kane Parkinson on 29/08/2024.
//

import Foundation
import CoreData
import SwiftUI

final class EditHardwareViewModel: ObservableObject {
    @Published var hardware: Hardware
    let isNew: Bool
    
    private let context: NSManagedObjectContext
    
    init(provider: HardwareProvider, hardware: Hardware? = nil) {
        self.context = provider.newContext
        if let hardware,
           let existingHardwareCopy = try? context.existingObject(with: hardware.objectID) as? Hardware {
            self.hardware = existingHardwareCopy
            self.isNew = false
        } else {
            self.hardware = Hardware(context: self.context)
            self.isNew = true
        }
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}

struct EditHardwareView: View {
    @ObservedObject var vm: EditHardwareViewModel
    @Environment(\.dismiss) var dismiss
    let hardware: Hardware
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                AsyncCachedImage(
                    url: URL(string: "https://img.appledb.dev/device@main/\(hardware.identifier)/0.avif"),
                    failurePlaceholder: "xmark.octagon",
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                    },
                    placeholder: {
                        ProgressView() // A simple placeholder using a loading spinner
                            .frame(width: 200, height: 200)
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        do {
                            try vm.save()
                            dismiss()
                        } catch {
                            print(error)
                        }
                    } label: {
                        Image(systemName: "checkmark.square")
                            .font(.title2)
                    }
                }
            }
            List {
                Section("General") {
                    
                    TextField("Device Name", text: $vm.hardware.device)
                    TextField("Device Model", text: $vm.hardware.identifier)
                    TextField("Device Version", text: $vm.hardware.version)
                    TextField("Device Build", text: $vm.hardware.build)
                    TextField("Device Chip", text: $vm.hardware.chip)
            
                }
                
                Section("Notes") {
                    TextField("Device Note", text: $vm.hardware.note)
                }
            }
            .navigationTitle("Edit Device")
        }
    }
    private func colorBasedOnHardware() -> Color {
        if hardware.buildUpdateLatest {
            return .green // Color for the latest update
        } else if hardware.buildUpdateAvailable {
            return .yellow // Color for update available
        } else if hardware.buildFinal {
            return .blue // Color for final builds
        } else if hardware.buildBeta {
            return .purple // Color for beta builds
        } else {
            return .gray // Default color if none of the conditions are met
        }
    }
}
