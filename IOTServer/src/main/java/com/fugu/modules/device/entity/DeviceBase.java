package com.fugu.modules.device.entity;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.IdType;
import com.fugu.modules.common.entity.BaseEntity;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.persistence.Id;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

/**
 * <p>  设备登记-设备注册表  </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Data
@ApiModel(description = "设备登记-设备注册表 ")
@TableName("t_dev_base")
public class DeviceBase extends BaseEntity {

    private static final long serialVersionUID = 1L;

    @ApiModelProperty(value = "设备ID")
    @TableId(value="id", type= IdType.AUTO)
    @Id
    private Integer id;


    @ApiModelProperty(value = "设备编号")
    @TableField("number")
    private String number;
    @ApiModelProperty(value = "设备名称")
    @TableField("name")
    private String name;

//    @ApiModelProperty(value = "所属公司")
//    private String company;

    @ApiModelProperty(value = "设备状态")
    @TableField("statu")
    private Integer statu;

//    @ApiModelProperty(value = "安装位置")
//    private String azposition;
    @ApiModelProperty(value = "启动日期")
    @TableField("commdata")
    private Timestamp commdata;
    @ApiModelProperty(value = "有效期（开始）")
    @TableField("qstime")
    private Date qstime;
    @ApiModelProperty(value = "有效期（结束）")
    @TableField("qztime")
    private Date qztime;

    @ApiModelProperty(value = "所在地域")
    @TableField("options")
    private List options;

    @ApiModelProperty(value = "安装位置")
    @TableField("azposition")
    private String azposition;

    @ApiModelProperty(value = "部门ID")
    @TableField("d_bmmgtid")
    private Integer d_bmmgtid;

    @ApiModelProperty(value = "种类ID")
    @TableField("d_typeid")
    private Integer d_typeid;
    @Override
    protected Serializable pkVal() {
        return null;
    }
}
