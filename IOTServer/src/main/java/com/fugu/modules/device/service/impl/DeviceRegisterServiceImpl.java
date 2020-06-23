package com.fugu.modules.device.service.impl;

import com.fugu.modules.common.exception.MyException;
import com.fugu.modules.device.entity.Device;
import com.fugu.modules.device.entity.DeviceBase;
import com.fugu.modules.device.entity.DeviceDepartment;
import com.fugu.modules.device.mapper.DeviceDepartmentMapper;
import com.fugu.modules.device.mapper.DeviceBaseMapper;
import com.fugu.modules.device.mapper.DeviceTypeMapper;
import com.fugu.modules.device.service.IDeviceRegisterService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
@Transactional
public class DeviceRegisterServiceImpl  implements IDeviceRegisterService {

    @Autowired
    DeviceBaseMapper baseMapper;
    @Autowired
    DeviceDepartmentMapper departmentMapper;
    @Autowired
    DeviceTypeMapper typeMapper;

    /**
     * 设备登记
     */
    @Override
    public boolean saveDevice(List equ_mgt) {
        // 判断设备编号是否重复
        String number = (String) equ_mgt.get(equ_mgt.indexOf("number"));
        int count = baseMapper.countNumber(number);
        if (count>=0){
         // 重复则不可登记添加
            throw new MyException("该设备编号已被注册，请核对后在输入");
        }
        // 不重复则将device封装的参数一一拿出来，分别放入各个实体类，存入数据库
        equ_mgt.forEach(mgt -> {
            DeviceBase deviceBase = new DeviceBase();
            DeviceDepartment deviceDepartment = new DeviceDepartment();
            //copy共同属性的值到新对象，拷贝mgt的值到deviceBase
            BeanUtils.copyProperties(mgt,deviceBase);
            BeanUtils.copyProperties(mgt,deviceDepartment);
            baseMapper.insert(deviceBase);
            departmentMapper.insert(deviceDepartment);
        });
        return true;
    }


}
