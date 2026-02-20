import Foundation
import UIKit
import AdSupport

/// HeatBurst Device Information Utility
class HeatBurstDeviceHelper {
    static let shared = HeatBurstDeviceHelper()
    
    private init() {}
    
    /// Get unique device identifier for HeatBurst
    func getHeatBurstDeviceID() -> String {
        // Use IDFV for unique identification
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
            return "HB_\(idfv)"
        }
        return "HB_UNKNOWN_\(UUID().uuidString)"
    }
    
    /// Get device capabilities for HeatBurst
    func getDeviceCapabilities() -> [String: Any] {
        return [
            "model": UIDevice.current.model,
            "systemVersion": UIDevice.current.systemVersion,
            "name": UIDevice.current.name,
            "batteryLevel": UIDevice.current.batteryLevel ?? -1,
            "batteryState": UIDevice.current.batteryState.rawValue,
            "isMultitaskingSupported": UIDevice.current.isMultitaskingSupported,
            "platform": "HeatBurst-iOS"
        ]
    }
    
    /// Check if device supports advanced features
    func supportsAdvancedFeatures() -> Bool {
        return UIDevice.current.systemVersion.compare("13.0", options: .numeric) != .orderedAscending
    }
    
    /// Get advertising identifier for analytics
    func getAdvertisingIdentifier() -> String? {
//        return ASIdentifierManager.shared().advertisingIdentifier?.uuidString
        return nil
    }
    
    /// Generate device report for debugging
    func generateDeviceReport() -> String {
        let capabilities = getDeviceCapabilities()
        return """
        HeatBurst Device Report:
        - Device ID: \(getHeatBurstDeviceID())
        - Model: \(capabilities["model"] ?? "Unknown")
        - iOS Version: \(capabilities["systemVersion"] ?? "Unknown")
        - Advanced Features: \(supportsAdvancedFeatures() ? "Yes" : "No")
        - Platform: HeatBurst-iOS
        """
    }
}
