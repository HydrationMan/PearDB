//
//  HardwareRowView.swift
//  PearDB
//
//  Created by Kane Parkinson on 07/08/2024.
//

import SwiftUI

struct HardwareRowView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var hardware: Hardware
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(hardware.device)
                    .font(.system(size: 18, design: .rounded).bold())
                HStack {
                    VStack(alignment: .leading) {
                        Text(hardware.identifier)
                            .font(.callout.bold())
                        Text(hardware.chip)
                            .font(.callout.bold())
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(hardware.version)
                            .font(.callout.bold())
                        Text(hardware.build)
                            .font(.callout.bold())
                    }
                }
                Text("Note: \(hardware.note)")
                    .font(.callout.bold())
            }
            
            Spacer() // Pushes the image to the right
            
            AsyncCachedImage(
                url: URL(string: "https://img.appledb.dev/device@main/\(hardware.identifier)/0.avif"),
                failurePlaceholder: "xmark.octagon",
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                },
                placeholder: {
                    ProgressView() // A simple placeholder using a loading spinner
                        .frame(width: 100, height: 100)
                }
            )
        }
    }
}
//#Preview {
//    HardwareView()
//}
