package app.capgo.persistent_uuid;

import android.accounts.Account;
import android.accounts.AccountManager;
import android.content.Context;
import java.util.UUID;

public class PersistentUuid {

    static final String ACCOUNT_TYPE = "app.capgo.persistent_uuid";
    private static final String ACCOUNT_PREFIX = "PersistentUuid:";
    private static final String USERDATA_UUID = "uuid";
    private static final String FALLBACK_SCOPE = "default";
    private final Context context;

    public PersistentUuid(Context context) {
        this.context = context.getApplicationContext();
    }

    public Result getId(String scope) {
        String normalizedScope = normalizeScope(scope);
        Account account = getOrCreateAccount(normalizedScope);
        AccountManager accountManager = AccountManager.get(context);
        String existing = accountManager.getUserData(account, USERDATA_UUID);

        if (existing != null && !existing.isEmpty()) {
            return new Result(existing, normalizedScope, false);
        }

        String id = createUuid();
        accountManager.setUserData(account, USERDATA_UUID, id);
        return new Result(id, normalizedScope, true);
    }

    public Result resetId(String scope) {
        String normalizedScope = normalizeScope(scope);
        Account account = getOrCreateAccount(normalizedScope);
        String id = createUuid();
        AccountManager.get(context).setUserData(account, USERDATA_UUID, id);
        return new Result(id, normalizedScope, true);
    }

    public String getPluginVersion() {
        return "8.0.0";
    }

    private Account getOrCreateAccount(String scope) {
        AccountManager accountManager = AccountManager.get(context);
        Account existing = findAccount(accountManager, scope);
        if (existing != null) {
            return existing;
        }

        Account account = new Account(accountName(scope), ACCOUNT_TYPE);
        if (accountManager.addAccountExplicitly(account, null, null)) {
            return account;
        }

        existing = findAccount(accountManager, scope);
        if (existing != null) {
            return existing;
        }

        throw new IllegalStateException("Unable to create persistent UUID account");
    }

    private Account findAccount(AccountManager accountManager, String scope) {
        String accountName = accountName(scope);
        for (Account account : accountManager.getAccountsByType(ACCOUNT_TYPE)) {
            if (accountName.equals(account.name)) {
                return account;
            }
        }
        return null;
    }

    private String accountName(String scope) {
        return ACCOUNT_PREFIX + scope;
    }

    private String normalizeScope(String scope) {
        if (scope != null) {
            String trimmed = scope.trim();
            if (!trimmed.isEmpty()) {
                return trimmed;
            }
        }

        String packageName = context.getPackageName();
        if (packageName != null && !packageName.isEmpty()) {
            return packageName;
        }

        return FALLBACK_SCOPE;
    }

    private String createUuid() {
        return UUID.randomUUID().toString();
    }

    public static class Result {

        public final String id;
        public final String scope;
        public final boolean created;

        Result(String id, String scope, boolean created) {
            this.id = id;
            this.scope = scope;
            this.created = created;
        }
    }
}
