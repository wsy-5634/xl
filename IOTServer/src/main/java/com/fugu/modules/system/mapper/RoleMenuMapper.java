package com.fugu.modules.system.mapper;

import com.fugu.modules.system.dto.input.RoleMenuQueryPara;
import com.fugu.modules.system.entity.Menu;
import com.fugu.modules.system.entity.Role;
import com.fugu.modules.system.entity.RoleMenu;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * <p> 系统管理 - 角色-菜单关联表  Mapper 接口 </p>
 *
 * @author : fugu
 * @date : 2019-08-20
 */
public interface RoleMenuMapper extends BaseMapper<RoleMenu> {

    /**
     * 通过菜单ID查询角色集合
     * @param menu_id:
     * @return: java.util.List<Role>
     */

//    @Select("select role_id from t_sys_role_menu where menu_id = #{menu_id} and status = 1")
//    List<Role> selectRoleByMenuId(@Param("filter") Integer menu_id);

    /**
     * 列表分页
     *
     * @param page
     * @param filter
     * @return
     */
    List<RoleMenu> selectRoleMenus(Pagination page, @Param("filter") RoleMenuQueryPara filter);

    /**
     * 列表
     *
     * @param filter
     * @return
     */
    List<RoleMenu> selectRoleMenus(@Param("filter") RoleMenuQueryPara filter);

    /**
     * 根据角色Id删除用户与菜单相关联数据
     *
     * @param roleId:
     * @return: void
     */
    void deleteByRoleId(@Param("roleId") Integer roleId);



    //根据角色菜单 的ID 修改启动状态status
    @Update("UPDATE t_sys_role_menu SET status =#{status} WHERE id =#{id}")
    void updatestatus(@Param(value = "id")Integer id, @Param(value = "status")Integer status);

    /**
     * 根据角色ID查询关联菜单
     *
     * @param roleId:
     * @return: java.util.List<com.fugu.modules.system.entity.Menu>
     */
    List<Menu> selectMenusByRoleId(@Param("filter") Integer roleId);

}
