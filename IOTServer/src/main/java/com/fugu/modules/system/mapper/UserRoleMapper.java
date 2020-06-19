package com.fugu.modules.system.mapper;

import com.fugu.modules.system.entity.Role;
import com.fugu.modules.system.entity.UserRole;
import com.fugu.modules.system.dto.input.UserRoleQueryPara;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p> 系统管理 - 用户角色关联表  Mapper 接口 </p>
 *
 * @author : fugu
 * @date : 2019-08-20
 */
public interface UserRoleMapper extends BaseMapper<UserRole> {
    /**
     * 列表
     * @param filter
     * @return
     */
    List<UserRole> selectUserRoles(@Param("filter") UserRoleQueryPara filter);

    /**
     * 根据角色Id删除用户与角色相关联数据
     *
     * @param roleId:
     * @return: void
     */
    void deleteByRoleId(@Param("roleId") Integer roleId);

    /**
     * 根据用户Id查询关联角色
     *
     * @param userId:
     * @return: java.util.List<com.fugu.modules.system.entity.Role>
     */
    List<Role> selectRoleByUserId(@Param("userId") Integer userId);

}
