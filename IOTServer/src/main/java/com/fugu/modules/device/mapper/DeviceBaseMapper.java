package com.fugu.modules.device.mapper;

import com.fugu.modules.device.entity.City;
import com.fugu.modules.device.entity.DeviceBase;
import com.fugu.modules.system.entity.User;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import tk.mybatis.mapper.common.Mapper;

import java.util.Date;
import java.util.List;
import java.util.Set;

public interface DeviceBaseMapper extends  Mapper<DeviceBase> {

    //通过ID查询设备信息
    DeviceBase findByDid(@Param("id") Integer id);

    //统计该数据是否在数据库中有多少条
    @Select("SELECT COUNT(*) FROM t_dev_base WHERE number = #{number}")
    int countNumber(String number);

    //通过设备编号查询设备信息
    @Select("SELECT * FROM t_dev_base WHERE number =#{number}")
    DeviceBase findByNumber(String number);

    //通过设备编号查询设备ID
    @Select("SELECT id FROM t_dev_base WHERE number =#{number}")
    Set findidByNumber(String number);


    //通过设备种类ID查询对应的设备ID
    @Select("SELECT id FROM t_dev_base WHERE d_typeid = #{d_typeid}")
    Set findidBytypeid(Integer d_typeid);

    //通过部门ID查询对应的设备ID
    @Select("SELECT id FROM t_dev_base WHERE d_typeid = #{d_typeid}")
    Set findidBybmmgtid(Integer d_typeid);

    //批量删除
    @Delete("DELETE FROM  t_dev_base  WHERE id IN" +
            "<foreach collection=\"list\" item=\"ids\" open=\"(\" separator=\",\" close=\")\">" +
            "#{ids}" +
            "</foreach>")
    void deleteBatches(List ids);


    //根据有效期开始结束时间查询设备ID
    @Select("SELECT id FROM t_dev_base  WHERE qstime>= #{qstime} AND qztime<= #{qztime}")
    Set selectByTime(Date qztime , Date qstime );

    //根据设备ID集合批量查询设备信息
//    @Select("SELECT * from t_dev_base\n" +
//            "WHERE id in\n" +
//            "<foreach collection=\"Set\" item=\"id\" open=\"(\" close=\")\" separator=\",\">\n" +
//            "#{id}\n" +
//            "</foreach>")
    List<DeviceBase> selectByids(Set Setid);

    //根据省名模糊查询 对应的设备ID
    List<Integer> selectIDByoptions(String options);

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
