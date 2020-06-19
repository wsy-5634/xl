package com.fugu.modules.system.dto.input;

import com.fugu.modules.common.dto.input.BasePageQuery;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.Date;

/**
 * 用户登录
 *
 * @author: fugu
 * @description:
 * @date: 2019-09-18 10:51:57
 */
@Data
@ApiModel(description = "用户登录-- 查询参数")
public class LoginQueryPara extends UserQueryPara{

    @ApiModelProperty(value = "appId")
    private String appId;

    @ApiModelProperty(value = "秘钥")
    private String appSecret;

    @ApiModelProperty(value = "数字身份")
    private String OpenId;

    @ApiModelProperty(value = "动态口令")
    private String AccessToken;

}
