package com.fugu.modules.system.entity;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.IdType;
import com.fugu.modules.common.entity.BaseEntity;
import com.fugu.modules.common.validator.FieldRepeatValidator;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;

/**
 * <p>  系统管理-权限菜单表  </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
@Data
@ApiModel(description = "系统管理-菜单表 ")
@TableName("t_sys_menu")
@FieldRepeatValidator(field = "resources", message = "菜单编码重复！")
public class Menu  {
    private static final long serialVersionUID = 1L;

	@ApiModelProperty(value = "主键")
	@TableId(value="menu_id", type= IdType.AUTO)
	private Integer menu_id;

	@ApiModelProperty(value = "上级菜单ID")
	@TableField("parentId")
	private Integer parentId;

	@ApiModelProperty(value = "url")
	@TableField("url")
	private String url;

	@ApiModelProperty(value = "菜单编码")
	@TableField("resources")
	@NotBlank(message = "菜单编码不能为空")
	@Length(max = 100, message = "菜单编码不能超过100个字符")
	private String resources;

	@ApiModelProperty(value = "菜单名称")
	@TableField("title")
	@NotBlank(message = "菜单名称不能为空")
	private String title;

	@ApiModelProperty(value = "菜单级别")
	@TableField("level")
	private Integer level;

	@ApiModelProperty(value = "排序")
	@TableField("sortNo")
	private Integer sortNo;
    /**
     * 类型 menu、button
     */
	@ApiModelProperty(value = "类型 menu、button")
	@TableField("type")
	@NotBlank(message = "类型不能为空")
	private String type;

	@ApiModelProperty(value = "是否开启")
	@TableField("status")
	private Integer status;

}
