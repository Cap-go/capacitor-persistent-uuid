# @capgo/capacitor-persistent-uuid

Get a stable app-scoped UUID in your Capacitor app with native persistence designed to survive reinstalls and store updates on iOS and Android, without device identifiers or extra permissions.

<a href="https://capgo.app/?ref=plugin_persistent_uuid"><img src="https://capgo.app/readme-banner.svg?repo=Cap-go/capacitor-persistent-uuid" alt="Capgo - Instant updates for Capacitor" /></a>

<div align="center">
  <p><b>Capgo</b>: open-source live updates for Ionic and Capacitor apps. Ship OTA fixes and features instantly, without waiting for app store review.</p>
  <h2><a href="https://capgo.app/register/?ref=plugin_persistent_uuid">➡️ Get started for free</a></h2>
  <p>14-day unlimited free trial. No credit card required</p>
  <p><a href="https://capgo.app/consulting/?ref=plugin_persistent_uuid">Missing a feature? We'll build the plugin for you 💪</a></p>
</div>

<p align="center">
  <img src="https://raw.githubusercontent.com/Cap-go/capacitor-persistent-uuid/main/assets/github-social-preview.png" alt="@capgo/capacitor-persistent-uuid for Capacitor apps" width="300" />
</p>

## Key features

- **Stable ID**: `getId()` returns the UUID, creating one on first use.
- **Reset**: `resetId()` replaces the stored UUID.
- **Scopes**: pass a custom `scope` to keep one ID across debug and production builds.
- **Native persistence**: Keychain on iOS and `AccountManager` on Android.
- **Platforms**: iOS, Android and Web. Web stores the ID in `localStorage`, which does not survive a reinstall or clearing site data.

## Documentation

The most complete doc is available here: https://capgo.app/docs/plugins/persistent-uuid/

## Compatibility

| Plugin version | Capacitor compatibility | Maintained |
| -------------- | ----------------------- | ---------- |
| v8.*.*         | v8.*.*                  | Yes        |
| v7.*.*         | v7.*.*                  | On demand  |
| v6.*.*         | v6.*.*                  | On demand  |

## Install

You can use our AI-Assisted Setup to install the plugin. Add the Capgo skills to your AI tool using the following command:

```bash
npx skills add https://github.com/cap-go/capacitor-skills --skill capacitor-plugins
```

Then use the following prompt:

```text
Use the `capacitor-plugins` skill from `cap-go/capacitor-skills` to install the `@capgo/capacitor-persistent-uuid` plugin in my project.
```

If you prefer Manual Setup, install the plugin by running the following commands and follow the platform-specific instructions below:

~~~bash
npm install @capgo/capacitor-persistent-uuid
npx cap sync
~~~

## Usage

~~~typescript
import { PersistentUuid } from '@capgo/capacitor-persistent-uuid';

const { id, created, scope } = await PersistentUuid.getId();
console.log(id, created, scope);

// Use a custom scope when debug and production builds use different package IDs
// but should share one persistent UUID.
const scoped = await PersistentUuid.getId({ scope: 'com.example.app' });
console.log(scoped.id);

// Rotate the UUID when the user logs out or requests data reset.
const replacement = await PersistentUuid.resetId();
console.log(replacement.id);
~~~

## Persistence model

- Android stores the UUID in an AccountManager account owned by the plugin authenticator. The default scope is the app package name, so the UUID can survive uninstall/reinstall and debug vs Play installs with different signing keys when the package name stays the same.
- iOS stores the UUID in Keychain using a device-only item. The default scope is the bundle identifier, and the value survives app updates and iOS updates. Keychain access still follows Apple team/bundle access rules.
- Web stores the UUID in localStorage. It is a development fallback, not a reinstall-resistant identifier.
- This is not a hardware identifier and does not survive factory reset, user account removal, Keychain clearing, or an explicit resetId() call.

## API

<docgen-index>

* [`getId(...)`](#getid)
* [`resetId(...)`](#resetid)
* [`getPluginVersion()`](#getpluginversion)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

Persistent UUID API.

### getId(...)

```typescript
getId(options?: PersistentUuidOptions | undefined) => Promise<PersistentUuidResult>
```

Read the persistent UUID, creating one when none exists for the selected scope.

| Param         | Type                                                                    |
| ------------- | ----------------------------------------------------------------------- |
| **`options`** | <code><a href="#persistentuuidoptions">PersistentUuidOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#persistentuuidresult">PersistentUuidResult</a>&gt;</code>

--------------------


### resetId(...)

```typescript
resetId(options?: PersistentUuidOptions | undefined) => Promise<PersistentUuidResult>
```

Replace the stored UUID for the selected scope and return the new value.

| Param         | Type                                                                    |
| ------------- | ----------------------------------------------------------------------- |
| **`options`** | <code><a href="#persistentuuidoptions">PersistentUuidOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#persistentuuidresult">PersistentUuidResult</a>&gt;</code>

--------------------


### getPluginVersion()

```typescript
getPluginVersion() => Promise<PluginVersionResult>
```

Returns the platform implementation version marker.

**Returns:** <code>Promise&lt;<a href="#pluginversionresult">PluginVersionResult</a>&gt;</code>

--------------------


### Interfaces


#### PersistentUuidResult

Persistent UUID payload.

| Prop          | Type                 | Description                                          |
| ------------- | -------------------- | ---------------------------------------------------- |
| **`id`**      | <code>string</code>  | RFC 4122 UUID generated once for the selected scope. |
| **`scope`**   | <code>string</code>  | The scope used to read or create the UUID.           |
| **`created`** | <code>boolean</code> | True when this call generated and stored a new UUID. |


#### PersistentUuidOptions

Options used when reading or resetting the persistent UUID.

| Prop        | Type                | Description                                                                                                                                                                                                                                   |
| ----------- | ------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`scope`** | <code>string</code> | Optional namespace for the UUID. By default, native platforms use the app package/bundle identifier. Pass a stable custom scope when debug and production builds use different package identifiers but should share the same persistent UUID. |


#### PluginVersionResult

Plugin version payload.

| Prop          | Type                | Description                                                 |
| ------------- | ------------------- | ----------------------------------------------------------- |
| **`version`** | <code>string</code> | Version identifier returned by the platform implementation. |

</docgen-api>
