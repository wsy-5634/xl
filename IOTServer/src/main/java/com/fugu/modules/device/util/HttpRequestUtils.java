package com.fugu.modules.device.util;

import cn.hutool.http.ssl.DefaultTrustManager;

import javax.net.ssl.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Map;

public class HttpRequestUtils {

    public static final String HTTP_GET = "GET";

    public static final String HTTP_POST = "POST";


    /**
     * 以post或get方式调用对方接口方法，
     * @param pathUrl
     */
    public static byte[] doPostOrGet(String pathUrl, String method, Map<String, String> headers){

        HttpsURLConnection conn = null;
        try {
            conn = getHttpsURLConnection(pathUrl, method);

            //设置通用的请求属性

            //添加自定义header
            for (Map.Entry<String, String> entry : headers.entrySet()) {
                conn.setRequestProperty(entry.getKey(), entry.getValue());
            }

            return getBytesFromStream(conn.getInputStream());
        } catch (Exception e) {
            e.printStackTrace();
        }finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
        return  null;
    }

    private static HttpsURLConnection getHttpsURLConnection(String uri, String method) throws IOException {
        SSLContext ctx = null;
        try {
            ctx = SSLContext.getInstance("TLS");
            ctx.init(new KeyManager[0], new TrustManager[] { new DefaultTrustManager() }, new SecureRandom());
        } catch (KeyManagementException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        SSLSocketFactory ssf = ctx.getSocketFactory();

        URL url = new URL(uri);
        HttpsURLConnection httpsConn = (HttpsURLConnection) url.openConnection();
        httpsConn.setSSLSocketFactory(ssf);
        httpsConn.setRequestProperty("Content-Type","application/x-www-form-urlencoded;charset=UTF-8");
        httpsConn.setRequestProperty("Authorization","username");
        httpsConn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.95 Safari/537.11");
        /*
        在握手期间，如果 URL 的主机名和服务器的标识主机名不匹配，
        则验证机制可以回调此接口的实现程序来确定是否应该允许此连接。
        策略可以是基于证书的或依赖于其他验证方案。
        当验证 URL 主机名使用的默认规则失败时使用这些回调。
         */
        httpsConn.setHostnameVerifier(new HostnameVerifier() {
            @Override
            public boolean verify(String arg0, SSLSession arg1) {
                return true;
            }
        });
        httpsConn.setRequestMethod(method);
        httpsConn.setDoInput(true);
        httpsConn.setDoOutput(true);
        return httpsConn;
    }

    private static byte[] getBytesFromStream(InputStream is) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] kb = new byte[1024];
        int len;
        while ((len = is.read(kb)) != -1) {
            baos.write(kb, 0, len);
        }
        byte[] bytes = baos.toByteArray();
        baos.close();
        is.close();
        return bytes;
    }
}
