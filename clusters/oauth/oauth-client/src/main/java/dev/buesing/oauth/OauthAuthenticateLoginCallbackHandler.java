package dev.buesing.oauth;

import java.io.IOException;
import java.util.Map;
import javax.security.auth.callback.Callback;
import javax.security.auth.callback.UnsupportedCallbackException;
import org.apache.kafka.common.KafkaException;
import org.apache.kafka.common.security.oauthbearer.OAuthBearerTokenCallback;
import org.apache.kafka.common.utils.Time;


public class OauthAuthenticateLoginCallbackHandler extends OauthAuthenticateCallbackHandler {

    private static final String OAUTH_LOGIN_GRANT_TYPE = "client_credentials";
    private static final String OAUTH_LOGIN_SCOPE = "broker.kafka";

    @Override
    public void handle(Callback[] callbacks) throws IOException, UnsupportedCallbackException {

        if (!isConfigured()) {
            throw new IllegalStateException("Callback handler not configured");
        }

        for (Callback callback : callbacks) {
            if (callback instanceof OAuthBearerTokenCallback)
                try {
                    handleCallback((OAuthBearerTokenCallback) callback);
                } catch (KafkaException e) {
                    throw new IOException(e.getMessage(), e);
                }
            else {
                throw new UnsupportedCallbackException(callback);
            }
        }
    }

    private void handleCallback(OAuthBearerTokenCallback callback) {

        if (callback.token() != null) {
            throw new IllegalArgumentException("Callback had a token already");
        }

        try {
            callback.token(login(null));
        } catch (final RuntimeException e) {
            throw new IllegalArgumentException("Null token returned from server", e);
        }
    }

    private OauthBearerTokenJwt login(String clientId) {

        long callTime = Time.SYSTEM.milliseconds();

        final String postData = "grant_type=" + OAUTH_LOGIN_GRANT_TYPE + "&" + "scope=" + OAUTH_LOGIN_SCOPE;

        Map<String, Object> resp = OauthHttpCalls.doHttpCall(tokenUrl, postData, authorization);

        if (resp != null) {
            String accessToken = (String) resp.get("access_token");
            long expiresIn = ((Integer) resp.get("expires_in")).longValue();
            return new OauthBearerTokenJwt(accessToken, expiresIn, callTime, clientId);
        } else {
            throw new RuntimeException("with resp null at login");
        }
    }


}