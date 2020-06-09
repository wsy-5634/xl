package com.fugu.modules.system.service;

import com.baomidou.mybatisplus.service.IService;
import com.fugu.modules.system.dto.input.UserQueryPara;
import com.fugu.modules.system.entity.User;

/**
 * <p>  登录   ---  服务类 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
public interface ILoginService extends IService<User> {


    User getLoginedUser(String username);

    User getLoginedUserByToken(String token);

    User getLoginedUserById(int userId);

    User getLoginedUserByMobile(String mobile);

    String insertUser(User user, String deptName, String deptSecret, String role);
}
