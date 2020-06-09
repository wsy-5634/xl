package com.fugu.modules.system.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.config.Constants;
import com.fugu.modules.common.exception.MyException;
import com.fugu.modules.shiro.utils.SHA256Util;
import com.fugu.modules.system.dto.input.UserQueryPara;
import com.fugu.modules.system.dto.input.UserRoleQueryPara;
import com.fugu.modules.system.dto.model.ButtonVO;
import com.fugu.modules.system.dto.model.MenuVO;
import com.fugu.modules.system.dto.model.UserInfoVO;
import com.fugu.modules.system.entity.Menu;
import com.fugu.modules.system.entity.Role;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.system.mapper.RoleMenuMapper;
import com.fugu.modules.system.mapper.UserMapper;
import com.fugu.modules.system.mapper.UserRoleMapper;
import com.fugu.modules.system.service.IUserService;
import com.fugu.utils.TreeBuilder;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.util.TextUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

/**
 * <p> 系统管理-用户基础信息表 服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
@Service
@Transactional
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Autowired
    UserMapper userMapper;
    @Autowired
    UserRoleMapper userRoleMapper;
    @Autowired
    RoleMenuMapper roleMenuMapper;

    @Override
    public void listPage(Page<User> page, UserQueryPara filter) {
        page.setTotal(userMapper.count(filter));

        filter.setPage(page.getCurrent());
        filter.setLimit(page.getSize());
        List<User> preUserList = userMapper.selectUsers(filter);
        page.setRecords(preUserList);
    }

    @Override
    public List<User> list(UserQueryPara filter) {
        return userMapper.selectUsers(filter);
    }

    @Override
    public UserInfoVO getCurrentUserInfo(String token) {
        if (TextUtils.isEmpty(token)) {
            return null;
        }
        User user = userMapper.getUserInfoByToken(token);
        UserInfoVO userInfoVO = new UserInfoVO();
        BeanUtil.copyProperties(user, userInfoVO);

        Set<String> roles = new HashSet();
        Set<Integer> roleIds = new HashSet();
        Set<MenuVO> menuVOS = new HashSet();
        Set<ButtonVO> buttonVOS = new HashSet();

        //查询某个用户的角色
        List<Role> roleList = userRoleMapper.selectRoleByUserId(user.getId());
        if (roleList != null && !roleList.isEmpty()) {
            for (Role role : roleList) {
                roles.add(role.getCode());
                roleIds.add(role.getId());

                //查询某个角色的菜单
                List<Menu> menuList = roleMenuMapper.selectMenusByRoleId(role.getId());
                if (menuList != null && !menuList.isEmpty()) {
                    menuList.stream().filter(Objects::nonNull).forEach(menu -> {
                        if ("button".equals(menu.getType().toLowerCase())) {
                            //如果权限是按钮，就添加到按钮里面
                            ButtonVO buttonVO = new ButtonVO();
                            BeanUtil.copyProperties(menu, buttonVO);
                            buttonVOS.add(buttonVO);
                        }
                        if ("menu".equals(menu.getType().toLowerCase())) {
                            //如果权限是菜单，就添加到菜单里面
                            MenuVO menuVO = new MenuVO();
                            BeanUtil.copyProperties(menu, menuVO);
                            menuVOS.add(menuVO);
                        }
                    });
                }
            }
        }
        userInfoVO.getRoleNames().addAll(roles);
        userInfoVO.getRoles().addAll(roleIds);
        userInfoVO.getButtons().addAll(buttonVOS);
        userInfoVO.getMenus().addAll(TreeBuilder.buildTree(menuVOS));
        return userInfoVO;
    }

    @Override
    public Integer save(User para) {
        if (para.getId() != null) {
            User user = userMapper.selectById(para.getId());
            para.setPassword(SHA256Util.sha256(para.getPwd(), user.getSalt()));
            userMapper.updateById(para);
        } else {
            para.setSalt(Constants.SALT);
            para.setPassword(SHA256Util.sha256(para.getPwd(), Constants.SALT));
            userMapper.insert(para);
        }
        return para.getId();
    }

    @Override
    public Integer updatePersonalInfo(User para) {
        if (para.getId() == null) {
            throw new MyException("用户信息异常丢失，请重新登录尝试修改个人信息！");
        }
        if (StringUtils.isBlank(para.getUsername())) {
            throw new MyException("账号不能为空！");
        }
        if (StringUtils.isBlank(para.getNickName())) {
            throw new MyException("昵称不能为空！");
        }
        User user = userMapper.selectById(para.getId());
        if (StringUtils.isNotBlank(para.getPwd())) {
            if (para.getPwd().trim().length() < 6) {
                throw new MyException("请设置至少6位数密码！");
            }
            // 更新密码
            para.setPassword(SHA256Util.sha256(para.getPwd(), user.getSalt()));
        } else {
            para.setPwd(null);
        }

        // 验证账号是否重复
        UserQueryPara userQueryPara = new UserQueryPara();
        userQueryPara.setUsername(para.getUsername());
        List<User> userList = userMapper.selectUsers(userQueryPara);
        if (!CollectionUtils.isEmpty(userList)) {
            if (!para.getUsername().equals(user.getUsername()) || userList.size() > 1) {
                throw new MyException("账号重复，请重新输入！");
            }
        }
        userMapper.updateById(para);
        return para.getId();
    }

    public Integer setUserDept(User para) {
        if (para.getId() == null || para.getId() == 0) {
            throw new MyException("用户信息异常丢失，请重新登录尝试修改个人信息！");
        }

        if (para.getDeptId() == 0) {
            throw new MyException("用户信息异常丢失，请重新登录尝试修改个人信息！");
        }

        return userMapper.updateUserDept(para);
    }

    @Override
    public List<User> listByDept(UserQueryPara filter) {
        return userMapper.selectUsersByDept(filter.getDeptId());
    }

}
