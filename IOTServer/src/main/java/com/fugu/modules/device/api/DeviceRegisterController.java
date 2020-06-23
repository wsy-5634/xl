package com.fugu.modules.device.api;

import com.fugu.modules.common.api.BaseController;
import com.fugu.modules.common.dto.output.ApiResult;
import com.fugu.modules.device.entity.Device;
import com.fugu.modules.device.service.IDeviceRegisterService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 设备管理
 * 设备注册登记，设备详细展示
 */
@RestController
@RequestMapping("register")
@Api(description = "设备登记新增接口")
@Slf4j
public class DeviceRegisterController extends BaseController {
    @Autowired
    IDeviceRegisterService registerService;

    /**
     * 新增设备,设备登记
     */
    @PostMapping("savedevice")
    @ApiOperation(value = "设备注册 ", httpMethod = "POST", response = ApiResult.class)
    public ApiResult savedevice(@RequestParam(value = "equ_mgt") List equ_mgt){
        boolean b = registerService.saveDevice(equ_mgt);
        //201(已创建)请求成功并且服务器创建了新的资源。
        if (!b){
            return ApiResult.fail("登记失败");
        }
        return ApiResult.ok("登记成功");
    }







}
