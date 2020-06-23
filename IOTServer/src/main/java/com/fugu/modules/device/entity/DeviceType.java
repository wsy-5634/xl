package com.fugu.modules.device.entity;

import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.enums.IdType;
import com.fugu.modules.common.entity.BaseEntity;
import io.swagger.annotations.ApiModelProperty;

import java.io.Serializable;

public class DeviceType extends BaseEntity {
    @ApiModelProperty(value = "类型ID")
    @TableId(value="d_typeid", type= IdType.AUTO)
    private Integer d_typeid;

    @ApiModelProperty(value = "设备类型名称")
    private String d_typename;

    @Override
    protected Serializable pkVal() {
        return null;
    }
}
