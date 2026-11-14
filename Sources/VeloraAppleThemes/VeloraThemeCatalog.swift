import Foundation

public enum VeloraThemeCatalog {
    /// Loads the package's offline resources in their curated display order.
    /// Applications should retain their neutral appearance if loading fails.
    public static func bundled() throws -> [VeloraTheme] {
        guard let root = Bundle.module.resourceURL else { throw VeloraThemeError.missingResources }
        return try load(from: root)
    }

    private struct Catalog: Decodable { let format: Int; let themes: [String] }

    static func load(from root: URL) throws -> [VeloraTheme] {
        let catalogURL = root.appendingPathComponent("catalog.json")
        let data = try read(catalogURL)
        let catalog = try JSONDecoder().decode(Catalog.self, from: data)
        guard catalog.format == 1, (1...256).contains(catalog.themes.count),
              Set(catalog.themes).count == catalog.themes.count,
              catalog.themes.allSatisfy(VeloraTheme.isValidID) else {
            throw VeloraThemeError.invalidCatalog("Unsupported format, duplicate or invalid theme IDs")
        }
        let themes = root.appendingPathComponent("themes", isDirectory: true)
        try rejectSymlink(themes)
        return try catalog.themes.map { id in
            let folder = themes.appendingPathComponent(id, isDirectory: true)
            try rejectSymlink(folder)
            return try VeloraTheme.decode(read(folder.appendingPathComponent("velora-plugin.json")), expectedID: id)
        }
    }

    private static func rejectSymlink(_ url: URL) throws {
        if try url.resourceValues(forKeys: [.isSymbolicLinkKey]).isSymbolicLink == true {
            throw VeloraThemeError.invalidCatalog("Symbolic links are not allowed")
        }
    }

    private static func read(_ url: URL) throws -> Data {
        try rejectSymlink(url)
        let values = try url.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey])
        guard values.isRegularFile == true, let size = values.fileSize, size <= 32_768 else {
            throw VeloraThemeError.invalidCatalog("Missing or oversized resource")
        }
        return try Data(contentsOf: url)
    }
}
