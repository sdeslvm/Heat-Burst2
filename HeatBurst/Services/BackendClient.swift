

import Foundation
import os.log

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "HeatBurst", category: "BackendClient")

enum BackendError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

final class BackendClient {
    func requestFinalLink(url: URL) async throws -> BackendLinkResponse {
        logger.info("[POST] 📤 Sending request to: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = nil

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("[POST] ❌ Invalid response type")
            throw BackendError.invalidResponse
        }
        
        logger.info("[POST] Response status code: \(httpResponse.statusCode)")
        
        if let responseString = String(data: data, encoding: .utf8) {
            logger.info("[POST] Response body: \(responseString)")
            
            // Добавляем детальный анализ структуры ответа
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                logger.info("[POST] Response JSON keys: \(jsonData.keys.joined(separator: ", "))")
                for (key, value) in jsonData {
                    logger.info("[POST] Key '\(key)' -> Value: '\(value)'")
                }
            }
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            logger.error("[POST] ❌ Bad status code: \(httpResponse.statusCode)")
            throw BackendError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(BackendLinkResponse.self, from: data)
            logger.info("[POST] ✅ Decoded response - domain: '\(decoded.domain)', tld: '\(decoded.tld)'")
            if let finalURL = decoded.finalURL {
                logger.info("[POST] ✅ Final URL: \(finalURL.absoluteString)")
            } else {
                logger.warning("[POST] ⚠️ Final URL is nil (empty domain or tld)")
            }
            return decoded
        } catch {
            logger.error("[POST] ❌ Decoding failed: \(error.localizedDescription)")
            throw BackendError.decodingFailed
        }
    }
}
