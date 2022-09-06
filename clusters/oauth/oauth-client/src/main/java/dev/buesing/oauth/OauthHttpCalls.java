package dev.buesing.oauth;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OauthHttpCalls {

    private static final boolean OAUTH_WITH_SSL = false; // (Boolean) getEnvironmentVariables("OAUTH_WITH_SSL", true);

    private static final Logger log = LoggerFactory.getLogger(OauthHttpCalls.class);

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    private static final TypeReference<Map<String, Object>> MAP_TYPE_REFERENCE = new TypeReference<Map<String, Object>>() {
    };

//    private static final boolean OAUTH_ACCEPT_UNSECURE_SERVER = true; //(Boolean) getEnvironmentVariables("OAUTH_ACCEPT_UNSECURE_SERVER", false);
//
//    public static void acceptUnsecureServer() {
//        if (OAUTH_ACCEPT_UNSECURE_SERVER) {
//            TrustManager[] trustAllCerts = new TrustManager[]{
//                    new X509TrustManager() {
//                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
//                            return null;
//                        }
//
//                        public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
//                        }
//
//                        public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
//                        }
//                    }
//            };
//            try {
//                SSLContext sc = SSLContext.getInstance("SSL");
//                sc.init(null, trustAllCerts, new java.security.SecureRandom());
//                HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
//            } catch (final NoSuchAlgorithmException | KeyManagementException e) {
//                throw new RuntimeException(e);
//            }
//        }
//    }

    public static Map<String, Object> doHttpCall(String urlStr, String postParameters, String oauthToken) {
        try {
            log.debug("calling url={}", urlStr);
            //acceptUnsecureServer();

            final byte[] postData = postParameters.getBytes(StandardCharsets.UTF_8);

            // https?
            URL url = new URL( urlStr);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setInstanceFollowRedirects(true);
            con.setRequestMethod("POST");
            con.setRequestProperty("Authorization", oauthToken);
            con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            con.setRequestProperty("charset", "utf-8");
            con.setRequestProperty("Content-Length", Integer.toString(postData.length));
            con.setUseCaches(false);
            con.setDoOutput(true);

            try (DataOutputStream wr = new DataOutputStream(con.getOutputStream())) {
                wr.write(postData);
            }

            int responseCode = con.getResponseCode();
            if (responseCode == 200) {
                return parseResponse(con.getInputStream());
            } else {
                throw new RuntimeException("Return code " + responseCode);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }


    private static Map<String, Object> parseResponse(final InputStream inputStream) {
        try {
            return OBJECT_MAPPER.readValue(toString(inputStream), MAP_TYPE_REFERENCE);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static String toString(final InputStream inputStream) throws IOException {

        final StringBuilder response = new StringBuilder();

        try (Reader reader = new BufferedReader(new InputStreamReader(inputStream))) {
            int c;
            while ((c = reader.read()) != -1) {
                response.append((char) c);
            }
        }

        return response.toString();
    }


}