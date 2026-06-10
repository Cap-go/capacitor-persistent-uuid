import { registerPlugin } from '@capacitor/core';

import type { PersistentUuidPlugin } from './definitions';

const PersistentUuid = registerPlugin<PersistentUuidPlugin>('PersistentUuid', {
  web: () => import('./web').then((m) => new m.PersistentUuidWeb()),
});

export * from './definitions';
export { PersistentUuid };
