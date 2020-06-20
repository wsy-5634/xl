package com.fugu.modules.device.api;

import com.fugu.modules.common.api.BaseController;
import com.fugu.modules.device.service.IDeviceService;
import com.fugu.modules.device.dto.input.DeviceQueryPara;
import com.fugu.modules.common.dto.output.ApiResult;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 *  <p> 授权模块 </p>
 *
 * @description:
 * @author: fugu
 * @date: 2019/8/17 0017 19:41
 */
@RestController
@RequestMapping("/api/device")
@Api(description = "设备管理接口")
@Slf4j
public class DeviceController extends BaseController {

    @Autowired
    IDeviceService deviceService;

    /**
     * 设备状态查询
     */
    @PostMapping("/queryStatus")
    @ApiOperation(value = "查询设备在线状态", httpMethod = "POST", response = ApiResult.class, notes = "查询设备在线状态")
    public ApiResult queryStatus(@RequestBody DeviceQueryPara para) throws Exception {
         deviceService.queryWithId("0xffe3432");
         return null;
    }
}
