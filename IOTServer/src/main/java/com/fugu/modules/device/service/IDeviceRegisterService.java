package com.fugu.modules.device.service;

import com.fugu.modules.device.entity.Device;
import org.springframework.http.ResponseEntity;

import java.util.List;

/**
 * 设备管理，设备详情展示
 */

public interface IDeviceRegisterService /*extends IService<DeviceBase>*/ {
    /**
     * 设备登记，将设备登记信息写入数据库
     * @param device
     */
    public boolean saveDevice(List equ_mgt);



}
