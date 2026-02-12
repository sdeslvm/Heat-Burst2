
import Foundation

struct RemoteLinkParts: Decodable, Sendable {
    let host: String
    let path: String

    private enum CodingKeys: String, CodingKey {
        case host = "creo"
        case path = "false"
    }
}

struct BackendLinkResponse: Decodable, Sendable {
    let domain: String
    let tld: String

    private enum CodingKeys: String, CodingKey {
        case domain = "creo"
        case tld = "false"
    }

    var finalURL: URL? {
        guard !domain.isEmpty, !tld.isEmpty else { return nil }
        return URL(string: "https://\(domain)\(tld)")
    }
}

enum LaunchOutcome: Sendable {
    case showWeb(URL)
    case showStub
    case loading
}
