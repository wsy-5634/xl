package com.fugu.modules.system.mapper;

import com.fugu.modules.system.dto.input.SysUserFileInput;
import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.fugu.modules.system.entity.SysUserFile;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p> 系统管理 - 角色-权限资源关联表  Mapper 接口 </p>
 *
 * @author : fugu
 * @date : 2020-02-23 13:58:28
 */
public interface SysUserFileMapper extends BaseMapper<SysUserFile> {

    /**
     * 列表
     *
     * @param filter
     * @return
     */
    List<SysUserFile> selectSysUserFiles(@Param("filter") SysUserFileInput filter);

    boolean setAuth(@Param("filter") SysUserFile filter);

    boolean deleteUserFileById(@Param("filter") Integer fileId);
}
