import Foundation
import Capacitor

@objc(PersistentUuidPlugin)
public class PersistentUuidPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "PersistentUuidPlugin"
    public let jsName = "PersistentUuid"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "getId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "resetId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPluginVersion", returnType: CAPPluginReturnPromise)
    ]

    private let implementation = PersistentUuid()

    @objc func getId(_ call: CAPPluginCall) {
        do {
            call.resolve(try implementation.getId(call.getString("scope")))
        } catch {
            call.reject("Failed to get persistent UUID: \(error.localizedDescription)")
        }
    }

    @objc func resetId(_ call: CAPPluginCall) {
        do {
            call.resolve(try implementation.resetId(call.getString("scope")))
        } catch {
            call.reject("Failed to reset persistent UUID: \(error.localizedDescription)")
        }
    }

    @objc func getPluginVersion(_ call: CAPPluginCall) {
        call.resolve([
            "version": implementation.getPluginVersion()
        ])
    }
}
