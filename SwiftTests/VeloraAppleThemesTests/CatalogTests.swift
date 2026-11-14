import Foundation
import XCTest
@testable import VeloraAppleThemes

final class CatalogTests: XCTestCase {
    func testPackageResourcesLoadAllThemesInDisplayOrder() throws {
        let themes = try VeloraThemeCatalog.bundled()
        XCTAssertEqual(themes.count, 47)
        XCTAssertEqual(Array(themes.prefix(3).map(\.id)), ["linen", "ember", "harbor"])
        XCTAssertEqual(themes.last?.id, "crimson")
        XCTAssertEqual(Set(themes.map(\.id)).count, themes.count)
        XCTAssertTrue(Set(themes.map(\.id)).isDisjoint(with: VeloraTheme.reservedIDs))
    }

    func testNativeColorsAndMetadataRetainExistingValues() throws {
        let themes = try VeloraThemeCatalog.bundled()
        let linen = try XCTUnwrap(themes.first { $0.id == "linen" })
        XCTAssertEqual(linen.backgroundHex, "faf8f4")
        XCTAssertEqual(linen.surfaceHex, "fffdfa")
        XCTAssertEqual(linen.accentHex, "bc531c")
        XCTAssertEqual(linen.colorScheme, .light)
        XCTAssertEqual(linen.colors["player-surface"], "#faf8f4f5")
        XCTAssertEqual(linen.repository.absoluteString, "https://github.com/JROkkerman/Velora-Apple-Themes")
        XCTAssertEqual(themes.first { $0.id == "crimson" }?.colorScheme, .dark)
    }

    private func manifest() throws -> [String: Any] {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let data = try Data(contentsOf: root.appendingPathComponent("themes/linen/velora-plugin.json"))
        return try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

    func testRejectsUnsupportedVersionsPlatformsAndReservedIDs() throws {
        for (field, value) in [("plugin_api", 2 as Any), ("manifest_version", true), ("platform", "web"), ("id", "system"), ("id", "../linen")] {
            var json = try manifest()
            json[field] = value
            let data = try JSONSerialization.data(withJSONObject: json)
            XCTAssertThrowsError(try VeloraTheme.decode(data, expectedID: "linen"), field)
        }
    }

    func testRejectsInvalidOrTranslucentNativeColorsAndExtraFields() throws {
        for value in ["red", "url(https://example.com)", "#ffffff00"] {
            var json = try manifest()
            var colors = try XCTUnwrap(json["colors"] as? [String: String])
            colors["paper"] = value
            json["colors"] = colors
            XCTAssertThrowsError(try VeloraTheme.decode(JSONSerialization.data(withJSONObject: json), expectedID: "linen"))
        }
        var json = try manifest()
        json["script"] = "unwanted"
        XCTAssertThrowsError(try VeloraTheme.decode(JSONSerialization.data(withJSONObject: json), expectedID: "linen"))
    }

    func testMissingBundleFailsWithErrorInsteadOfCrashing() {
        XCTAssertThrowsError(try VeloraThemeCatalog.load(from: URL(fileURLWithPath: "/missing-velora-theme-resources")))
    }

    func testCatalogRejectsDuplicateIDsAndPathTraversal() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        for ids in [["linen", "linen"], ["../linen"], ["system"]] {
            try JSONSerialization.data(withJSONObject: ["format": 1, "themes": ids]).write(to: root.appendingPathComponent("catalog.json"))
            XCTAssertThrowsError(try VeloraThemeCatalog.load(from: root))
        }
    }
}
