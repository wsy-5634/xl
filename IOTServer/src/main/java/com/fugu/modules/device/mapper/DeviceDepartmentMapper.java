package com.fugu.modules.device.mapper;

import com.fugu.modules.device.entity.DeviceDepartment;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;


public interface DeviceDepartmentMapper extends Mapper<DeviceDepartment> {

    //通过部门ID查询部门信息
    @Select("SELECT * FROM t_dev_department WHERE d_bmmgtid =#{d_bmmgtid}")
    DeviceDepartment findByID(Integer id);

    //通过部门名称查找对应的部门ID
    @Select("SELECT  d_bmmgtid  FROM t_dev_department  d WHERE bmmgt = #{bmmgt}")
    Integer findIDByname(String bmmgt);

    //根据字段更新部门信息



    /**
     * 列表分页
     * @param page
     * @param filter
     * @return
     */
//    List<DeviceDepartment> selectDeviceDepartment(Pagination page, @Param("filter") DeviceDepartmentQueryPara filter);

    /**
     * 列表
     * @param filter
     * @return
     */
//    List<DeviceDepartment> selectDeviceDepartment(@Param("filter") DeviceDepartmentQueryPara filter);


}
