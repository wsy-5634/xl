package com.fugu.modules.system.entity;

import com.baomidou.mybatisplus.enums.IdType;
import java.util.Date;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.enums.IdType;
import com.baomidou.mybatisplus.activerecord.Model;
import com.baomidou.mybatisplus.annotations.TableName;
import java.io.Serializable;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * <p>  系统管理 - 角色-权限资源关联表  </p>
 *
 * @author: fugu
 * @date: 2020-02-23 13:58:28
 */
@Data
@ApiModel(description = "系统管理 - 角色-权限资源关联表 ")
@TableName("t_sys_user_file")
public class SysUserFile extends Model<SysUserFile> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键
     */
	@ApiModelProperty(value = "主键")
	@TableId(value="id", type= IdType.AUTO)
	private Integer id;
    /**
     * 部门ID
     */
	@ApiModelProperty(value = "部门ID")
	@TableField("dept_id")
	private Integer deptId;
    /**
     * 用户ID
     */
	@ApiModelProperty(value = "用户ID")
	@TableField("user_id")
	private Integer userId;
    /**
     * 文件ID
     */
	@ApiModelProperty(value = "文件ID")
	@TableField("file_id")
	private Integer fileId;
    /**
     * 创建时间
     */
	@ApiModelProperty(value = "创建时间")
	@TableField("gmt_create")
	private Date gmtCreate;
    /**
     * 更新时间
     */
	@ApiModelProperty(value = "更新时间")
	@TableField("gmt_modified")
	private Date gmtModified;

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
