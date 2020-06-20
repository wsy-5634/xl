package com.fugu.modules.device.dto.input;

import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 系统管理 - 用户角色关联表 查询参数
 *
 * @author: fugu
 * @description:
 * @date: 2019-08-20
 */
@Data
@ApiModel(description = "系统管理 - 用户角色关联表 查询参数")
public class DeviceQueryPara extends BasePageQuery{
    @ApiModelProperty(value = "id")
    private Integer id;

    @ApiModelProperty(value = "角色ID")
    private Integer role_id;

    @ApiModelProperty(value = "用户ids")
    private String user_id;//插入时使用
}
