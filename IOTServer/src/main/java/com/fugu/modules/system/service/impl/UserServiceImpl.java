package com.fugu.modules.system.service.impl;

import cn.hutool.core.bean.BeanUtil;
import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.modules.common.entity.PageResult;
import com.fugu.modules.common.exception.MyException;
import com.fugu.modules.system.util.MD5Util;
import com.fugu.modules.shiro.utils.SHA256Util;
import com.fugu.modules.system.dto.input.UserQueryPara;
import com.fugu.modules.system.dto.model.ButtonVO;

import com.fugu.modules.system.dto.model.MenuVO;
import com.fugu.modules.system.dto.model.UserInfoVO;
import com.fugu.modules.system.entity.Menu;
import com.fugu.modules.system.entity.Role;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.system.mapper.DeptMapper;
import com.fugu.modules.system.mapper.RoleMenuMapper;
import com.fugu.modules.system.mapper.UserMapper;
import com.fugu.modules.system.mapper.UserRoleMapper;
import com.fugu.modules.system.service.IUserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.util.TextUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import tk.mybatis.mapper.entity.Example;

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
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {  //extends ServiceImpl<UserMapper, User>

    @Autowired
    UserMapper userMapper;
    @Autowired
    UserRoleMapper userRoleMapper;
    @Autowired
    RoleMenuMapper roleMenuMapper;
    @Autowired
    DeptMapper deptMapper;

    @Override
    public void listPage(Page<User> page, UserQueryPara filter) {
        page.setTotal(userMapper.count(filter));
        filter.setPage(page.getCurrent());  //放入默认为1的当前页
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
//        userInfoVO.getMenus().addAll(TreeBuilder.buildTree(menuVOS));
        return userInfoVO;
    }

    /**
     * 新增用户，用户注册
     * @param para
     * @return
     */
    @Override
    public Integer save(User para) {
        //判断填入的登录账号是否和数据库中的有重复
        int count = userMapper.countBy(para.getLoginname());
        if (count>=0){
            throw new MyException("该账号昵称已被占用，请重新输入");
        }
        userMapper.insertAllColumn(para);
        //自动生成用户编号
        para.setCode(para.getId()+1000);
        //对明文密码加密
        para.setPassword(MD5Util.encrypt(para.getLoginname().toLowerCase(), para.getPwd()));
        return para.getId();
    }

    //批量删除
    @Override
    public boolean deleteBatches(List<Integer> ids) {
        if(ids!=null){
    //判断登录用户权限是否比删除用户权限大，如果权限更大，则可以删除
          //循环拿到用户ID，拿到每个用户对应的角色
            ids.forEach(c -> {
                //将品用户ID的id集合遍历放在自定义的 c 容器中，
                Integer roleid = userMapper.selectRoleidByID( c);
                //如果有管理员角色，则剔除角色ID为1的管理员角色，
                if (roleid>0) {
                    ids.remove(Integer.valueOf(c));
                }
            });
             userMapper.deleteBatches(ids);
        }else {
            throw new MyException("请选择需要删除的用户！");
        }
        return true;
    }

    @Override
    public Integer updatePersonalInfo(User para) {
        if (para.getId() == null) {
            throw new MyException("用户信息异常丢失，请重新登录尝试修改个人信息！");
        }
        if (StringUtils.isBlank(para.getLoginname())) {
            throw new MyException("账号不能为空！");
        }
        if (StringUtils.isBlank(para.getName())) {
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
        userQueryPara.setLoginname(para.getLoginname());
        List<User> userList = userMapper.selectUsers(userQueryPara);
        if (!CollectionUtils.isEmpty(userList)) {
            if (!para.getLoginname().equals(user.getLoginname()) || userList.size() > 1) {
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

        if (para.getDept_id() == 0) {
            throw new MyException("用户信息异常丢失，请重新登录尝试修改个人信息！");
        }

        return userMapper.updateUserDept(para);
    }

    @Override
    public List<User> listByDept(UserQueryPara filter) {
        return userMapper.selectUsersByDept(filter.getDept_id());
    }

    @Override
    public User findUserByname(String loginname) {
        return userMapper.selectUserByUsername(loginname);
    }

    //根据姓名和部门查询用户信息
    @Override
    public PageResult<User> NameAndDepPage(String key, String name,Integer page, Integer rows) {
        //初始化复杂条件example
        Example example = new Example(User.class);
        //创建criteria对象，用来封装查询条件，可能是模糊查询，也可能是精确查询
        Example.Criteria criteria = example.createCriteria();
        //根据部门名称，查找部门ID
        if(!StringUtils.isNoneBlank(name)){
            Integer deptId = deptMapper.getDeptIdByName(name);
            criteria.orEqualTo("deptId",deptId);    //orEqualTo方法必须写在前面
        }
        //根据name模糊查询，或根据部门ID，key为name输入的关键字
        if (StringUtils.isNoneBlank(key)){
            criteria.andLike("name","%"+key+"%");
        }
        PageHelper.startPage(page, rows);
        //添加排序条件
//        if (org.apache.commons.lang.StringUtils.isNotBlank(sortBy)) {
//            //sortBy为根据ID排序，前端点了排序则不为空，不点则为空
//            example.setOrderByClause(sortBy + " " + (desc ? "desc" : "asc"));
//        }
        //执行查询操作
        List<User> users = userMapper.selectByExample(example);
        // 包装成pageInfo
        PageInfo<User> pageInfo = new PageInfo<>(users);
        // 将分页好的结果集封装到自定义的 pageResult
        PageResult<User> pageResult = new PageResult<>(pageInfo.getTotal(), pageInfo.getList());
        return pageResult;
    }

    @Override
    public User getById(Integer id) {
        System.out.println("aaa");
        User user = userMapper.getById(id);
        System.out.println("123");
        return user;
    }

    @Override
    public void deleteById(Integer id) {
        userMapper.deleteById(id);
    }

}
