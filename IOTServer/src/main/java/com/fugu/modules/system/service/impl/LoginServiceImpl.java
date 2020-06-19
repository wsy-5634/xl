package com.fugu.modules.system.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.config.Constants;
import com.fugu.modules.shiro.utils.SHA256Util;
import com.fugu.modules.system.dto.input.DeptQueryPara;
import com.fugu.modules.system.entity.Dept;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.system.entity.UserRole;
import com.fugu.modules.system.mapper.DeptMapper;
import com.fugu.modules.system.mapper.UserMapper;
import com.fugu.modules.system.mapper.UserRoleMapper;
import com.fugu.modules.system.service.ILoginService;
import org.apache.http.util.TextUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


/**
 * <p> 系统管理-角色表  服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Service
@Transactional
public class LoginServiceImpl extends ServiceImpl<UserMapper, User> implements ILoginService {

    @Autowired
    UserMapper userMapper;

    @Autowired
    UserRoleMapper userRoleMapper;

    @Autowired
    DeptMapper deptMapper;


    @Override
    public User getLoginedUserByToken(String token) {
        if (!TextUtils.isEmpty(token)) {
            return userMapper.getUserInfoByToken(token);
        } else {
            return null;
        }
    }

    @Override
    public User getLoginedUser(String username) {
        if (!TextUtils.isEmpty(username)) {
            return userMapper.selectUserByUsername(username);
        } else {
            return null;
        }
    }

    @Override
    public User getLoginedUserByMobile(String mobile) {
        if (!TextUtils.isEmpty(mobile)) {
            return userMapper.selectUserByMobile(mobile);
        } else {
            return null;
        }
    }

    @Override
    public User getLoginedUserById(int userId) {
        if (userId > 0) {
            return userMapper.selectById(userId);
        } else {
            return null;
        }
    }

    @Override
    public String insertUser(User user, String deptName, String deptSecret, String role) {
        //用户所属部门
        DeptQueryPara queryPara = new DeptQueryPara();
        queryPara.setName(deptName);
//        queryPara.setOrgSecret(deptSecret);
        Integer deptId = deptMapper.getDeptIdBySecretOrName(queryPara);
        if (deptId != null && deptId.intValue() > 0) {
            user.setDeptId(deptId);
        } else {
            Dept dept = new Dept();
            dept.setName(deptName);
//            dept.setOrgSecret(deptSecret);
//            dept.setOrder(0);
//            dept.setParent(1);//设置为归属总管理员下属的部门
            int number = deptMapper.insert(dept);
            if (number > 0) {
                deptId = deptMapper.getDeptIdBySecretOrName(queryPara);
                user.setDeptId(deptId);
            } else {
                return  null;
            }
        }

        // 默认将移动云办公注册的用户账号设置为UserID
        user.setPwd("123456");
        user.setPassword( SHA256Util.sha256(user.getPwd(), Constants.SALT ));
        user.setSalt(Constants.SALT);
        user.setFlag("2");//普通用户，1- 管理员
        int number = userMapper.insert(user);
        if (number <= 0) {//插入用户失败
            return  null;
        }

        // 分配权限
        if (TextUtils.isEmpty(role)) {
            UserRole userRole = new UserRole();
            userRole.setRole_id(3);
            userRole.setUser_id(user.getId());
            userRoleMapper.insert(userRole);
        } else {
            List<Integer> list = JSONObject.parseArray(role,  Integer.class);
            for (Integer roleId:list) {
                UserRole userRole = new UserRole();
                if (roleId == 0) {
                    userRole.setRole_id(1);
                } else {
                    userRole.setRole_id(3);
                }
                userRole.setUser_id(user.getId());
                userRoleMapper.insert(userRole);
            }
        }

        return "123456";
    }

}
