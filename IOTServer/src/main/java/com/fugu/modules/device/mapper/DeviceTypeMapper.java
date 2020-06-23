package com.fugu.modules.device.mapper;

import com.fugu.modules.device.entity.DeviceBase;
import com.fugu.modules.device.entity.DeviceType;
import io.swagger.models.auth.In;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface DeviceTypeMapper extends Mapper<DeviceType> {
    /**
     * 列表分页
     * @return
     */
//    List<DeviceType> selectDeviceType(Pagination page, @Param("filter") DeviceTypeQueryPara filter);

    //通过类型查找ID
    @Select("SELECT d_typeid FROM t_dev_type WHERE TYPE = #{TYPE}")
    Integer findIDByName(String type);

    /**
     * 列表
     * @param filter
     * @return
     */
 //   List<DeviceType> selectDeviceType(@Param("filter") DeviceTypeQueryPara filter);

    /**
     * 通过种类ID获取设备种类
     *
     * @param :d_id
     * @return: com.fugu.modules.deviceregister.entity.devicegister
     */
    DeviceBase findByTypeid(@Param("d_typeid") Integer d_typeid);

}
