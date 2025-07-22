//
//  DataCloudService.swift
//  TataPlayApp
//
//  Created by Arup Sarkar (TA) on 7/19/25.
//

import Cdp
import SFMCSDK

import Foundation
import Personalization

final class DataCloudService {
    static let shared = DataCloudService()
    private let logger = DataCloudLoggingService.shared
    
    private init() {
        self.configureSdk()
    }
    
    func configureSdk() {
        // 1. Enable logging for development
        SFMCSdk.setLogger(logLevel: .debug)
        
        // 2. Build the CDP module configuration
        let cdpConfig = CdpConfigBuilder(
            appId: ConfigurationManager.shared.cdpAppId,
            endpoint: ConfigurationManager.shared.cdpEndpoint
            )
            .trackLifecycle(true)
            .trackScreens(true)
            .sessionTimeout(600)
            .build()
        
        let personalizationConfig = PersonalizationConfigBuilder()
            //.dataspace("specialDataspace")
            .build()
        
        SFMCSdk.initializeSdk(
ConfigBuilder()
            .setCdp(
config: cdpConfig,
 onCompletion: { result in
                SFMCSdkLogger.shared.logMessage(level: LogLevel.debug, subsystem: LoggerSubsystem.module(value: ModuleName.cdp), category: LoggerCategory.module, message: "CDP Module result: \(result)")
                
                switch result {
                case .success:
                    SFMCSdkLogger.shared.logMessage(level: LogLevel.debug, subsystem: LoggerSubsystem.module(value: ModuleName.cdp), category: LoggerCategory.session, message: "CDP State before setting Consent optIn: \(CdpModule.shared.state)")
//                    SFMCSdk.cdp.setConsent(consent: Consent.optIn)
                    // Manage in ConsentView Separately and user activated.
                    SFMCSdkLogger.shared.logMessage(level: LogLevel.debug, subsystem: LoggerSubsystem.module(value: ModuleName.cdp), category: LoggerCategory.session, message: "CDP State after setting Consent optIn: \(CdpModule.shared.state)")
                    break
                case .error:
                    SFMCSdkLogger.shared
                        .logMessage(
                            level: LogLevel.error,
                            subsystem: LoggerSubsystem
                                .module(value: ModuleName.cdp),
                            category: LoggerCategory.session,
                            message: "CDP State error: \(CdpModule.shared.state)"
                        )
                    break
                case .cancelled:
                    SFMCSdkLogger.shared
                        .logMessage(
                            level: LogLevel.error,
                            subsystem: LoggerSubsystem
                                .module(value: ModuleName.cdp),
                            category: LoggerCategory.session,
                            message: "CDP State cancelled: \(CdpModule.shared.state)"
                        )
                    break
                case .timeout:
                    SFMCSdkLogger.shared
                        .logMessage(
                            level: LogLevel.error,
                            subsystem: LoggerSubsystem
                                .module(value: ModuleName.cdp),
                            category: LoggerCategory.session,
                            message: "CDP State timeout: \(CdpModule.shared.state)"
                        )
                    break
                @unknown default:
                    SFMCSdkLogger.shared
                        .logMessage(
                            level: LogLevel.error,
                            subsystem: LoggerSubsystem
                                .module(value: ModuleName.cdp),
                            category: LoggerCategory.session,
                            message: "CDP State error: \(CdpModule.shared.state)"
                        )
                    break
                }
//                if result == .success {
//                    SFMCSdkLogger.shared.logMessage(level: LogLevel.debug, subsystem: LoggerSubsystem.module(value: ModuleName.cdp), category: LoggerCategory.session, message: "CDP State before setting Consent optIn: \(CdpModule.shared.state)")
//                    SFMCSdk.cdp.setConsent(consent: Consent.optIn)
//                    SFMCSdkLogger.shared.logMessage(level: LogLevel.debug, subsystem: LoggerSubsystem.module(value: ModuleName.cdp), category: LoggerCategory.session, message: "CDP State after setting Consent optIn: \(CdpModule.shared.state)")
//                }
            })
            .setPersonalization(config: personalizationConfig, onCompletion: { result in
                SFMCSdkLogger.shared.logMessage(level: LogLevel.debug, subsystem: LoggerSubsystem.module(value: ModuleName.personalization), category: LoggerCategory.module, message: "P13N Module result: \(result)")
                // if result == .success {}
                // TODO: this can happen BEFORE CDP onCompletion/ready.  Maybe P chould listen for CDP Ready before reporting itself as Ready (is there something to listen for (yet)?  Does order .set configs above matter?  Didn't Push maybe do weird things in SFMC base regarding order of initializing modules?
            })
            .build()
)
        
//        let completionHandler: (OperationResult) -> () = { result in
//            self.logger.debug("Operation Result : \(result.rawValue)")
//            self.logger.debug("SFMCSDK MP Status: \(SFMCSdk.mp.getStatus().rawValue)")
//            if result == .success && SFMCSdk.mp.getStatus() == .operational {
//                // module is fully configured and ready for use
//                self.logger.debug("CDP Module initialized successfully")
//                // Post notification for successful initialization
//                NotificationCenter.default.post(
//                    name: .dataCloudStateChanged,
//                    object: nil,
//                    userInfo: [Notification.dataCloudEventKey: DataCloudEvent.initialized]
//                )
//            } else if result == .success {
//                // Module initialized but not operational yet, check status and fire event when ready
//                self.checkAndNotifyWhenOperational()
//
//            } else if result == .error {
//                // module failed to initialize, check logs for more details
//                self.logger.error("CDP Module initialization failed")
//                NotificationCenter.default.post(
//                    name: .dataCloudStateChanged,
//                    object: nil,
//                    userInfo: [Notification.dataCloudEventKey: DataCloudEvent.failed(nil)]
//                )
//            } else if result == .cancelled {
//                // module initialization was cancelled (for example due to re-confirguration triggered before init was completed)
//                self.logger.error("CDP Module initialization cancelled")
//                NotificationCenter.default.post(
//                    name: .dataCloudStateChanged,
//                    object: nil,
//                    userInfo: [Notification.dataCloudEventKey: DataCloudEvent.failed(nil)]
//                )
//            } else if result == .timeout {
//                // module failed to initialize due to timeout, check logs for more details
//                self.logger.error("CDP Module initialization timed out")
//                NotificationCenter.default.post(
//                    name: .dataCloudStateChanged,
//                    object: nil,
//                    userInfo: [Notification.dataCloudEventKey: DataCloudEvent.failed(nil)]
//                )
//            }
//        }
//        
//        let sdkConfig = ConfigBuilder()
//            .setCdp(config: cdpConfig, onCompletion: completionHandler)
//            .setPush(config: cdpConfig, onCompletion: completionHandler)
//            .build()
//        
//        
//
//        
//        SFMCSdk.initializeSdk(sdkConfig)
            
    }
    
    func trackEvent(_ eventName: String, attributes: [String: Any]? = nil) {
        // Only track events if the user has opted in to consent
        if CdpModule.shared.getConsent() == .optIn {
            if let event = CustomEvent(name: eventName, attributes: attributes) {
                SFMCSdk.track(event: event)
            }
        }
    }
    private func checkAndNotifyWhenOperational() {
        self.logger.debug("checkAndNotifyWhenOperational - Start")

        // Check status every 0.5 seconds
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            self?.logger.debug("timer ")
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.logger.debug("checkAndNotifyWhenOperational - End")
            self.logger.debug("SFMCSDK MP Status 2 : \(SFMCSdk.mp.getStatus().rawValue)")
            if SFMCSdk.mp.getStatus() == .operational {
                timer.invalidate()
                self.logger.debug("CDP Module is now operational")
                NotificationCenter.default.post(
                    name: .dataCloudStateChanged,
                    object: nil,
                    userInfo: [Notification.dataCloudEventKey: DataCloudEvent.initialized]
                )
            }
        }
    }

    
    // MARK: - Module State
    func isCdpModuleOperational() -> Bool {
        self.logger.debug("Operational Status of CdpMdule \(SFMCSdk.mp.getStatus().rawValue)")
        return SFMCSdk.mp.getStatus() == .operational
    }
    
}
