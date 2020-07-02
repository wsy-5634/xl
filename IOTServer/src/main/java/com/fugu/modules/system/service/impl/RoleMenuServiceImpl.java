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
import java.util.Map;

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

//修改角色菜单功能---分配菜单
    @Override
    public boolean update(Map<Integer,Integer> map) {
//Map集合中 K-V 对应 角色菜单表中的 id 和 status ，勾选菜单选项就等于更改status
       for (Integer key : map.keySet()){
           //通过ID修改status
           roleMenuMapper.updatestatus(key,map.get(key));
       }
       return true;
    }
}
