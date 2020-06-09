package com.fugu.modules.system.service.impl;

import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.modules.system.dto.input.SysUserFileInput;
import com.fugu.modules.system.entity.SysUserFile;
import com.fugu.modules.system.mapper.SysUserFileMapper;
import com.fugu.modules.system.service.IUserFileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * <p> 系统管理-角色表  服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Service
@Transactional
public class UserFileServiceImpl extends ServiceImpl<SysUserFileMapper, SysUserFile> implements IUserFileService {

    @Autowired
    SysUserFileMapper roleMapper;


    @Override
    public List<SysUserFile> list(SysUserFileInput filter) {
        return roleMapper.selectSysUserFiles(filter);
    }
}
