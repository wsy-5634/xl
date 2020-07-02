package com.fugu.modules.device.service;

import com.fugu.modules.common.entity.PageResult;
import com.fugu.modules.device.entity.City;
import com.fugu.modules.device.entity.Device;
import com.fugu.modules.device.entity.DeviceBase;
import org.apache.ibatis.annotations.Insert;

import java.util.List;

public interface IDeviceQueryService {

    /**
     * 根据输入条件筛选查找对应的设备并分页
     * @return
     */
    public PageResult<List<DeviceBase>> queryDeviceByPage(List list ,Integer page , Integer rows);

    /**
     * 查询设备状态
     */
    public PageResult<List> queryDevicestate(Device device);


    /**
     * 查询省份
     */
    public List<City> findprovince();

    /**
     * 根据父ID查询城市
     */
    public List<City> findcity(Integer pid);


    //根据ID查询设备
    DeviceBase findById(Integer id);


}
