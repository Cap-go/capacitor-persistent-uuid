package app.capgo.persistent_uuid;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "PersistentUuid")
public class PersistentUuidPlugin extends Plugin {

    private PersistentUuid implementation;

    @Override
    public void load() {
        super.load();
        implementation = new PersistentUuid(getContext());
    }

    @PluginMethod
    public void getId(PluginCall call) {
        try {
            PersistentUuid.Result result = implementation.getId(call.getString("scope"));
            call.resolve(toJsObject(result));
        } catch (Exception exception) {
            call.reject("Failed to get persistent UUID", exception);
        }
    }

    @PluginMethod
    public void resetId(PluginCall call) {
        try {
            PersistentUuid.Result result = implementation.resetId(call.getString("scope"));
            call.resolve(toJsObject(result));
        } catch (Exception exception) {
            call.reject("Failed to reset persistent UUID", exception);
        }
    }

    @PluginMethod
    public void getPluginVersion(PluginCall call) {
        JSObject ret = new JSObject();
        ret.put("version", implementation.getPluginVersion());
        call.resolve(ret);
    }

    private JSObject toJsObject(PersistentUuid.Result result) {
        JSObject ret = new JSObject();
        ret.put("id", result.id);
        ret.put("scope", result.scope);
        ret.put("created", result.created);
        return ret;
    }
}
