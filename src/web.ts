import { WebPlugin } from '@capacitor/core';

import type {
  PersistentUuidOptions,
  PersistentUuidPlugin,
  PersistentUuidResult,
  PluginVersionResult,
} from './definitions';

const STORAGE_PREFIX = 'capgo:persistent-uuid:';
const DEFAULT_SCOPE = 'web';

const memoryStore = new Map<string, string>();

const normalizeScope = (options?: PersistentUuidOptions): string => {
  const scope = options?.scope?.trim();
  return scope && scope.length > 0 ? scope : DEFAULT_SCOPE;
};

const createUuid = (): string => {
  if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
    return crypto.randomUUID();
  }

  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (char) => {
    const random = Math.floor(Math.random() * 16);
    const value = char === 'x' ? random : (random & 0x3) | 0x8;
    return value.toString(16);
  });
};

const readValue = (key: string): string | null => {
  try {
    return globalThis.localStorage?.getItem(key) ?? memoryStore.get(key) ?? null;
  } catch {
    return memoryStore.get(key) ?? null;
  }
};

const writeValue = (key: string, value: string): void => {
  memoryStore.set(key, value);
  try {
    globalThis.localStorage?.setItem(key, value);
  } catch {
    // In-memory fallback already updated.
  }
};

export class PersistentUuidWeb extends WebPlugin implements PersistentUuidPlugin {
  async getId(options?: PersistentUuidOptions): Promise<PersistentUuidResult> {
    const scope = normalizeScope(options);
    const key = STORAGE_PREFIX + scope;
    const existing = readValue(key);

    if (existing) {
      return {
        id: existing,
        scope,
        created: false,
      };
    }

    const id = createUuid();
    writeValue(key, id);

    return {
      id,
      scope,
      created: true,
    };
  }

  async resetId(options?: PersistentUuidOptions): Promise<PersistentUuidResult> {
    const scope = normalizeScope(options);
    const id = createUuid();
    writeValue(STORAGE_PREFIX + scope, id);

    return {
      id,
      scope,
      created: true,
    };
  }

  async getPluginVersion(): Promise<PluginVersionResult> {
    return {
      version: 'web',
    };
  }
}
