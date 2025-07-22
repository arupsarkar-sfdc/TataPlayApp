//
//  NotificationCenter+Events.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/21/25.
//

import Foundation

extension Notification.Name {
    static let dataCloudStateChanged = Notification.Name("com.salesforcetataplay.TataPlayApp.stateChanged")
}

extension Notification {
    static let dataCloudEventKey = "dataCloudEvent"
}
