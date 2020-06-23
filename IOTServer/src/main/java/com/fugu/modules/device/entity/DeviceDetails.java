package com.fugu.modules.device.entity;

import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.fugu.modules.common.entity.BaseEntity;
import io.swagger.annotations.ApiModelProperty;

import java.io.Serializable;

public class DeviceDetails extends BaseEntity {
    @ApiModelProperty(value = "设备ID")
    @TableId(value="id", type= IdType.AUTO)
    private Integer id;

    @ApiModelProperty(value = "业务数据")
    private String textarea;

    @ApiModelProperty(value = "分析结果")
    private String analyze;

    @Override
    protected Serializable pkVal() {
        return null;
    }
}
