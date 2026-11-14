import Foundation

/// A data-only theme shared by native Velora applications.
public struct VeloraTheme: Identifiable, Sendable, Equatable {
    public enum ColorScheme: String, Sendable, Decodable { case light, dark }

    public let id: String
    public let name: String
    public let version: String
    public let author: String
    public let description: String
    public let repository: URL
    public let colorScheme: ColorScheme
    /// sRGB colours in #RRGGBB or #RRGGBBAA notation. Alpha is the last byte.
    public let colors: [String: String]
    public let preview: [String: String]
    /// Opaque six-digit colours without the # prefix, ready for native adapters.
    public let backgroundHex: String
    public let surfaceHex: String
    public let accentHex: String

    static let reservedIDs: Set<String> = ["light", "dark", "system", "none"]
    static func isValidID(_ id: String) -> Bool {
        matches(id, "^[a-z][a-z0-9-]{0,63}$") && !reservedIDs.contains(id)
    }

    static func matches(_ value: String, _ pattern: String) -> Bool {
        value.range(of: pattern, options: .regularExpression) != nil
    }

    private struct Manifest: Decodable {
        let manifest_version, plugin_api: Int
        let platform, type, id, name, version, author, description, repository: String
        let color_scheme: ColorScheme
        let colors, preview: [String: String]
    }

    static func decode(_ data: Data, expectedID: String) throws -> Self {
        func require(_ condition: Bool, _ reason: String) throws {
            if !condition { throw VeloraThemeError.invalidManifest(expectedID, reason) }
        }
        try require(data.count <= 32_768, "Manifest exceeds 32 KiB")
        let fields: Set<String> = ["manifest_version", "plugin_api", "platform", "type", "id", "name", "version", "author", "description", "repository", "color_scheme", "colors", "preview"]
        guard let object = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw VeloraThemeError.invalidManifest(expectedID, "Expected a JSON object")
        }
        try require(Set(object.keys) == fields, "Unexpected or missing fields")
        let manifest = try JSONDecoder().decode(Manifest.self, from: data)
        try require(manifest.manifest_version == 1 && manifest.plugin_api == 1, "Unsupported API version")
        try require(manifest.platform == "apple" && manifest.type == "theme", "Expected an Apple theme")
        try require(isValidID(manifest.id) && manifest.id == expectedID, "Invalid or mismatched theme ID")
        try require(matches(manifest.version, "^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)$"), "Invalid version")
        for (value, limit) in [(manifest.name, 80), (manifest.author, 120), (manifest.description, 300)] {
            try require(!value.isEmpty && value.unicodeScalars.count <= limit && !value.unicodeScalars.contains { $0.value < 32 || (127..<160).contains($0.value) }, "Invalid plain text")
        }
        try require(matches(manifest.repository, "^https://github\\.com/[A-Za-z0-9-]+/[A-Za-z0-9_.-]+$"), "Invalid repository URL")
        guard let repository = URL(string: manifest.repository) else {
            throw VeloraThemeError.invalidManifest(expectedID, "Invalid repository URL")
        }
        let required: Set<String> = ["paper", "surface", "ink", "muted", "accent", "line", "soft"]
        let optional = Set("green primary-text primary-hover primary-background player-surface nav-text nav-icon nav-hover selected-text cover-surface avatar-surface avatar-text badge-surface badge-text badge-overlay fact-text star unavailable summary search-surface search-icon player-art-surface player-glow toast-surface toast-text error feedback-error eyebrow".split(separator: " ").map(String.init))
        let previewKeys: Set<String> = ["paper", "surface", "line", "ink", "accent", "art-from", "art-to"]
        try require(required.isSubset(of: Set(manifest.colors.keys)) && Set(manifest.colors.keys).isSubset(of: required.union(optional)), "Unexpected or missing colour tokens")
        try require(Set(manifest.preview.keys) == previewKeys, "Unexpected or missing preview tokens")
        for tokens in [manifest.colors, manifest.preview] {
            for (token, value) in tokens {
                let opaque = ["paper", "surface", "accent"].contains(token)
                try require(matches(value, opaque ? "^#[0-9a-fA-F]{6}$" : "^#[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$"), "Invalid colour: " + token)
            }
        }
        guard let paper = manifest.colors["paper"], let surface = manifest.colors["surface"], let accent = manifest.colors["accent"] else {
            throw VeloraThemeError.invalidManifest(expectedID, "Missing native colours")
        }
        return Self(id: manifest.id, name: manifest.name, version: manifest.version,
                    author: manifest.author, description: manifest.description, repository: repository,
                    colorScheme: manifest.color_scheme, colors: manifest.colors, preview: manifest.preview,
                    backgroundHex: String(paper.dropFirst()).lowercased(),
                    surfaceHex: String(surface.dropFirst()).lowercased(),
                    accentHex: String(accent.dropFirst()).lowercased())
    }
}

public enum VeloraThemeError: Error, LocalizedError, Sendable {
    case missingResources
    case invalidCatalog(String)
    case invalidManifest(String, String)

    public var errorDescription: String? {
        switch self {
        case .missingResources: "The Velora Apple theme resource bundle is missing."
        case .invalidCatalog(let reason): "Invalid Velora Apple theme catalog: \(reason)."
        case .invalidManifest(let id, let reason): "Invalid Velora Apple theme \(id): \(reason)."
        }
    }
}
