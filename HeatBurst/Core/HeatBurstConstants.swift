import Foundation
import UIKit

/// HeatBurst Application Configuration Constants
enum HeatBurstConstants {
    /// Application version information
    static let appVersion = "2.1.0"
    static let buildNumber = "20240220"
    static let platform = "HeatBurst-iOS"
    
    /// Network configuration
    static let networkTimeout: TimeInterval = 30.0
    static let maxRetryAttempts = 3
    static let apiVersion = "v2.1"
    
    /// Cache configuration
    static let cacheExpirationTime: TimeInterval = 3600 // 1 hour
    static let maxCacheSize = 50 * 1024 * 1024 // 50MB
    
    /// WebView configuration
    static let webViewUserAgent = "HeatBurst-iOS/2.1.0"
    static let maxWebViewInstances = 5
    
    /// Security configuration
    static let encryptionKey = "HeatBurstSecureKey2024"
    static let tokenExpiryTime: TimeInterval = 86400 // 24 hours
    
    /// UI configuration
    static let animationDuration: TimeInterval = 0.3
    static let cornerRadius: CGFloat = 12.0
    static let primaryColor = "#FF6B35"
    
    /// Feature flags
    static let isDebugModeEnabled = false
    static let isAnalyticsEnabled = true
    static let isCrashReportingEnabled = true
}
