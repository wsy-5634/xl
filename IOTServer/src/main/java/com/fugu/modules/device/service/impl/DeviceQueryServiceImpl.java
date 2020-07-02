package com.fugu.modules.device.service.impl;

import com.fugu.modules.common.entity.PageResult;
import com.fugu.modules.device.entity.City;
import com.fugu.modules.device.entity.Device;
import com.fugu.modules.device.entity.DeviceBase;
import com.fugu.modules.device.entity.DeviceDepartment;
import com.fugu.modules.device.mapper.CityMapper;
import com.fugu.modules.device.mapper.DeviceBaseMapper;
import com.fugu.modules.device.mapper.DeviceDepartmentMapper;
import com.fugu.modules.device.mapper.DeviceTypeMapper;
import com.fugu.modules.device.service.IDeviceQueryService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.google.common.collect.Sets;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;

import java.util.*;

@Service
@Transactional
public class DeviceQueryServiceImpl implements IDeviceQueryService {
    @Autowired
    DeviceBaseMapper baseMapper;
    @Autowired
    CityMapper cityMapper;
    @Autowired
    DeviceDepartmentMapper departmentMapper;
    @Autowired
    DeviceTypeMapper typeMapper;

    /**
     * 根据输入条件筛选查找对应的设备并分页
     * @return
     */
    @Override
    public PageResult<List<DeviceBase>> queryDeviceByPage(List list,Integer page , Integer rows) {
        //将要查询条件从list中一一拿出来
        String bmmgt = (String)list.get(list.indexOf("bmmgt")); //部门
        String number = (String)list.get(list.indexOf("number"));//编号
        String type = (String)list.get(list.indexOf("type"));   //类型
        Date qztime = (Date) list.get(list.indexOf("qztime"));//有效期开始
        Date qstime = (Date) list.get(list.indexOf("qstime"));//有效期结束
        String options = (String) list.get(list.indexOf("options"));//所在地域
        Set<Integer> Setid = Sets.newHashSet();

        if ( qztime!=null || qstime !=null) {
            //根据时间段查询对应设备信息
            Set deviceBytime = baseMapper.selectByTime(qztime, qstime);
            Setid.addAll(deviceBytime);
        }
        if (StringUtils.isNotBlank(bmmgt)){
            //通过部门查找对应的部门ID
            Integer d_bmmgtid = departmentMapper.findIDByname(bmmgt);
            Set deviceBybmmgtid = baseMapper.findidBytypeid(d_bmmgtid);
            Setid.addAll(deviceBybmmgtid);
        }
        if (StringUtils.isNotBlank(type)){
            //通过类型名称查找对应类型ID
            Integer d_typeid = typeMapper.findIDByName(type);
            Set deviceBytypeid = baseMapper.findidBytypeid(d_typeid);
            Setid.addAll(deviceBytypeid);
        }
        if(StringUtils.isNotBlank(number)) {
            Set deviceByNumber = baseMapper.findidByNumber(number);
            Setid.addAll(deviceByNumber);
        }
        if (options!=null) { //options为一个集合，集合中元素对应  省 市  县（区）的ID
            //查询省级名称对应的设备ID
            List<Integer> integers = baseMapper.selectIDByoptions(options);
            Setid.addAll(integers);
        }
        List<DeviceBase> deviceBases = baseMapper.selectByids(Setid);

        //添加分页条件，进行分页操作
        PageHelper.startPage(page, rows);
//        //添加排序条件
//        if (StringUtils.isNotBlank(sortBy)) {
//            //sortBy为根据ID排序，前端点了排序则不为空，不点则为空
//            example.setOrderByClause(sortBy + " " + (desc ? "desc" : "asc"));
//        }
        // 包装成pageInfo
        PageInfo<DeviceBase> pageInfo = new PageInfo<>(deviceBases);
//        // 将分页好的结果集封装到自定义的 pageResult
        PageResult<List<DeviceBase>> pageResult = new PageResult(pageInfo.getTotal(), pageInfo.getList());
        return pageResult;
    }

    /**
     * 查询设备状态
     */
    @Override
    public PageResult<List> queryDevicestate(Device device) {
        return null;
    }


    /**
     * 查询省份
     */
    @Override
    public List<City> findprovince() {
        List<City> citylist = cityMapper.findprovince();
        return citylist;
    }

    /**
     * 根据父ID查询城市
     */
    @Override
    public List<City> findcity(Integer pid) {
        List<City> citylist2 = cityMapper.findcity(pid);
        return citylist2;
    }

    //根据ID查询设备
    @Override
    public DeviceBase findById(Integer id) {
        DeviceBase deviceBase = baseMapper.selectByPrimaryKey(id);
        return deviceBase;
    }

}
