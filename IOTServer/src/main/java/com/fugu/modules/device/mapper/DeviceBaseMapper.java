package com.fugu.modules.device.mapper;

import com.fugu.modules.device.entity.DeviceBase;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import tk.mybatis.mapper.common.Mapper;

import java.util.Date;
import java.util.List;

public interface DeviceBaseMapper extends  Mapper<DeviceBase> {

    //通过ID查询设备信息
    DeviceBase findByDid(@Param("id") Integer id);


    //统计该数据是否在数据库中有多少条
    @Select("SELECT COUNT(*) FROM t_dev_base WHERE number = #{number}")
    int countNumber(String number);

    //通过设备编号查询设备信息
    @Select("SELECT * FROM t_dev_base WHERE number =#{number}")
    DeviceBase findByNumber(String number);

    //批量删除
    @Delete("DELETE FROM  t_dev_base  WHERE id IN" +
            "<foreach collection=\"list\" item=\"ids\" open=\"(\" separator=\",\" close=\")\">" +
            "#{ids}" +
            "</foreach>")
    void deleteBatches(List ids);

    @Select("SELECT id FROM t_dev_base  WHERE qstime>= #{qstime} AND qztime<= #{qztime}")
    List selectByTime(Date qztime , Date qstime );

    /**
     * 列表分页
     * @param page
     * @param filter
     * @return
     */
//    List<DeviceBase> selectDeviceRegister(Pagination page, @Param("filter") DeviceRegisterQueryPara filter);

    /**
     * 列表
     * @param filter
     * @return
     */
//    List<DeviceBase> selectDeviceRegister(@Param("filter") DeviceRegisterQueryPara filter);

    /**
     * 通过设备ID获取设备信息
     *
     * @param :d_id
     * @return: com.fugu.modules.deviceregister.entity.devicegister
     */


}
