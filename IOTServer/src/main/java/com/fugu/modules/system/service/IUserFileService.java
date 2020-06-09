package com.fugu.modules.system.service;

import com.baomidou.mybatisplus.service.IService;
import com.fugu.modules.system.dto.input.SysUserFileInput;
import com.fugu.modules.system.entity.SysUserFile;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * <p>  系统管理-用户文件权限表 服务类 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
public interface IUserFileService extends IService<SysUserFile> {

    /**
     * 获取用户或者部门权限下的问句列表
     *
     * @param filter
     * @return
     */
    List<SysUserFile> list(@Param("filter") SysUserFileInput filter);

}
