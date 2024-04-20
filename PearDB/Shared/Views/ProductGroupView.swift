//
//  ProductView.swift
//  PearDBProject
//
//  Created by bibi_fire on 20/04/2024.
//

import SwiftUI

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)!
    }
}

extension Date {
    func toFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}


struct ProductGroupView: View {
    var devices: [Device]?
    var group: DeviceGroup
    
    init(group: DeviceGroup) {
        self.devices = group.products
        self.group = group
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(group.name).font(.title3)
                if let lastDevice = devices?.last, let images = lastDevice.images {
                    ForEach(images.index) { image in
                        URLImage(URL(string:"https://img.appledb.dev/device@main/\(lastDevice.key)/\(image.id).png")!)
                    }
                    
                }
            }
            
            VStack(alignment: .leading) {
                if let devices = devices {
                    Text("Identifier : \(devices.map { $0.key }.joined(separator: ", ") )").font(.footnote)
                    if let socs = Array(Set(devices.compactMap { $0.soc })), !socs.isEmpty {
                        Text("SoC: \(socs.joined(separator: ", "))").font(.footnote)
                    }
                    Text("Model: \(devices.flatMap { $0.model }.joined(separator: ", "))").font(.footnote)
                    
                    if let allReleasedDates = devices.compactMap({ $0.released?.compactMap { $0 } }).flatMap({ $0 }), !allReleasedDates.isEmpty {
                        Text("Released on \(allReleasedDates.map { $0 }.joined(separator: ", "))").font(.footnote)
                    }

                }
            }.multilineTextAlignment(.leading)
        }.padding().frame(maxWidth:.infinity).background(BackgroundView())
    }
}

struct ProductGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ProductGroupView(group: DeviceGroup(name: "", type: "", key: "", order: 1))
    }
}
