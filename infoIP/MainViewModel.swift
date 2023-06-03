//
//  MainViewModel.swift
//  infoIP
//
//  Created by Max Victor on 02/06/23.
//

import Foundation
import SwiftUI
import MapKit

extension MainView{
    
    final class IPViewModel: ObservableObject{
        @Published var ipAddress = "Retrieving..."
        @Published var ipGeo = IPGeo(city: "City", region: "", timezone: "",org: "Provedor")
        @Published var location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        @Published var ipLocal = "Retrieving"
        
        private let api = NetworkMonitor()
        
        init(){
            fetchIP()
           ipLocal =  api.getIPLocal() ?? "Searching..."
        }
        
        func runOnMain(_ method: @escaping () -> Void){
            DispatchQueue.main.async {
                withAnimation {
                    method()
                }
            }
        }
        
         func fetchIP(){
            api.fetchData(url: "https://api.ipify.org/?format=json", model: IP.self){result in
                
                self.runOnMain {
                    self.ipAddress = result.ip
                    print(self.ipAddress)
                    self.fetchGeoData(ip: result.ip)
                    self.fetchLocation(ip: result.ip)
                    
                }
            }failure: { error in
                self.runOnMain {
                    print("IP \(error.localizedDescription)")
                    DispatchQueue.main.asyncAfter(deadline: .now()+5){
                        print("Trying again to fetch the IP address...")
                        self.fetchIP()
                    }
                }
            }
            
        }
        
        private func fetchGeoData(ip: String){
            
            api.fetchData(url: "https://ipapi.co/\(ip)/json/", model: IPGeo.self){ result in
                self.runOnMain {
                    self.ipGeo = result
                    print(self.ipGeo)
                }
            } failure: { error in
                print("GeoData: \(error.localizedDescription)")
            }
            
        }
        
        private func fetchLocation(ip:String){
         api.fetchData(url: "https://ipapi.co/\(ip)/json/", model: IPCoordinates.self){ result in
         self.runOnMain {
             self.location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
             print(self.location)
         }
         
         
         } failure: {error in
             
             print("GeoCoordinates: \(error.localizedDescription)")
         }
         
         }
        
        
        
    }
    
    
    
}
