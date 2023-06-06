//
//  networkManager.swift
//  infoIP
//
//  Created by Max Victor on 02/06/23.
//

import Foundation
import Network


class NetworkMonitor: ObservableObject{
    private let monitor = NWPathMonitor() //An observer that you use to monitor and react to network changes(real time).
    private let queue = DispatchQueue(label: "Monitor")
    @Published var isActive = false
    @Published var isExpensive = false //Any connection that's not Wi-fi is Expensive
    @Published var isConstrained = false //If the low data mode is active or not, if true it means won't have to much data to work with.
    @Published var connectionType = NWInterface.InterfaceType.other // Check the connection type
    
    
    init(){
        //check for updates
        
        monitor.pathUpdateHandler = {path in
            
            DispatchQueue.main.async {
                self.isActive = path.status == .satisfied
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained
                
                let connectionTypes : [NWInterface.InterfaceType] = [.cellular,.wifi,.wiredEthernet]
                
                self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
                
                
            }
        }
        
        monitor.start(queue: queue)
        
    }
    
    func fetchData <T: Decodable>(url: String, model: T.Type, completion: @escaping(T)-> (), failure:@escaping(Error) -> ()){
        
        guard let url = URL(string: url)else{return}
        URLSession.shared.dataTask(with: url) { (data,response,error) in
            guard let data = data else{
                if let error = error { failure(error)}
                return
            }
            do{
                let serverData = try JSONDecoder().decode(T.self, from: data)
                completion((serverData))
            }catch{
                failure(error)
            }
            
        }.resume()
        
        
    }
    
    func getIPLocal() -> String?{
        var address: String?
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else{ return nil}
        guard let firstAddr = ifaddr else {return nil }
        
        
        for ifptr in sequence(first: firstAddr, next:{$0.pointee.ifa_next}){
            
            let interface = ifptr.pointee
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6){
                
                let name = String (cString: interface.ifa_name)
                if name == "en0"{
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),&hostname, socklen_t(hostname.count),nil,socklen_t(0),NI_NUMERICHOST)
                    address = String(cString: hostname)
                    
                    
                }else if(name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3"){
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),&hostname, socklen_t(hostname.count),nil,socklen_t(1),NI_NUMERICHOST)
                    address = String(cString: hostname)
                    
                    
                }
                
            }
        }
        freeifaddrs(ifaddr)
        return address
        
        
    }
}
    

struct IP: Decodable{
    var ip:String

}

struct IPGeo: Decodable{
    var city: String
    var region: String
    var timezone: String
    var org: String
    var country_name:String
    var latitude: Double
    var longitude: Double
}

//struct IPCoordinates: Decodable{
  //  var latitude: Double
    //var longitude: Double
//}







    

