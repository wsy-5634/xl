package com.fugu.modules.system.dto.input;

import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 系统管理-部门表 查询参数
 *
 * @author: fugu
 * @description:
 * @date: 2019-08-20
 */
@Data
@ApiModel(description = "系统管理-部门表 查询参数")
public class DeptQueryPara extends BasePageQuery {
    @ApiModelProperty(value = "部门id")
    private Integer id;
    @ApiModelProperty(value = "部门名称")
    private String name;
    @ApiModelProperty(value = "上级部门ID")
    private String parent_id;


//    @ApiModelProperty(value = "部门Secret")
//    private String orgSecret;
}
