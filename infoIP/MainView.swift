//
//  MainView.swift
//  infoIP
//
//  Created by Max Victor on 02/06/23.
//

import SwiftUI
import MapKit
import StoreKit

struct MainView: View {
    @Environment(\.requestReview)var requestReview: RequestReviewAction
    @EnvironmentObject  var reviewsManager: ReviewsRequestManager
    @StateObject  var networkMonitor = NetworkMonitor()
    @StateObject var vm = IPViewModel()
    @State var connectionType: String = ""
    
    var body: some View {
        
        //verbatim: Creates a text view that displays a string literal without localization.
       
      //  NavigationView {
        VStack {
            Form{
                    Section(header: HStack{Text("Network"); Image(systemName: networkMonitor.isActive ? "checkmark.circle":"x.circle")
                        .foregroundColor(networkMonitor.isActive ? .green:.red); Text(networkMonitor.isActive ? "" : "Check your connection").font(.caption2).foregroundColor(.accentColor) }){
                            HStack {
                                Text(verbatim: "Connection Type: " )
                                Spacer()
                                HStack {
                                    Text(networkMonitor.isExpensive ? "Mobile Data":"Wi-Fi")
                                    Image(systemName:  networkMonitor.isExpensive ? "personalhotspot":"wifi")
                                    
                                }
                            }
                            HStack {
                                Text("Local IP: ")
                                Spacer()
                                Text("\(vm.ipLocal)")
                            }
                            HStack {
                                Text("Public IP: ")
                                Spacer()
                                Text("\(vm.ipAddress)")
                            }
                        
                        }
                    Section {
                        HStack {
                            Spacer()
                            if vm.ipGeo.longitude == 0{
                            ProgressView()
                            }else{
                                Text("\(vm.ipGeo.city) - \(vm.ipGeo.region)")
                            }
                            Spacer()
                        }
                        ZStack {
                            Map(coordinateRegion: $vm.location)
                                .cornerRadius(10)
                                .frame(width: 300,height: 300,alignment: .center)
                                
                            Circle()
                                .frame(width: 20,height: 20,alignment: .center)
                                .foregroundColor(.blue.opacity(0.2))
                            VStack {
                                Spacer()
                                VStack(spacing: 10){
                                    Text("IP: \(vm.ipAddress)")
                                    Text("\(vm.ipGeo.country_name)")
                                }
                                .font(.caption)
                                .frame(width: 150)
                                .background(.thinMaterial.opacity(0.7))
                                .cornerRadius(7)
                            }
                            
                        }.frame(maxWidth: .infinity,maxHeight: 300,alignment: .center)
                        
                        HStack {
                            Text("Provider: ")
                            Spacer()
                            if vm.ipGeo.longitude == 0 {
                                ProgressView()
                        }else{
                            
                            Text("\(vm.ipGeo.org)")
                        }
                    }
                        
                    }header: {
                        Text("Location")
                    } footer:{
                        Text("To know more apps like this one, access the [developer's page](https://apps.apple.com/gb/developer/max-victor-fideles-cunha/id1683987057)").frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }//.frame(maxWidth: .infinity)
                    //.multilineTextAlignment(.center)
                
            }.onChange(of: networkMonitor.isActive) { newValue in
                vm.ipLocal = networkMonitor.getIPLocal() ?? "Retrieving..."
                vm.fetchIP()
                
            }
            .onChange(of: networkMonitor.connectionType) { newValue in
                vm.ipLocal = networkMonitor.getIPLocal() ?? "Retrieving..."
                vm.fetchIP()
                
            }
            
            
                                
            
        }.onAppear{
            reviewsManager.increase()
                
            if reviewsManager.canAskForReview(){
                requestReview()
            }
            vm.fetchGeoData(ip: vm.ipAddress)
            
        }
            
    }


}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(ReviewsRequestManager())
    }
}
