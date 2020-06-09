package com.fugu.modules.system.dto.input;

import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;
import java.util.Set;

/**
 * 系统管理 - 角色-权限资源关联表 查询参数
 *
 * @author: fugu
 * @description:
 * @date: 2020-02-23 13:58:28
 */
@Data
@ApiModel(description = "系统管理 - 角色-权限资源关联表 查询参数")
public class SysUserFileInput extends BasePageQuery {
    @ApiModelProperty(value = "id")
    private Integer id;

    @ApiModelProperty(value = "用户ID")
    private Integer userId;

    @ApiModelProperty(value = "部门ID列表")
    private List<Integer> deptIdList;
}
