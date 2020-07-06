package com.fugu.modules.system.api;


import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fugu.modules.common.api.BaseController;
import com.fugu.modules.system.service.ILoginService;
import com.fugu.modules.system.util.HttpRequestUtils;
import com.fugu.config.Constants;
import com.fugu.modules.common.dto.output.ApiResult;
import com.fugu.modules.system.entity.User;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.util.TextUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotBlank;
import java.util.HashMap;
import java.util.Map;

/**
 *  <p> 授权模块 </p>
 *
 * @description:
 * @author: fugu
 * @date: 2019/8/17 0017 19:41
 */
@RestController
@RequestMapping("/api/auth")
@Api(description = "系统登录接口")
@Slf4j
public class LoginController extends BaseController {


    /**
     * 管理员登录
     * 用户名密码不为空，判断是否是管理员身份
     */
//    @PostMapping("/sys/login")
// //   @ApiOperation(value = "登录管理后台系统", httpMethod = "POST", response = ApiResult.class, notes = "登录管理后台系统")
//    public ApiResult sysLogin(@RequestBody UserQueryPara para) throws Exception {
//        // 账号登录
//        if (StringUtils.isBlank(para.getLoginname()) || StringUtils.isBlank(para.getPassword())) {
//            return ApiResult.fail("请输入正确的账号和密码");
//        }
//        User user = loginService.getLoginedUser(para.getLoginname());
//        //判断用户是不是管理员和账户状态，1是管理员
//        if (user == null || !user.getFlag().equalsIgnoreCase("1")) {
//            return ApiResult.fail("该用户不能登陆后台管理系统");
//        }
//        return loginWithUserName(para.getLoginname(), para.getPassword());
//    }

    @PostMapping("/login")
    @ApiOperation(value = "测试登录系统", httpMethod = "POST", response = ApiResult.class, notes = "测试登录系统")
    public ApiResult loging(@RequestParam("loginname") String loginname,
                            @RequestParam("pwd") String pwd){
        if (loginname.equals("admin")  &&  pwd.equals("123")) {
            JSONObject json = new JSONObject();

            System.out.println("loginname" + loginname);
            System.out.println("pwd" + pwd);
            return ApiResult.ok(1, "登录成功", json);
        }
        return ApiResult.fail("登录失败");
    }
    
    @PostMapping("/login1")
    @ApiOperation(value = "登录系统", httpMethod = "POST", response = ApiResult.class, notes = "登录系统")
    public ApiResult login(@RequestParam("loginnam") String loginname,
                           @RequestParam("pwd") String pwd) throws Exception {

            log.info("----------------------------------------------  用户开始登录！  ------------------------------");

        // 账号登录
        if (StringUtils.isBlank(loginname) || StringUtils.isBlank(pwd)) {
            return ApiResult.fail("请输入正确的账号和密码");
        }
        return loginWithUserName(loginname,pwd);
    }

    private ApiResult loginWithUserName(String loginname, String pwd){ //}, String token) {
        // 拿到当前用户(可能还是游客，没有登录)
        Subject currentUser = SecurityUtils.getSubject();
        // 如果这个用户没有登录,进行登录功能
        if (!currentUser.isAuthenticated()){// || TextUtils.isEmpty(token)) {
            try {
                //将明文密码加密，用于登录
//                String password = MD5Util.encrypt(loginname.toLowerCase(), pwd);
                String password = pwd;
                // 验证身份和登陆
                UsernamePasswordToken token = new UsernamePasswordToken(loginname, password);
                // String token = MD5Utils.encrypt( String.valueOf( System.currentTimeMillis() ) );

                currentUser.login(token);
//                User user = userService.findUserByname(loginname);
                JSONObject json = new JSONObject();
//                json.put("flag",user.getRole_id());
//                json.put("token", ShiroUtils.getSession().getId().toString());
                log.info("----------------------------------------------  登录成功！  ------------------------------");
                return ApiResult.ok(1,"登录成功",json);
            } catch (UnknownAccountException e) {
                return ApiResult.fail("账号不存在!");
            } catch (IncorrectCredentialsException e) {
                return ApiResult.fail("用户名或者密码错误!");
            } catch (LockedAccountException e) {
                return ApiResult.fail("登录失败，该用户已被冻结!");
            } catch (AuthenticationException e) {
                return ApiResult.fail("未知错误!");
            }
        }
        log.info("----------------------------------------------  登录失败！  ------------------------------");
        return ApiResult.fail("登录失败");
    }

    /**
     * 移动云办公授权登录
     * @param token
     * @return
     * @throws Exception
     */
    public void mobileCloudLogin(String token, String appId, String appSecret) throws Exception {

        Map<String, String> headers = new HashMap<>();
        headers.put("appId", appId);
        headers.put("appSecret", appSecret);
        //请求AccessToken
        byte[] returnBytes = HttpRequestUtils.doPostOrGet(Constants.UBAN_REQUEST_GET_ACCESSTOKEN_URL + "?flags=1", HttpRequestUtils.HTTP_GET, headers);
        if (returnBytes == null) {

        }
        String returnedString = new String(returnBytes);
        log.info("请求accessToken成功！" + returnedString);
        JSONObject jsonObject = JSONObject.parseObject(returnedString).getJSONObject("data");
        if (jsonObject == null) {

        }
        //Uban登录
        headers.clear();
        headers.put("accessToken", jsonObject.getString("accessToken"));
        headers.put("token", token);
        byte[] jsonBytes = HttpRequestUtils.doPostOrGet(Constants.UBAN_REQUEST_LOGIN_URL + "?flags=15", HttpRequestUtils.HTTP_GET, headers);
        if (jsonBytes == null) {

        }
        String jsonString = new String(jsonBytes);
        log.info("ubun登录成功！" + jsonString);
        JSONObject object = JSONObject.parseObject(jsonString).getJSONObject("data");
        if (object == null) {

        }

        String userId = object.getString("uid");
        String mobile = object.getString("mobile");
        String name = object.getString("name");
        String deptName = object.getString("orgName");
        String deptSecret = object.getString("orgSecret");
        String role = null;//默认设置为1，0--代表是企业管理员
        if (object.containsKey("roles")) {
           JSONArray roleArray = object.getJSONArray("roles");
            role = roleArray.toJSONString();
        }

//        LoginQueryPara result = new LoginQueryPara();
        // 通过手机号获取用户
//        User user = loginService.getLoginedUserByMobile(mobile);
//        if ( user == null) {//用户没有注册
//            user = new User();
//            user.setLoginname(mobile);
//            user.setName(name);
//            user.setPhone(mobile);
//
//            user.setMobileUserId(userId);
//            String password = loginService.insertUser(user, deptName, deptSecret, role);
//
//            result.setLoginname(user.getLoginname());
//            result.setPassword(password);
//        } else {
//            result.setLoginname(user.getLoginname());
//            result.setPassword(user.getPwd());
//        }

    }

//    /**
//     * QQ 授权登录
//     * @param openID
//     * @param accessToken
//     * @return
//     * @throws QQConnectException
//     */
//    public UserQueryPara qqLogin( String openID, String accessToken ) throws QQConnectException {
//       UserQueryPara result = new UserQueryPara();
//       // 通过OpenID获取QQ用户登录信息对象(Oppen_ID代表着QQ用户的唯一标识)
//       UserInfo qzoneUserInfo = new UserInfo(accessToken, openID);
//       // 获取用户信息对象(只获取nickename、Gender、头像)
//       UserInfoBean userInfoBean = qzoneUserInfo.getUserInfo();
//       if (userInfoBean.getRet() == 0) {
//          String avatar = userInfoBean.getAvatar().getAvatarURL100();
//          // 判断qq授权登录的用户是否拥有账号，如果没有则自动注册一个
//          User userInfo = userMapper.getUserInfoByQQ( openID );
//          if ( userInfo == null) {
//              User user = new User();
//              // 默认将QQ注册的用户账号设置为openID
//
//              user.setUsername( openID );
//              user.setQqOppenId( openID );
//              user.setPwd( "123456" );
//              user.setPassword( SHA256Util.sha256( user.getPwd(), Constants.SALT ) );
//              user.setNickName( StringUtils.isBlank( userInfoBean.getNickname() ) ? "无名氏" : userInfoBean.getNickname() );
//              user.setAvatar( avatar );
//              user.setSex( StringUtils.isBlank( userInfoBean.getGender() ) ? "0" : ( "男".equals( userInfoBean.getGender() ) ? "0" : "1") );
//              user.setSalt( Constants.SALT );
//              user.setFlag("1");
//              userMapper.insert( user );
//
//              // 分配权限
//              UserRole userRole = new UserRole();
//              userRole.setRoleId( 2 );
//              userRole.setUserId( user.getId() );
//              userRoleMapper.insert( userRole );
//
//              result.setUsername( user.getUsername() );
//              result.setPassword( user.getPwd() );
//          } else {
//              userInfo.setAvatar( avatar );
//              userMapper.updateById( userInfo );
//
//              result.setUsername( userInfo.getUsername() );
//              result.setPassword( userInfo.getPwd() );
//          }
//       }
//       return result;
//    }

//    @PostMapping("/logout")
//    @ApiOperation(value = "退出系统", httpMethod = "POST", response = ApiResult.class, notes = "退出系统")
//    public ApiResult logout(@RequestParam("token") String token) {
//       // 更新token
//        User user = loginService.getLoginedUserByToken(token);
//        if (user != null) {
//            ShiroUtils.logout();
//            ShiroUtils.deleteCache(user.getLoginname(), true);
//            return ApiResult.ok("退出系统成功");
//        }
//        return  ApiResult.fail("退出失败！");
////       User user = ShiroUtils.getUserInfo();
////       User userNew = userMapper.selectUserByUsername( user.getUsername() );
////       userNew.setToken( MD5Utils.encrypt( String.valueOf( System.currentTimeMillis() ) ) );
////       userMapper.updateById( userNew );
//       // 用户登出
//    }

    /**
     * 未登录
     */
    @PostMapping("/unLogin")
    @ApiOperation(value = "未登录", response = ApiResult.class, notes = "未登录")
    public ApiResult unLogin(){
       return ApiResult.fail(401, "未登录");
    }

    /**
     * 未授权
     */
    @PostMapping("/unauth")
//    @ApiOperation(value = "未授权", response = ApiResult.class, notes = "未授权")
    public ApiResult unauth(){
        return ApiResult.ok(500,"未授权");
    }

    /**
     * token过期
     */
    @PostMapping("/tokenExpired")
//    @ApiOperation(value = "token过期", response = ApiResult.class, notes = "token过期")
    public ApiResult tokenExpired(){
       return ApiResult.ok(401,"token过期，请重新登录");
    }

    /**
     * 被挤下线
     */
    @PostMapping("/downline")
//    @ApiOperation(value = "被挤下线", response = ApiResult.class, notes = "被挤下线")
    public ApiResult downline() {
        return ApiResult.ok(401, "您的账号已在其他地方登录，被挤下线，请重新登录！");
    }
}
