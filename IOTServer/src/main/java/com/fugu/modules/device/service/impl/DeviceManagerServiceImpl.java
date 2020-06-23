package com.fugu.modules.device.service.impl;

import com.fugu.modules.device.entity.Device;
import com.fugu.modules.device.entity.DeviceBase;
import com.fugu.modules.device.entity.DeviceDepartment;
import com.fugu.modules.device.mapper.DeviceBaseMapper;
import com.fugu.modules.device.mapper.DeviceDepartmentMapper;
import com.fugu.modules.device.service.IDeviceManageService;
import com.fugu.modules.system.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;

import java.util.List;

@Service
@Transactional
public class DeviceManagerServiceImpl implements IDeviceManageService {
    @Autowired
    DeviceBaseMapper baseMapper;
    @Autowired
    DeviceDepartmentMapper departmentMapper;

    //根据ID删除设备
    @Override
    public boolean deleteDevice(DeviceBase deviceBase) {
        baseMapper.delete(deviceBase);
        return true;
    }

    //更改设备信息
    @Override
    public boolean updateDevice(DeviceDepartment department,DeviceBase devicebase ,String number) {
        //判断设备编号是否修改过
        if(!(devicebase.getNumber()).equals(number)){
            //设备修改过后，判断需要更新的设备编号是否被占用
            int count = baseMapper.countNumber(number);
            if (count>0){
                //设备编号被占用，不能重复插入
                return false;
            }
        }
        //拿到修改前的设备信息
        DeviceBase base = baseMapper.findByNumber(number);
        DeviceDepartment deviceDepartment = departmentMapper.findByID(base.getD_bmmgtid());

//        String bmmgt = (String)equ_mgt.get(equ_mgt.indexOf("bmmgt")); //部门
//        String options = (String)equ_mgt.get(equ_mgt.indexOf("options"));   //所在地域
//        String company = (String)equ_mgt.get(equ_mgt.indexOf("company"));   //所属公司
//        String azposition = (String)equ_mgt.get(equ_mgt.indexOf("azposition")); //安装位置
//        //初始化复杂条件example
//        Example example = new Example(DeviceDepartment.class);
//        //创建criteria对象，用来封装查询条件，可能是模糊查询，也可能是精确查询
//        Example.Criteria criteria = example.createCriteria();

        departmentMapper.updateByExampleSelective(department,deviceDepartment);
        baseMapper.updateByExampleSelective(devicebase,base);
        return true;
    }

    //批量删除
    @Override
    public boolean deleteBatches(List ids) {
        baseMapper.deleteBatches(ids);
        return true;
    }
}
