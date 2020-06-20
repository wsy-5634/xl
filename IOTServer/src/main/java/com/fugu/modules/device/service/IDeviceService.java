package com.fugu.modules.device.service;

import com.baomidou.mybatisplus.service.IService;
import com.fugu.modules.system.entity.User;


/**
 * <p>  系统管理-用户基础信息表 服务类 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
public interface IDeviceService extends IService<User> {

    /**
     * 系统管理-用户基础信息表列表分页
     *
     * @param id
     * @return
     */
    void queryWithId(String id);

}
