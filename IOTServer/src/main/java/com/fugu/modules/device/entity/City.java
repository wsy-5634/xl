package com.fugu.modules.device.entity;

import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.IdType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * <p>  设备登记-设备注册表  </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Data
@ApiModel(description = "设备地域查询表 ")
@TableName("t_city")
public class City {

    private static final long serialVersionUID = 1L;
    @ApiModelProperty(value = "城市ID")
    @TableId(value="id", type= IdType.AUTO)
    private Integer id;

    @ApiModelProperty(value = "上级城市ID")
    private String pid;

    @ApiModelProperty(value = "城市名称")
    private String cityname;

    @ApiModelProperty(value = "城市等级")
    private Integer cityclass;


}
