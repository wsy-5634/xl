package com.fugu.modules.device.mapper;

import com.fugu.modules.device.entity.DeviceDetails;
import org.apache.ibatis.annotations.Param;
import tk.mybatis.mapper.common.Mapper;
import java.util.List;

public interface DeviceDetailsMapper extends Mapper<DeviceDetails> {
    /**
     * 列表分页
     * @param page
     * @param filter
     * @return
     */
 //   List<DeviceDetails> selectDeviceDetails(Pagination page, @Param("filter") DeviceDetailsQueryPara filter);

    /**
     * 列表
     * @param filter
     * @return
     */
 //   List<DeviceDetails> selectDeviceDetails(@Param("filter") DeviceDetailsQueryPara filter);

    /**
     * 通过设备编号ID获取设备业务信息
     *
     * @param :d_id
     * @return: com.fugu.modules.deviceregister.entity.devicegister
     */
    DeviceDetails findByd_id(@Param("id") Integer id);

}
