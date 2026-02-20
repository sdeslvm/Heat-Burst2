import Foundation
import UIKit

/// HeatBurst Data Validation Utility
class HeatBurstValidationHelper {
    static let shared = HeatBurstValidationHelper()
    
    private init() {}
    
    /// Validate URL for HeatBurst WebView
    func validateURL(_ url: String?) -> Bool {
        guard let urlString = url, !urlString.isEmpty else { return false }
        
        guard let nsURL = URL(string: urlString) else { return false }
        
        // Check for allowed schemes
        let allowedSchemes = ["http", "https", "file"]
        guard let scheme = nsURL.scheme?.lowercased(),
              allowedSchemes.contains(scheme) else { return false }
        
        // Check for HeatBurst domain restrictions
        return !urlString.lowercased().contains("blocked")
    }
    
    /// Validate email format for HeatBurst
    func validateEmail(_ email: String?) -> Bool {
        guard let email = email, !email.isEmpty else { return false }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Validate phone number for HeatBurst
    func validatePhoneNumber(_ phone: String?) -> Bool {
        guard let phone = phone, !phone.isEmpty else { return false }
        
        let phoneRegex = "^[+]?[0-9]{10,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    /// Validate JSON data for HeatBurst API
    func validateJSON(_ data: Data?) -> Bool {
        guard let data = data else { return false }
        
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: [])
            return true
        } catch {
            return false
        }
    }
    
    /// Validate session token for HeatBurst
    func validateSessionToken(_ token: String?) -> Bool {
        guard let token = token, !token.isEmpty else { return false }
        
        // Check token format (should be at least 20 characters)
        return token.count >= 20 && token.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
    }
    
    /// Get validation report
    func getValidationReport(for data: [String: Any]) -> String {
        var report = "HeatBurst Validation Report:\n"
        
        for (key, value) in data {
            var isValid = false
            
            switch key {
            case "url":
                isValid = validateURL(value as? String)
            case "email":
                isValid = validateEmail(value as? String)
            case "phone":
                isValid = validatePhoneNumber(value as? String)
            case "token":
                isValid = validateSessionToken(value as? String)
            default:
                isValid = true
            }
            
            report += "- \(key): \(isValid ? "✅ Valid" : "❌ Invalid")\n"
        }
        
        return report
    }
}
