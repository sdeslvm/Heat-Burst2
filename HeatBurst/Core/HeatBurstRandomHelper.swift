import Foundation
import UIKit

/// HeatBurst Random Data Generator Utility
class HeatBurstRandomHelper {
    static let shared = HeatBurstRandomHelper()
    
    private init() {}
    
    /// Generate unique session identifier
    func generateSessionID() -> String {
        return "HB_\(UUID().uuidString.prefix(8))_\(Date().timeIntervalSince1970)"
    }
    
    /// Generate random device fingerprint
    func generateDeviceFingerprint() -> String {
        let deviceModel = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        let random = UUID().uuidString.prefix(6)
        return "HB_\(deviceModel)_\(systemVersion)_\(random)"
    }
    
    /// Generate random user agent string
    func generateUserAgent() -> String {
        let versions = ["2.1.0", "2.1.1", "2.1.2"]
        let version = versions.randomElement() ?? "2.1.0"
        return "HeatBurst-iOS/\(version) (iOS \(UIDevice.current.systemVersion))"
    }
    
    /// Generate random request ID
    func generateRequestID() -> String {
        return "HB_REQ_\(Int.random(in: 1000...9999))_\(Date().timeIntervalSince1970)"
    }
    
    /// Generate random color in hex format
    func generateRandomHexColor() -> String {
        let colors = ["#FF6B35", "#F7931E", "#FFD23F", "#06FFA5", "#118AB2", "#073B4C"]
        return colors.randomElement() ?? "#FF6B35"
    }
}
