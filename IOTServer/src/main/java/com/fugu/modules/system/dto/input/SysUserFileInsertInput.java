package com.fugu.modules.system.dto.input;

import com.alibaba.fastjson.annotation.JSONField;
import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.List;

/**
 * 系统管理 - 角色-权限资源关联表 查询参数
 *
 * @author: fugu
 * @description:
 * @date: 2020-02-23 13:58:28
 */
@Data
@ApiModel(description = "系统管理 - 角色-权限资源关联表 查询参数")
public class SysUserFileInsertInput extends BasePageQuery {
    @ApiModelProperty(value = "文件ID")
    @JSONField(name = "fileId")
    private Integer fileId;

    @ApiModelProperty(value = "用户ID列表")
    @JSONField(name = "userIdList")
    private List<Integer> userIdList;

    @ApiModelProperty(value = "部门ID列表")
    @JSONField(name = "deptIdList")
    private List<Integer> deptIdList;
}
