//
//  EvaluateHelper.swift
//  Evaluate
//
//  Created by zhanggen on 2026/02/24.
//  Modernized for iOS 26+ and Swift 6
//

import Foundation

/// Handles fetching app metadata from the iTunes Search API.
@MainActor
final class EvaluateHelper {

  // MARK: - Error Types

  enum HelperError: LocalizedError {
    case malformedURL
    case dataRetrievalFailure(underlying: Error?)
    case jsonParsingFailure
    case appIDNotFound

    var errorDescription: String? {
      switch self {
      case .malformedURL:
        return "The iTunes lookup URL could not be constructed."
      case .dataRetrievalFailure(let error):
        return "Failed to retrieve App Store data: \(error?.localizedDescription ?? "unknown error")"
      case .jsonParsingFailure:
        return "Failed to parse App Store JSON response."
      case .appIDNotFound:
        return "The 'trackId' field was not found in the API response."
      }
    }
  }

  // MARK: - iTunes API Response (Codable)

  private struct ITunesResponse: Decodable {
    let resultCount: Int
    let results: [ITunesResult]
  }

  private struct ITunesResult: Decodable {
    let trackId: Int
    let version: String?
    let trackName: String?
  }

  // MARK: - Singleton

  static let `default` = EvaluateHelper()

  private init() {}

  // MARK: - Public API

  /// Fetches app metadata from iTunes and updates `Evaluate` with the App ID.
  func startParsingData() {
    Task {
      do {
        let url = try buildITunesURL()
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        let (data, _) = try await URLSession.shared.data(for: request)
        try processResponse(data: data)
      } catch {
        log(error.localizedDescription)
      }
    }
  }

  // MARK: - Private

  private func processResponse(data: Data) throws {
    let response = try JSONDecoder().decode(ITunesResponse.self, from: data)

    guard let firstResult = response.results.first else {
      throw HelperError.dataRetrievalFailure(underlying: nil)
    }

    let appID = String(firstResult.trackId)
    Evaluate.appID = appID
    Evaluate.default.incrementAppUsagesCount()
  }

  private func buildITunesURL() throws -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "itunes.apple.com"

    if let countryCode = Evaluate.countryCode {
      components.path = "/\(countryCode)/lookup"
    } else {
      components.path = "/lookup"
    }

    components.queryItems = [
      URLQueryItem(name: "bundleId", value: Bundle.bundleID)
    ]

    guard let url = components.url else {
      throw HelperError.malformedURL
    }
    return url
  }

  private func log(_ message: String) {
    guard Evaluate.canShowLogs else { return }
    print("[Evaluate] \(message)")
  }
}
