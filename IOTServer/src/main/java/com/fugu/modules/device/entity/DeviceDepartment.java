package com.fugu.modules.device.entity;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.IdType;
import com.fugu.modules.common.entity.BaseEntity;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
@Data
@ApiModel(description = "设备登记-设备注册表 ")
@TableName("t_dev_department")
public class DeviceDepartment extends BaseEntity {
    @ApiModelProperty(value = "部门ID")
    @TableId(value="d_bmmgtid", type= IdType.AUTO)
    private Integer d_bmmgtid;

    @ApiModelProperty(value = "管理部门名称")
    @TableField("bmmgt")
    private String bmmgt;

    @ApiModelProperty(value = "所属公司")
    @TableField("company")
    private String company;

    @Override
    protected Serializable pkVal() {
        return null;
    }
}
