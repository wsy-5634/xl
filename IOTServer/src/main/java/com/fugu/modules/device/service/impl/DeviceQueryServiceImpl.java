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
import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.annotations.Insert;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tk.mybatis.mapper.entity.Example;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

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
    public PageResult<List> queryDeviceByPage(List list,Integer page , Integer rows) {
        //将要查询条件从list中一一拿出来
        String bmmgt = (String)list.get(list.indexOf("bmmgt")); //部门
        String number = (String)list.get(list.indexOf("number"));//编号
        String type = (String)list.get(list.indexOf("type"));   //类型
        Date qztime = (Date) list.get(list.indexOf("qztime"));//有效期开始
        Date qstime = (Date) list.get(list.indexOf("qstime"));//有效期结束
        String options = (String)list.get(list.indexOf("options"));//所在地域

        //根据时间段查询对应设备信息
        List ids = baseMapper.selectByTime(qztime, qstime);

        //添加复杂查询条件
        //初始化复杂条件 example对象
        Example example = new Example((DeviceBase.class));
        //创建criteria对象，用来封装查询条件（可能是模糊查询，也可能是精确查询）
        Example.Criteria criteria = example.createCriteria();
        if(StringUtils.isNotBlank(number)) {
            criteria.andLike("number", "%" + number + "%");
        }
        if (StringUtils.isNotBlank(options)) {
            criteria.andLike("options",options);
        }
        if (StringUtils.isNotBlank(bmmgt)){
            //通过部门查找对应的部门ID
            Integer d_bmmgtid = departmentMapper.findIDByname(bmmgt);
            criteria.andEqualTo("d_bmmgtid",d_bmmgtid);
        }
        if (StringUtils.isNotBlank(type)){
            //通过类型名称查找对应类型ID
            Integer d_typeid = typeMapper.findIDByName(type);
            criteria.andEqualTo("d_typeid",d_typeid);
        }

        //执行查询操作
        List<DeviceBase> deviceBases = baseMapper.selectByExample(example);


        //添加分页条件，进行分页操作
        PageHelper.startPage(page, rows);

//        //根据name模糊查询，或根据首字母查询,key为查询框输入的关键字
//        if (StringUtils.isNotBlank(key)) {
//            criteria.andLike("name", "%" + key + "%").orEqualTo("letter", key);
//        }
//        //添加分页条件，进行分页操作
//        PageHelper.startPage(page, rows);
//        //添加排序条件
//        if (StringUtils.isNotBlank(sortBy)) {
//            //sortBy为根据ID排序，前端点了排序则不为空，不点则为空
//            example.setOrderByClause(sortBy + " " + (desc ? "desc" : "asc"));
//        }
//        //执行查询操作
//        List<Device> device = deviceRegisterMapper.selectByExample(example);
//        // 包装成pageInfo
//        PageInfo<Device> pageInfo = new PageInfo<>(device);
//        // 将分页好的结果集封装到自定义的 pageResult
//        PageResult<Device> pageResult = new PageResult<>(pageInfo.getTotal(), pageInfo.getList());
//        return pageResult;
            return null;
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
        return null;
    }


    /**
     * 根据父ID查询城市
     */
    @Override
    public List<City> findcity(Integer pid) {
        return null;
    }


    //根据ID查询设备
    @Override
    public DeviceBase findById(Integer id) {
        DeviceBase deviceBase = baseMapper.selectByPrimaryKey(id);
        return deviceBase;
    }

}
