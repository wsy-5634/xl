package com.fugu.modules.system.dto.input;

import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

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
    private String username;

    @ApiModelProperty(value = "手机")
    private String mobile;

    @ApiModelProperty(value = "密码")
    private String password;

    @ApiModelProperty(value = "QQ第三方登录授权认证成功后的openID")
    private String openId;

    @ApiModelProperty(value = "移动办公云第三方登录授权认证成功后的openID")
    private String userId;

    @ApiModelProperty(value = "第三方登录授权认证成功后的token")
    private String accessToken;

    @ApiModelProperty(value = "角色ID")
    private int roleId;

    @ApiModelProperty(value = "部门ID")
    private int deptId;

    @ApiModelProperty(value = "部门密钥")
    private  String deptSecret;

    @ApiModelProperty(value = "是否是管理员")
    private int flag;
}
