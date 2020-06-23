package com.fugu.modules.device.service;

import com.fugu.modules.device.entity.Device;
import com.fugu.modules.device.entity.DeviceBase;
import com.fugu.modules.device.entity.DeviceDepartment;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface IDeviceManageService {

    //删除设备
    public boolean deleteDevice(DeviceBase deviceBase);

    //设备信息更改
    public boolean updateDevice(DeviceDepartment department, DeviceBase devicebase,String number);

    //批量删除设备
    boolean deleteBatches(List ids);


}
