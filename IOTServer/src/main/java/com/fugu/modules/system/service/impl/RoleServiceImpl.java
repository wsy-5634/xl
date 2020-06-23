package com.fugu.modules.system.service.impl;

import com.fugu.modules.system.entity.Role;
import com.fugu.modules.system.dto.input.RoleQueryPara;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.system.mapper.RoleMapper;
import com.fugu.modules.system.service.IRoleService;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.baomidou.mybatisplus.plugins.Page;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;

import java.util.List;

/**
 * <p> 系统管理-角色表  服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Service
@Transactional
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role> implements IRoleService {

    @Autowired
    RoleMapper roleMapper;

    @Override
    public void listPage(Page<Role> page, RoleQueryPara filter) {
       page.setRecords(roleMapper.selectRoles(page, filter));
    }

    @Override
    public List<Role> list(RoleQueryPara filter) {
       return roleMapper.selectRoles(filter);
    }


    //根据角色名称关键字模糊查询角色信息
    @Override
    public List<Role> findByName(String key) {
        //初始化复杂条件example
        Example example = new Example(User.class);
        //创建criteria对象，用来封装查询条件，可能是模糊查询，也可能是精确查询
        Example.Criteria criteria = example.createCriteria();
        //根据角色名称模糊查询，或根据部门ID，key为name输入的关键字
            criteria.andLike("rolename","%"+key+"%");
            List<Role> roles = roleMapper.selectByExample(example);
        return roles;
    }

    @Override
    public Integer save(Role para) {
       if (para.getId()!=null) {
          roleMapper.updateById(para);
       } else {
          roleMapper.insert(para);
       }
       return para.getId();
    }

}
