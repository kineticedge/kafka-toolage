package dev.buesing.oauth;


import java.io.IOException;
import java.util.Map;
import javax.security.auth.callback.Callback;
import javax.security.auth.callback.UnsupportedCallbackException;
import org.apache.kafka.common.KafkaException;
import org.apache.kafka.common.security.oauthbearer.OAuthBearerValidatorCallback;
import org.apache.kafka.common.security.oauthbearer.internals.unsecured.OAuthBearerValidationResult;
import org.apache.kafka.common.utils.Time;

public class OauthAuthenticateValidatorCallbackHandler extends OauthAuthenticateCallbackHandler {

    @Override
    public void handle(final Callback[] callbacks) throws IOException, UnsupportedCallbackException {

        if (!isConfigured()) {
            throw new IllegalStateException("Callback handler not configured");
        }

        for (Callback callback : callbacks) {
            if (callback instanceof OAuthBearerValidatorCallback)
                try {
                    handleCallback(((OAuthBearerValidatorCallback) callback));
                } catch (KafkaException e) {
                    throw new IOException(e.getMessage(), e);
                }
            else {
                throw new UnsupportedCallbackException(callback);
            }
        }
    }

    private void handleCallback(final OAuthBearerValidatorCallback callback) {

        if (callback.tokenValue() == null) {
            throw new IllegalArgumentException("Callback missing required token value");
        }

        OauthBearerTokenJwt token = introspectBearer(callback.tokenValue());

        if (Time.SYSTEM.milliseconds() > token.expirationTime()) {
            OAuthBearerValidationResult.newFailure("Expired Token, needs refresh!");
        }

        callback.token(token);
    }

    public OauthBearerTokenJwt introspectBearer(String accessToken) {

        OauthBearerTokenJwt result = null;

        final String data = "token=" + accessToken;

        Map<String, Object> resp = OauthHttpCalls.doHttpCall(introspectUrl, data, authorization);

        if (resp != null) {
            if ((boolean) resp.get("active")) {
                result = new OauthBearerTokenJwt(resp, accessToken);
            } else {
                throw new RuntimeException("Expired Token");
            }
        }

        return result;
    }

}
