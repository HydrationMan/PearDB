//
//  DeviceInfoView.swift
//  PearDB
//
//  Created by Kane Parkinson on 16/03/2025.
//

import SwiftUI

struct DeviceInfoView: View {
    @ObservedObject var device: Device
    
    @State var isExpanded: Expanded = Expanded()
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                if (device.identifier != nil) {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "info.square.fill")
                            Text("Identifier")
                                .font(.title3)
                        }
                        Text(device.identifier ?? "N/A")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(8)
                }
                
                if (device.arch != nil) {
                    HStack {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "slider.horizontal.3")
                            Text("Arch")
                                .font(.title3)
                        }
                        Text(device.arch ?? "N/A")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(8)
                }
                
                if (device.info?.isEmpty == false) {
                    ForEach(
                        device.info!.sorted(by: { $0.type.localizedStandardCompare($1.type) == .orderedAscending }), id: \.type
                    ) { deviceInfo in
                        switch (deviceInfo.deviceInfoType) {
                        case .soc:
                            DisclosureGroup(isExpanded: $isExpanded.socExpanded) {
                                VStack(alignment: .leading) {
                                    Text("SoC: \(deviceInfo.soc ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Architecture: \(deviceInfo.architecture ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Manufacturing Process: \(deviceInfo.manifacturingProcess ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "cpu.fill")
                                    Text("SoC")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.socExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)

                        case .cores:
                            DisclosureGroup(isExpanded: $isExpanded.coresExpanded) {
                                VStack(alignment: .leading) {
                                    Text("CPU core count: \(deviceInfo.cpuCoreCount ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Performance Cores: \(deviceInfo.performanceCores ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Efficiency Cores: \(deviceInfo.efficiencyCores ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "cpu.fill")
                                    Text("Cores")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.coresExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            
                        case .power:
                            DisclosureGroup(isExpanded: $isExpanded.powerExpanded) {
                                VStack(alignment: .leading) {
                                    Text("Battery Capacity: \(deviceInfo.batteryCapacity ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Battery Life: \(deviceInfo.batteryLife ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Charger: \(deviceInfo.charger ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "cable.connector")
                                    Text("Power")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.powerExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            
                        case .sensors:
                            DisclosureGroup(isExpanded: $isExpanded.sensorsExpanded) {
                                VStack(alignment: .leading) {
                                    Text ("Camera: \(deviceInfo.camera ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text ("Microphone: \(deviceInfo.microphone ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Front Camera: \(deviceInfo.frontCamera ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Telephoto Camera: \(deviceInfo.telephotoCamera ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Wide Camera: \(deviceInfo.wideCamera ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Ultra Wide Camera: \(deviceInfo.ultraWideCamera ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("True Depth Camera: \(deviceInfo.trueDepthCamera ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Biometrics: \(deviceInfo.biometrics ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Other: \(deviceInfo.other ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "sensor.fill")
                                    Text("Sensors")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.sensorsExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            
                        case .memory:
                            DisclosureGroup(isExpanded: $isExpanded.memoryExpanded) {
                                VStack(alignment: .leading) {
                                    Text("Storage: \(deviceInfo.storage ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("RAM: \(deviceInfo.ram ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "memorychip.fill")
                                    Text("Memory")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.memoryExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            
                        case .audio:
                            DisclosureGroup(isExpanded: $isExpanded.audioExpanded) {
                                VStack(alignment: .leading) {
                                    Text("Speakers: \(deviceInfo.speakers ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Channels: \(deviceInfo.channels ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Headphone Jack: \(deviceInfo.headphoneJack ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Dolby Atmos: \(deviceInfo.dolbyAtmos ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Microphone: \(deviceInfo.microphone ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "waveform")
                                    Text("Audio")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.audioExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            
                        case .input:
                            DisclosureGroup(isExpanded: $isExpanded.inputExpanded) {
                                VStack(alignment: .leading) {
                                    Text("Key Count: \(deviceInfo.keyCount ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Trackpad: \(deviceInfo.trackpad ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Touchbar: \(deviceInfo.touchbar ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Touch ID: \(deviceInfo.touchId ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "keyboard.fill")
                                    Text("Input")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.inputExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            
                        case .connectivity:
                            DisclosureGroup(isExpanded: $isExpanded.connectivityExpanded) {
                                VStack(alignment: .leading) {
                                    Text("Ports: \(deviceInfo.ports ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Supports: \(deviceInfo.supports ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("External Display Count: \(deviceInfo.externalDisplayCount ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Cellular: \(deviceInfo.cellular ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Wi-fi: \(deviceInfo.wifi ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Bluetooth: \(deviceInfo.bluetooth ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Ultra Wideband: \(deviceInfo.ultraWideBand ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "antenna.radiowaves.left.and.right")
                                    Text("Connectivity")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.connectivityExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            
                        case .display:
                            DisclosureGroup(isExpanded: $isExpanded.displayExpanded) {
                                VStack(alignment: .leading) {
                                    Text("Screen Size: \(deviceInfo.screenSize ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Refresh Rate: \(deviceInfo.refreshRate ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Peak Brightness: \(deviceInfo.peakBrightness ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Color Gamut: \(deviceInfo.colorGamut ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("True Tone: \(deviceInfo.trueTone ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Pro Motion: \(deviceInfo.proMotion ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                    Text("Pixels Per Inch: \(deviceInfo.ppi ?? "N/A")")
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            } label: {
                                HStack(alignment: .center, spacing: 8) {
                                    Image(systemName: "display")
                                    Text("Display")
                                        .font(.title3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        isExpanded.displayExpanded.toggle()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            
                        default:
                            EmptyView()
                        }
                    }
                }
                Color.clear.padding()
            }
        }
    }
}
