package com.fugu.modules.device.mapper;

import com.fugu.modules.device.entity.City;
import org.apache.ibatis.annotations.Param;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface CityMapper extends Mapper<City> {
    /**
     * 列表分页
     * @param page
     * @param filter
     * @return
     */
//    List<City> selectCity(Pagination page, @Param("filter") CityQueryPara filter);

    /**
     * 列表
     * @param filter
     * @return
     */
 //   List<City> selectCity(@Param("filter") CityQueryPara filter);

    /**
     * 通过设备ID获取设备信息
     *
     * @param :d_id
     * @return: com.fugu.modules.deviceregister.entity.devicegister
     */
    City findByDid(@Param("id") Integer id);


}
