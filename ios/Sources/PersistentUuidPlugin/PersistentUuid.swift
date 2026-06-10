import Foundation
import Security

@objc public class PersistentUuid: NSObject {
    private let service = "app.capgo.persistent_uuid"
    private let accountPrefix = "PersistentUuid:"
    private let fallbackScope = "default"

    @objc public func getId(_ scope: String?) throws -> [String: Any] {
        let normalizedScope = normalizeScope(scope)
        if let existing = try readUuid(scope: normalizedScope) {
            return [
                "id": existing,
                "scope": normalizedScope,
                "created": false
            ]
        }

        let id = createUuid()
        try saveUuid(id, scope: normalizedScope)
        return [
            "id": id,
            "scope": normalizedScope,
            "created": true
        ]
    }

    @objc public func resetId(_ scope: String?) throws -> [String: Any] {
        let normalizedScope = normalizeScope(scope)
        let id = createUuid()
        try saveUuid(id, scope: normalizedScope)
        return [
            "id": id,
            "scope": normalizedScope,
            "created": true
        ]
    }

    @objc public func getPluginVersion() -> String {
        return "8.0.0"
    }

    private func normalizeScope(_ scope: String?) -> String {
        if let trimmed = scope?.trimmingCharacters(in: .whitespacesAndNewlines), !trimmed.isEmpty {
            return trimmed
        }

        return Bundle.main.bundleIdentifier ?? fallbackScope
    }

    private func accountName(scope: String) -> String {
        return "\(accountPrefix)\(scope)"
    }

    private func createUuid() -> String {
        return UUID().uuidString.lowercased()
    }

    private func baseQuery(scope: String) -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: accountName(scope: scope)
        ]
    }

    private func readUuid(scope: String) throws -> String? {
        var query = baseQuery(scope: scope)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(status),
                userInfo: [NSLocalizedDescriptionKey: "Keychain read failed: \(status)"]
            )
        }

        guard let data = item as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    private func saveUuid(_ id: String, scope: String) throws {
        let data = Data(id.utf8)
        let query = baseQuery(scope: scope)
        let update: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let updateStatus = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if updateStatus == errSecSuccess {
            return
        }

        guard updateStatus == errSecItemNotFound else {
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(updateStatus),
                userInfo: [NSLocalizedDescriptionKey: "Keychain update failed: \(updateStatus)"]
            )
        }

        var attributes = query
        attributes[kSecValueData as String] = data
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let addStatus = SecItemAdd(attributes as CFDictionary, nil)
        guard addStatus == errSecSuccess else {
            throw NSError(
                domain: NSOSStatusErrorDomain,
                code: Int(addStatus),
                userInfo: [NSLocalizedDescriptionKey: "Keychain save failed: \(addStatus)"]
            )
        }
    }
}
