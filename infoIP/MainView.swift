//
//  MainView.swift
//  infoIP
//
//  Created by Max Victor on 02/06/23.
//

import SwiftUI
import MapKit

struct MainView: View {
    @StateObject  var networkMonitor = NetworkMonitor()
    @StateObject var vm = IPViewModel()
    
    var body: some View {
        
        //verbatim: Creates a text view that displays a string literal without localization.

        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(verbatim: "Connected: \(networkMonitor.isActive)" )
                Image(systemName: networkMonitor.isActive ? "checkmark.circle":"x.circle")
                    .foregroundColor(networkMonitor.isActive ? .green:.red)
            }
            Text(verbatim: "Low Data Mode: \(networkMonitor.isConstrained)" )
            Text(verbatim: "Mobile Data / Hotspot : \(networkMonitor.isExpensive)" )
            Text(verbatim: "Connected: \(networkMonitor.connectionType)" )
            Text("IP: \(vm.ipAddress)")
            Text("Provedor: \(vm.ipGeo.org)")
            Text("IpLocal: \(vm.ipLocal)")
                
            
            
            ZStack {
                Map(coordinateRegion: $vm.location)
                    .cornerRadius(10)
                    
                Circle()
                    .frame(width: 20,height: 20,alignment: .center)
                    .foregroundColor(.blue.opacity(0.2))
                VStack {
                    Spacer()
                    VStack(spacing: 10){
                        Text("IP: \(vm.ipAddress)")
                        Text("\(vm.ipGeo.city) - \(vm.ipGeo.region)")
                    }
                    .frame(width: 200)
                    .background(.thinMaterial.opacity(0.7))
                    .cornerRadius(10)
                }
                
            }.frame(width: 350,height: 350)
            
        }
        
    }


}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}