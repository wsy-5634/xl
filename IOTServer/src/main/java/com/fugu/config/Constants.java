package com.fugu.config;

import java.util.HashMap;
import java.util.Map;

/**
 *  <p> 全局常用变量 </p>
 *
 * @description :
 * @author : fugu
 * @date : 2019/8/22 9:09
 */
public class Constants {

    public static String IMG_DOMAIN = "";

    /**
     * 接口url
     */
    public static Map<String,String> URL_MAPPING_MAP = new HashMap<>();

    /**
     *  获取项目根目录
     */
    public static String PROJECT_ROOT_DIRECTORY = System.getProperty("user.dir");

    /**
     * SHA-256加密盐值
     */
    public static String SALT = "fugu";

    /**
     * 请求头 - token  【注：ShiroConfig中放行】
     */
    public static final String REQUEST_HEADER = "X-Token";


    public static final String UBAN_REQUEST_GET_ACCESSTOKEN_URL = "https://openapi.e.uban360.com/platform/api/token/get";

    public static final String UBAN_REQUEST_LOGIN_URL = "https://openapi.e.uban360.com/platform/api/auth/login";

    public static final String FILE_BASE_PATH = "/usr/content/files/";

//    public static final String FILE_BASE_PATH = "D:/content/files/";
}
