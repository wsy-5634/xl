package com.fugu.modules.system.dto.input;

import com.baomidou.mybatisplus.annotations.TableField;
import com.fugu.modules.common.dto.input.BasePageQuery;
import com.fugu.modules.common.validator.Create;
import com.fugu.modules.common.validator.Update;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import java.util.List;

/**
 * 系统管理-用户基础信息表查询参数
 *
 * @author: fugu
 * @description:
 * @date: 2019-08-19
 */
@Data
@ApiModel(description = "系统管理-用户基础信息表查询参数")
public class UserQueryPara extends BasePageQuery{

    @ApiModelProperty(value = "id")
    private Integer id;

    @ApiModelProperty(value = "账号")
    private String loginname;

    @ApiModelProperty(value = "登录密码")
    private String password;

    /**
     * 明文密码 - QQ第三方授权登录时用
     */
    @ApiModelProperty(value = "明文密码")
    private String pwd;

    @ApiModelProperty(value = "真实姓名")
    private String name;

    @ApiModelProperty(value = "性别 0:男 1:女")
    private String sex;

    @ApiModelProperty(value = "手机号码")
    private String phone;

    @ApiModelProperty(value = "邮箱")
    private String email;

    @ApiModelProperty(value = "头像")
    private String avatar;

    @ApiModelProperty(value = "是否是管理员")
    private String flag;

    @ApiModelProperty(value = "是否启用")
    private Integer status;

    @ApiModelProperty(value = "盐值")
    private String salt;

    @ApiModelProperty(value = "token")
    private String token;

    @ApiModelProperty(value = "角色ID")
    private int role_id;

    @ApiModelProperty(value = "用户权限")
    private String roleList;


    @ApiModelProperty(value = "部门ID")
    private int dept_id;

    @ApiModelProperty(value = "最后登录时间")
    private String lastLoginTime;

    @ApiModelProperty(value = "用户编号")
    private Integer code;

    @ApiModelProperty(value = "添加时间")
    private String addtime;

    @ApiModelProperty(value = "QQ 第三方登录Oppen_ID唯一标识")
    private String qqOppenId;

    @ApiModelProperty(value = "移动办公云 第三方登录Oppen_ID唯一标识")
    private String mobileUserId;

}
