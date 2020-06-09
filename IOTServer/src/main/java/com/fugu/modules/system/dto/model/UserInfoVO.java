package com.fugu.modules.system.dto.model;

import com.google.common.collect.Sets;
import lombok.Data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Data
public class UserInfoVO implements Serializable {

    private int id;

    /**
     * 账号
     */
    private String username;

    private String nickName;

    /**
     * 性别：0是男 1是女
     */
    private String sex;

    /**
     * 手机号码
     */
    private String phone;

    /**
     * 邮箱
     */
    private String email;

    /**
     * 头像
     */
    private String avatar;

    /**
     * 状态
     */
    private String flag;

    private int deptId;//所属部门ID

    private Set<String> roleNames = Sets.newHashSet();
    private List<Integer> roles = new ArrayList();

    private Set<MenuVO> menus = Sets.newHashSet();

    private Set<ButtonVO> buttons = Sets.newHashSet();

}
