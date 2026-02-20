import Foundation
import UIKit

/// HeatBurst Cache Management Utility
class HeatBurstCacheHelper {
    static let shared = HeatBurstCacheHelper()
    
    private let cache = NSCache<NSString, AnyObject>()
    private let fileManager = FileManager.default
    
    private init() {
        setupCache()
    }
    
    private func setupCache() {
        cache.countLimit = 100
        cache.totalCostLimit = HeatBurstConstants.maxCacheSize
    }
    
    /// Store data in HeatBurst memory cache
    func storeInMemory<T: AnyObject>(_ object: T, forKey key: String) {
        let heatBurstKey = "HB_\(key)"
        cache.setObject(object, forKey: heatBurstKey as NSString)
    }
    
    /// Retrieve data from HeatBurst memory cache
    func retrieveFromMemory<T: AnyObject>(_ type: T.Type, forKey key: String) -> T? {
        let heatBurstKey = "HB_\(key)"
        return cache.object(forKey: heatBurstKey as NSString) as? T
    }
    
    /// Store data in HeatBurst file cache
    func storeInFile<T: Codable>(_ object: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(object) else { return }
        
        let heatBurstKey = "HB_\(key)"
        let cacheURL = getCacheDirectory().appendingPathComponent("\(heatBurstKey).cache")
        
        try? data.write(to: cacheURL)
    }
    
    /// Retrieve data from HeatBurst file cache
    func retrieveFromFile<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        let heatBurstKey = "HB_\(key)"
        let cacheURL = getCacheDirectory().appendingPathComponent("\(heatBurstKey).cache")
        
        guard let data = try? Data(contentsOf: cacheURL) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    /// Clear all HeatBurst cache
    func clearAllCache() {
        cache.removeAllObjects()
        
        if let cacheURL = getCacheDirectory() as URL?,
           let cacheContents = try? fileManager.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil) {
            for file in cacheContents {
                try? fileManager.removeItem(at: file)
            }
        }
    }
    
    /// Get HeatBurst cache directory
    private func getCacheDirectory() -> URL {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheURL = urls.first?.appendingPathComponent("HeatBurstCache")
        
        if let cacheURL = cacheURL {
            try? fileManager.createDirectory(at: cacheURL, withIntermediateDirectories: true)
        }
        
        return cacheURL ?? URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    /// Get cache statistics
    func getCacheStats() -> [String: Any] {
        var stats: [String: Any] = [:]
        
        stats["memoryCount"] = cache.countLimit
        stats["memoryCost"] = cache.totalCostLimit
        stats["platform"] = "HeatBurst-iOS"
        
        if let cacheURL = getCacheDirectory() as URL?,
           let cacheContents = try? fileManager.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: [.fileSizeKey]) {
            var totalSize = 0
            for file in cacheContents {
                if let size = try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                    totalSize += size
                }
            }
            stats["fileCount"] = cacheContents.count
            stats["fileSize"] = totalSize
        }
        
        return stats
    }
}
