package com.fugu.modules.system.dto.input;

import com.baomidou.mybatisplus.annotations.TableField;
import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
/**
 * 系统管理-菜单表 查询参数
 *
 * @author: fugu
 * @description:
 * @date: 2019-08-19
 */
@Data
@ApiModel(description = "系统管理-菜单表 查询参数")
public class MenuQueryPara extends BasePageQuery{
    @ApiModelProperty(value = "id")
    private Integer menu_id;

    @ApiModelProperty(value = "上级菜单ID")
    private Integer parentId;

    @ApiModelProperty(value = "url")
    private String url;

    @ApiModelProperty(value = "菜单编码")
    private String resources;

    @ApiModelProperty(value = "菜单名称")
    private String title;

    @ApiModelProperty(value = "菜单级别")
    @TableField("level")
    private Integer level;
    /**
     * 排序
     */
    @ApiModelProperty(value = "排序")
    private Integer sortNo;
    /**
     * 菜单图标
     */
    @ApiModelProperty(value = "是否开启")
    private Integer status;

    @ApiModelProperty(value = "类型 menu、button")
    private String type;

    @ApiModelProperty(value = "备注")
    private String remarks;

}
