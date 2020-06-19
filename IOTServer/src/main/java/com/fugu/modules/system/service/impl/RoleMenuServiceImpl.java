package com.fugu.modules.system.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.modules.system.dto.input.RoleMenuQueryPara;
import com.fugu.modules.system.mapper.RoleMenuMapper;
import com.fugu.modules.system.entity.RoleMenu;
import com.fugu.modules.system.service.IRoleMenuService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * <p> 系统管理 - 角色-菜单关联表  服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Service
@Transactional
public class RoleMenuServiceImpl extends ServiceImpl<RoleMenuMapper, RoleMenu> implements IRoleMenuService {

    @Autowired
    RoleMenuMapper roleMenuMapper;

    @Override
    public void listPage(Page<RoleMenu> page, RoleMenuQueryPara filter) {
       page.setRecords(roleMenuMapper.selectRoleMenus(page, filter));
    }

    @Override
    public List<RoleMenu> list(RoleMenuQueryPara filter) {
       return roleMenuMapper.selectRoleMenus(filter);
    }

    @Override
    public void saveRoleMenu(RoleMenuQueryPara para) {
       Integer roleId = para.getRole_id();
       String menuIds = para.getMenu_id();
       roleMenuMapper.deleteByRoleId( roleId );
       if(StringUtils.isNotBlank( menuIds )){
          String[] menuIdArrays = menuIds.split( "," );
          if(menuIdArrays.length > 0){
              for (String menuId : menuIdArrays) {
                 RoleMenu roleMenu = new RoleMenu();
                 roleMenu.setMenu_id( Integer.parseInt( menuId ) );
                 roleMenuMapper.insert( roleMenu );
              }
          }
       }
    }

    @Override
    public Integer save(RoleMenu para) {
       if (para.getId()!=null) {
          roleMenuMapper.updateById(para);
       } else {
          roleMenuMapper.insert(para);
       }
       return para.getId();
    }
}
