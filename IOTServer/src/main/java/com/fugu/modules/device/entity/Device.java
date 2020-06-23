package com.fugu.modules.device.entity;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * <p>  前台传来的设备信息封装到了三个集合 equ_mgt，equ_que，equ_dos中，
 * 将这三个集合封装成一个对象</p>
 * @author: fugu
 * @date: 2020-6-11
 */
@Data
@ApiModel(description = "设备登记-设备注册表 ")
public class Device  {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "设备登记备案集合，设备修改调用")
//  id，company，bmmgt，type，number，name，options，azposition，commdata，qstime，qztime，state
    private List equ_mgt;

    @ApiModelProperty(value = "设备查询接口集合,删除功能调用")
    //id,bmmgt,number,type,state,address,textarea,rtytime
    private List equ_que;

    @ApiModelProperty(value = "设备在线状态查询")
    //id,state,textarea,updata,butweenTime,results
    private List equ_dos;

}
