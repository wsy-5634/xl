package com.fugu.modules.system.service;

import com.baomidou.mybatisplus.service.IService;
//import com.fugu.modules.system.dto.input.UserQueryPara;
import com.fugu.modules.system.entity.User;

/**
 * <p>  登录   ---  服务类 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
public interface ILoginService  {

    //判断姓名是否为空，不为空则返回user对象
    User getLoginedUser(String loginname);

    User getLoginedUserByToken(String token);

    User getLoginedUserById(int userId);

    User getLoginedUserByMobile(String phone);

    String insertUser(User user, String deptName, String deptSecret, String role);


}
