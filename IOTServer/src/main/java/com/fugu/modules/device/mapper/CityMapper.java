package com.fugu.modules.device.mapper;

import com.fugu.modules.device.entity.City;
import io.swagger.models.auth.In;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import tk.mybatis.mapper.common.Mapper;

import java.util.List;

public interface CityMapper extends Mapper<City> {

    @Select("SELECT * FROM t_city WHERE pid =1")
    List<City> findprovince();

    @Select("SELECT cityname FROM t_city WHERE pid = #{pid}")
    List<City> findcity(Integer pid);

    @Select("select * from t_city where id = #{id}")
    City selectByID(Integer id);

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



    @Select("select id from t_city where name =  #{name} and pid = #{pid}")
    Integer selectCityByNameAndPid(@Param("name") String name , @Param("pid") Integer pid);
}
