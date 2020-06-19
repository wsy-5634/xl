package com.fugu.modules.system.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.modules.system.dto.input.UserRoleQueryPara;
import com.fugu.modules.system.mapper.UserRoleMapper;
import com.fugu.modules.system.entity.UserRole;
import com.fugu.modules.system.service.IUserRoleService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * <p> 系统管理 - 用户角色关联表  服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Service
@Transactional
public class UserRoleServiceImpl extends ServiceImpl<UserRoleMapper, UserRole> implements IUserRoleService {

    @Autowired
    UserRoleMapper userRoleMapper;

    @Override
    public List<UserRole> list(UserRoleQueryPara filter) {
        return userRoleMapper.selectUserRoles(filter);
    }

    @Override
    public Integer save(UserRole para) {
       if (para.getId()!=null) {
          userRoleMapper.updateById(para);
       } else {
          userRoleMapper.insert(para);
       }
       return para.getId();
    }

    @Override
    public void saveUserRole(UserRoleQueryPara para) {
       Integer roleId = para.getRole_id();
       String userIds = para.getUser_id();
       userRoleMapper.deleteByRoleId( roleId );
       if( StringUtils.isNotBlank( userIds ) ){
          String[] userIdArrays = userIds.split( "," );
          if( userIdArrays.length > 0 ){
              for (String userId : userIdArrays) {
                 UserRole userRole = new UserRole();
                 userRole.setRole_id( roleId );
                 userRole.setUser_id( Integer.parseInt( userId ) );
                 userRoleMapper.insert( userRole );
              }
          }
       }
    }

}
