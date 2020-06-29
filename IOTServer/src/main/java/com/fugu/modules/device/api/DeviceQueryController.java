package com.fugu.modules.device.api;

import com.fugu.modules.common.api.BaseController;
import com.fugu.modules.common.dto.output.ApiResult;
import com.fugu.modules.common.entity.PageResult;
import com.fugu.modules.device.entity.City;
import com.fugu.modules.device.entity.Device;
import com.fugu.modules.device.service.IDeviceQueryService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * 设备筛选查询、在线状态查询
 * @author: fugu
 * @description:
 * @date: 2020-6-12
 */
@RestController
@RequestMapping("/query")
@Api(description = "设备查询接口")
@Slf4j
public class DeviceQueryController extends BaseController {
    @Autowired
    IDeviceQueryService queryService;
    /**
     * 设备筛选查询并分页
     * @return
     */
    @GetMapping("/find")
    @ApiOperation(value = "查询并分页 ", httpMethod = "POST", response = ApiResult.class)
    ResponseEntity<PageResult<List>> queryDeviceBypage(@RequestParam(value = "equ_que") List list, //管理部门，地域，设备类型，选择日期，编号设备
            @RequestParam(value = "page", defaultValue = "1")Integer page,
            @RequestParam(value = "rows",defaultValue = "5")Integer rows
//            @RequestParam(value = "sortBy",required = false)String sortBy,
//            @RequestParam(value = "desc", required = false)Boolean desc
    ){
        PageResult<List> result = queryService.queryDeviceByPage(list,page,rows);
        //判断当前页数据是否为空
        if (CollectionUtils.isEmpty(result.getItems())){
            return ResponseEntity.notFound().build();   //返回404
        }
        return ResponseEntity.ok(result);
    }



    //查询省份或直辖市
    @RequestMapping("/options")
    @ApiOperation(value = "查询省份或直辖市 ", httpMethod = "POST", response = ApiResult.class)
    public ResponseEntity<List> findoptions(Integer cityclass , Integer pid){
        List list = new ArrayList();
        if (cityclass==1){
            //查询省或直辖市并返回id
            List<City> cityList = queryService.findprovince();
            return ResponseEntity.ok(cityList);
        }
        if (cityclass==2){
            //将上面的id当做pid，根据pid查询对应的市并返回id
            List<City> cityList2 = queryService.findcity(pid);
            return ResponseEntity.ok(cityList2);
        }
        if (cityclass==3){
            //将上面的id当做pid，根据pid查询对应的县并返回id
            List<City> cityList3 = queryService.findcity(pid);
            return ResponseEntity.ok(cityList3);
        }
        return ResponseEntity.notFound().build();
    }

//    /**
//     * 设备状态查询
//     */
//    @GetMapping("/state")
//    @ApiOperation(value = "设备状态查询 ", httpMethod = "POST", response = ApiResult.class)
//    ResponseEntity<PageResult<List>> queryDevicestate(@RequestBody Device device   //在线状态，业务数据，更新时间，间隔时间，分析结果
////            @RequestParam(value = "page", defaultValue = "1")Integer page,
////            @RequestParam(value = "rows",defaultValue = "5")Integer rows,
////            @RequestParam(value = "sortBy",required = false)String sortBy,
////            @RequestParam(value = "desc", required = false)Boolean desc
//    ){
////        PageResult<List> result = queryService.queryDeviceByPage(device);
//        //判断当前页数据是否为空
//        if (CollectionUtils.isEmpty(result.getItems())){
//            return ResponseEntity.notFound().build();   //返回404
//        }
//        return ResponseEntity.ok(result);
//    }









}
