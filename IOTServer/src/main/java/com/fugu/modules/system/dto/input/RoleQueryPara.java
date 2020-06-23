package com.fugu.modules.system.dto.input;

import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 系统管理-角色表 查询参数
 *
 * @author: fugu
 * @description:
 * @date: 2019-08-20
 */
@Data
@ApiModel(description = "系统管理-角色表 查询参数")
public class RoleQueryPara extends BasePageQuery {
    @ApiModelProperty(value = "角色id")
    private Integer id;

    @ApiModelProperty(value = "角色名称")
    private String rolename;

    @ApiModelProperty(value = "角色编码")
    private String code;

    @ApiModelProperty(value = "角色描述")
    private String describe;

    @ApiModelProperty(value = "用户数量")
    private String userNum;

    @ApiModelProperty(value = "添加时间")
    private String addtime;

    @ApiModelProperty(value = "是否启用该菜单")
    private Integer states;
}
