package dev.buesing.oauth;

import java.nio.charset.StandardCharsets;
import java.util.*;
import javax.security.auth.login.AppConfigurationEntry;
import org.apache.kafka.common.security.auth.AuthenticateCallbackHandler;
import org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule;

public abstract class OauthAuthenticateCallbackHandler implements AuthenticateCallbackHandler {


    protected String introspectUrl;
    protected String tokenUrl;
    protected String authorization;

    private boolean configured = false;

    @Override
    public void configure(Map<String, ?> map, String saslMechanism, List<AppConfigurationEntry> jaasConfigEntries) {

        if (!OAuthBearerLoginModule.OAUTHBEARER_MECHANISM.equals(saslMechanism))
            throw new IllegalArgumentException(String.format("Unexpected SASL mechanism: %s", saslMechanism));
        if (Objects.requireNonNull(jaasConfigEntries).size() != 1 || jaasConfigEntries.get(0) == null)
            throw new IllegalArgumentException(
                    String.format("Must supply exactly 1 non-null JAAS mechanism configuration (size was %d)",
                            jaasConfigEntries.size()));

        final Map<String, String> moduleOptions = getModuleOptions(jaasConfigEntries);

        // TODO validate within the subclass that it is configured
        introspectUrl = moduleOptions.getOrDefault("introspectUrl", "");
        tokenUrl = moduleOptions.getOrDefault("tokenUrl", "");

        authorization = encodeAuthorization(moduleOptions);

        configured = true;
    }

    @Override
    public void close() {
    }

    public boolean isConfigured() {
        return this.configured;
    }

    @SuppressWarnings("unchecked")
    protected Map<String, String> getModuleOptions(List<AppConfigurationEntry> jaasConfigEntries) {
        return Collections.unmodifiableMap((Map<String, String>) jaasConfigEntries.get(0).getOptions());
    }

    protected String encodeAuthorization(Map<String, String> moduleOptions) {
        return encode(moduleOptions.getOrDefault("username", ""), moduleOptions.getOrDefault("password", ""));
    }

    protected static String encode(final String username, final String password) {

        String bearer = username + ":" + password;

        String encoded = new String(Base64.getEncoder().encode(bearer.getBytes(StandardCharsets.UTF_8)), StandardCharsets.UTF_8);

        return "Basic " + encoded;
    }



}
