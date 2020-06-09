package com.fugu.modules.system.entity;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.IdType;
import com.fugu.modules.common.entity.BaseEntity;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;

/**
 * <p>  系统管理-部门表  </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Data
@ApiModel(description = "系统管理-部门表 ")
@TableName("t_sys_dept")
public class Dept extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 主键ID
     */
	@ApiModelProperty(value = "主键ID")
	@TableId(value="dept_id", type= IdType.AUTO)
	private Integer id;

    /**
     * 部门名称
     */
	@ApiModelProperty(value = "部门名称")
	@TableField("name")
	@NotBlank(message = "部门名称不能为空")
	private String name;

	/**
	 * 部门Secret
	 */
	@ApiModelProperty(value = "部门Secret")

	@TableField("org_secret")
	@NotBlank(message = "部门Secret不能为空")
	private String orgSecret;



	/**
	 * 直属上级
	 */
	@ApiModelProperty(value = "直属上级")
	@TableField("parent")
	private int parent;

    /**
     * 排序
     */
	@ApiModelProperty(value = "排序")
	@TableField("order")
	private int order;


	/**
	 * 标志 0--正常，1-删除
	 */
	@ApiModelProperty(value = "标志")
	@TableField("flag")
	private int flag;

	@ApiModelProperty(value = "备注")
	@TableField("remarks")
	private String remarks;//备注

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
