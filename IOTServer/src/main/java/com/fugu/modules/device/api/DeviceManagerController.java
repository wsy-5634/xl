package com.fugu.modules.device.api;

import com.fugu.modules.common.api.BaseController;
import com.fugu.modules.common.dto.output.ApiResult;
import com.fugu.modules.device.entity.Device;
import com.fugu.modules.device.entity.DeviceBase;
import com.fugu.modules.device.entity.DeviceDepartment;
import com.fugu.modules.device.service.IDeviceManageService;
import com.fugu.modules.device.service.IDeviceQueryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
*********删除和修改设备信息
*/
    @RestController
    @RequestMapping("/manager")
    @Api(description = "设备管理接口")
    @Slf4j
    public class DeviceManagerController extends BaseController {
    @Autowired
    IDeviceManageService manageService;
    @Autowired
    IDeviceQueryService queryService;

    /**
     * 根据ID删除某设备
     * @param id
     */
    @RequestMapping("/delet")
    @ApiOperation(value = "根据ID删除设备 ", httpMethod = "POST", response = ApiResult.class)
    public ApiResult deletDevice(@RequestParam Integer id){
        //先找到ID对应的删除对象
        DeviceBase deviceBase = queryService.findById(id);
        //删除该设备
        boolean b = manageService.deleteDevice(deviceBase);
        if (!b){
            return ApiResult.fail("删除失败");
        }
        return ApiResult.ok("删除成功");
    }

    /**
     * 修改设备信息
     * @Param devicebase:base表对应的字段：number,name,states,options,azposition
     * @Param department:部门表对应的字段：bmmgt,company
     * @Param number:修改前的设备编号
     */
    @RequestMapping("/update")
    @ApiOperation(value = "修改设备信息 ", httpMethod = "POST", response = ApiResult.class)
    public ResponseEntity<Void> updateDevice(@RequestBody DeviceDepartment department,
                                             @RequestBody DeviceBase devicebase,
                                             @RequestParam(value = "number")String number){
        manageService.updateDevice(department,devicebase,number);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }


    /**
     * 批量删除
     */
    @PostMapping(value = "/deleteBatches", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "批量删除", httpMethod = "POST", response = ApiResult.class)
    public ApiResult deleteBatches(List ids) {
        boolean b = manageService.deleteBatches(ids);
        if(!b){
            return ApiResult.fail("删除失败");
        }
        return ApiResult.ok("批量删除成功");
    }

}
