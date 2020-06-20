package com.fugu.modules.device.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.modules.device.service.IDeviceService;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.system.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * <p> 系统管理-用户基础信息表 服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
@Service
@Transactional
public class DeviceServiceImpl extends ServiceImpl<UserMapper, User> implements IDeviceService {

    @Override
    public void queryWithId(String id){

    }

}
