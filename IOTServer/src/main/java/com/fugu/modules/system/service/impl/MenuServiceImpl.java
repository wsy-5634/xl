package com.fugu.modules.system.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.modules.system.dto.input.MenuQueryPara;
import com.fugu.modules.system.entity.Menu;
import com.fugu.modules.system.mapper.MenuMapper;
import com.fugu.modules.system.service.IMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * <p> 系统管理-菜单表  服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
@Service
@Transactional
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements IMenuService {

    @Autowired
    MenuMapper menuMapper;

//    @Override
//    public List <Menu> listTreeMenu() {
//       return menuMapper.selectList(null);
//        return  null;
//    }

//    @Override
//    public void listPage(Page<Menu> page, MenuQueryPara filter) {
//       page.setRecords(menuMapper.selectMenus(page ));
//    }

    @Override
    public List<Menu> list() {
       return menuMapper.selectMenus(null);
    }

    @Override
    public List<Menu> selectByPid(Integer Menu_id) {
        List<Menu> menus = menuMapper.selectByPid(Menu_id);
        return menus;
    }

    @Override
    public Integer save(Menu para) {
       if (para.getMenu_id()!=null) {
          menuMapper.updateById(para);
       } else {
          menuMapper.insert(para);
       }
       return para.getMenu_id();
    }

}
