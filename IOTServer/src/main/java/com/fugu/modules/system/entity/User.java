package com.fugu.modules.system.entity;

import com.baomidou.mybatisplus.annotations.TableField;
import com.baomidou.mybatisplus.annotations.TableId;
import com.baomidou.mybatisplus.annotations.TableName;
import com.baomidou.mybatisplus.enums.IdType;
import com.fugu.modules.common.entity.BaseEntity;
import com.fugu.modules.common.validator.Create;
import com.fugu.modules.common.validator.FieldRepeatValidator;
import com.fugu.modules.common.validator.Update;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.io.Serializable;
import java.util.List;

/**
 * <p>  系统管理-用户基础信息表 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */

@Data
@ApiModel(description = "系统管理-用户基础信息表")
@TableName("t_sys_user")
// 对注解分组的排序，可以通脱他判断先后顺序
//@GroupSequence({FieldRepeatValidator.class,NotNull.class, Default.class})
@FieldRepeatValidator(field = "loginname", message = "账号重复，请重新输入账号！")
public class User extends BaseEntity<User> {
    private static final long serialVersionUID = 1L;

    /**
     * 主键ID  groups:标识在更新的时候才能验证非空
     */
	@ApiModelProperty(value = "主键ID")
	@TableId(value="id", type= IdType.AUTO)
	@NotNull(message = "用户id不能为空", groups={Update.class})
	private Integer id;
    /**
     * 账号
     */
	@ApiModelProperty(value = "账号")
	@TableField("loginname")
	@NotBlank(message = "账号不能为空", groups = {Create.class, Update.class})
	@Length(max = 100, message = "账号不能超过100个字符")
	@Pattern(regexp = "^[\\u4E00-\\u9FA5A-Za-z0-9\\*]*$", message = "账号限制：最多100字符，包含文字、字母和数字")
	private String loginname;
    /**
     * 登录密码
     */
	@ApiModelProperty(value = "登录密码")
	@TableField("password")
	private String password;
    /**
     * 明文密码 - QQ第三方授权登录时用
     */
	@ApiModelProperty(value = "明文密码")
	@TableField("pwd")
	@NotBlank(message = "密码不能为空")
//	@FieldRepeatValidator(className = "com.fugu.modules.system.entity.User", field = "pwd", message = "密码重复！")
//	@FieldRepeatValidator(className = "com.fugu.modules.system.entity.User", field = "pwd", message = "密码重复！",groups={FieldRepeatValidator.class})
	private String pwd;
    /**
     * 昵称
     */
	@ApiModelProperty(value = "真实姓名")
	@TableField("name")
	@NotBlank(message = "昵称不能为空")
	private String name;
    /**
     * 性别 0:男 1:女
     */
	@ApiModelProperty(value = "性别 0:男 1:女")
	@TableField("sex")
	private String sex;
    /**
     * 手机号码
     */
	@ApiModelProperty(value = "手机号码")
	@TableField("phone")
	@NotBlank(message = "手机号不能为空")
	@Pattern(regexp = "^[1][3,4,5,6,7,8,9][0-9]{9}$", message = "手机号格式有误")
	private String phone;
    /**
     * 邮箱
     */
	@ApiModelProperty(value = "邮箱")
	@TableField("email")
	@Email(message = "邮箱格式不对")
	private String email;
    /**
     * 头像
     */
	@ApiModelProperty(value = "头像")
	@TableField("avatar")
	private String avatar;

    /**
     * 状态
     */
	@ApiModelProperty(value = "是否是管理员")
	@TableField("flag")
	private String flag;

//	@ApiModelProperty(value = "是否启用")
//	@TableField("states")
//	@NotBlank(message = "是否启用不能为空")
//	private String states;
    /**
     * 盐值
     */
    @ApiModelProperty(value = "盐值")
    @TableField("salt")
    private String salt;
    /**
     * token
     */
	@ApiModelProperty(value = "token")
	@TableField("token")
	private String token;

	@ApiModelProperty(value = "角色ID")
	@NotBlank(message = "角色ID不能为空")
	@TableField("role_id")
	private int role_id;

	@ApiModelProperty(value = "用户角色")
	@TableField("roleList")
	@NotBlank(message = "权限不能为空")
	private String roleList;


	@ApiModelProperty(value = "部门ID")
	@TableField("dept_id")
	private int dept_id;

	@ApiModelProperty(value = "最后登录时间")
	@TableField("lastLoginTime")
	@NotBlank(message = "最后登录时间不能为空")
	private String lastLoginTime;

	@ApiModelProperty(value = "添加时间")
	@TableField("addtime")
	@NotBlank(message = "添加时间不能为空")
	private String addtime;

	@ApiModelProperty(value = "QQ 第三方登录Oppen_ID唯一标识")
	@TableField("qq_oppen_id")
	private String qqOppenId;

	@ApiModelProperty(value = "移动办公云 第三方登录Oppen_ID唯一标识")
	@TableField("mobile_user_id")
	private String mobileUserId;

	@ApiModelProperty(value = "用户编号")
	@TableField("code")
	private Integer code;



//	@NotBlank(message = "身份证号不能为空")
//	@IdentityCardNumber(message = "身份证信息有误,请核对后提交")
//	private String clientCardNo;

	@Override
	protected Serializable pkVal() {
		return this.id;
	}

}
