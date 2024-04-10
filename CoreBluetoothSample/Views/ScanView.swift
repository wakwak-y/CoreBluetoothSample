//
//  ScanView.swift
//  CoreBluetoothSample
//
//  Created by 和久井侑 on 2024/01/03.
//

import SwiftUI

struct ScanView: View {
    @ObservedObject private var scanVM = ScanViewModel()
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("デバイスリスト")
                    .font(.title2.bold())
                Spacer()
            }
        
            // List
            peripheralList
        }
        .padding(.horizontal)
    }
}

extension ScanView {
    private var peripheralList: some View {
        ScrollView {
            VStack {
                ForEach(Array(scanVM.peripheralDevices)) { peripheral in
                    HStack {
                        listRow(peripheral: peripheral)
                    }
                }
            }
        }
    }
    
    private func listRow(peripheral: PeripheralDevice) -> some View {
        HStack {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(peripheral.name)
                    .foregroundColor(.primary)
                Text(peripheral.id)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            
            
            Spacer()
        }
    }
}

#Preview {
    ScanView()
}
