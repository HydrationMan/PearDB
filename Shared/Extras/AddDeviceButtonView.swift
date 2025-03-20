//
//  AddDeviceButtonView.swift
//  PearDB
//
//  Created by Paras KCD on 17/3/25.
//

import SwiftUI

struct AddDeviceButtonView: View {
    var isLoading: Bool
    var isDeviceAlreadySaved: Bool
    var fromDB: Bool
    @Environment(\.dismiss) private var dismiss
    var openDialog: () -> Void
    
    var body: some View {
        if !isLoading {
            VStack(alignment: .trailing) {
                HStack(alignment: .center) {
                    Button {
                        openDialog()
                    } label: {
                        Label {
                            Text(isDeviceAlreadySaved ? "Edit Device" : "Add Device")
                        } icon: {
                            Image(systemName: "macbook.and.iphone")
                        }
                        .containerShape(RoundedRectangle(cornerRadius: 99))
                        .frame(maxWidth: 128)
                        .padding(8)
                        .background(.thickMaterial)
                        .cornerRadius(99)
                        .overlay {
                            #if os(macOS)
                            RoundedRectangle(cornerRadius: 99).stroke(Color(NSColor.separatorColor), lineWidth: 1)
                            #else
                            RoundedRectangle(cornerRadius: 99).stroke(Color(UIColor.separator), lineWidth: 1)
                            #endif
                        }
                    }
                    .buttonStyle(.plain)
                    
                    if fromDB {
                        XMarkButtonView(action: { dismiss() })
                    }
                }
                
            }
        } else {
            ProgressView()
        }
    }
}
