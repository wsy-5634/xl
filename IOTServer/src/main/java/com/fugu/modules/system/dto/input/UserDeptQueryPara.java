package com.fugu.modules.system.dto.input;

import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * 系统管理 - 用户角色关联表 查询参数
 *
 * @author: fugu
 * @description:
 * @date: 2019-08-20
 */
@Data
@ApiModel(description = "系统管理 - 用户角色关联表 查询参数")
public class UserDeptQueryPara extends BasePageQuery{
    @ApiModelProperty(value = "id")
    private Integer id;

    @ApiModelProperty(value = "用户ids")
    private String userIds;//插入时使用

    @ApiModelProperty(value = "待删除的用户ID")
    private String removedUserIds;//删掉的用户ID
}
