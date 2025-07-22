//
//  ConfigurationManager.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/19/25.
//

final class ConfigurationManager {
    static let shared = ConfigurationManager()
    
    private init() {}
    
    // Add these to your configuration file or environment variables
    var cdpAppId: String {
        // Replace with your actual app ID
        return "a8665c63-6e88-4057-ac7b-1f2fdff11b6c"
    }
    
    var cdpEndpoint: String {
        // Replace with your actual endpoint
        return "gmzd0zjvh04tkzd0mfstqnjvg0.pc-rnd.c360a.salesforce.com"
    }
}
