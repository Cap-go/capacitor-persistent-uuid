/**
 * Options used when reading or resetting the persistent UUID.
 */
export interface PersistentUuidOptions {
  /**
   * Optional namespace for the UUID.
   *
   * By default, native platforms use the app package/bundle identifier. Pass a
   * stable custom scope when debug and production builds use different package
   * identifiers but should share the same persistent UUID.
   */
  scope?: string;
}

/**
 * Persistent UUID payload.
 */
export interface PersistentUuidResult {
  /**
   * RFC 4122 UUID generated once for the selected scope.
   */
  id: string;

  /**
   * The scope used to read or create the UUID.
   */
  scope: string;

  /**
   * True when this call generated and stored a new UUID.
   */
  created: boolean;
}

/**
 * Plugin version payload.
 */
export interface PluginVersionResult {
  /**
   * Version identifier returned by the platform implementation.
   */
  version: string;
}

/**
 * Persistent UUID API.
 */
export interface PersistentUuidPlugin {
  /**
   * Read the persistent UUID, creating one when none exists for the selected scope.
   */
  getId(options?: PersistentUuidOptions): Promise<PersistentUuidResult>;

  /**
   * Replace the stored UUID for the selected scope and return the new value.
   */
  resetId(options?: PersistentUuidOptions): Promise<PersistentUuidResult>;

  /**
   * Returns the platform implementation version marker.
   */
  getPluginVersion(): Promise<PluginVersionResult>;
}
