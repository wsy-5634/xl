package com.fugu.modules.system.api;

import cn.hutool.core.bean.BeanUtil;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.plugins.Page;
import com.fugu.modules.common.api.BaseController;
import com.fugu.modules.common.entity.PageResult;
import com.fugu.modules.system.dto.input.DeptQueryPara;
import com.fugu.modules.system.dto.input.UserDeptQueryPara;
import com.fugu.modules.system.dto.model.UserInfoVO;
import com.fugu.modules.system.dto.output.UserTreeNode;
import com.fugu.modules.common.dto.output.ApiResult;
import com.fugu.modules.system.dto.input.UserQueryPara;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.system.service.IUserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.apache.http.util.TextUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * <p> 系统管理-用户基础信息表 接口 </p>
 * @author: fugu
 * @description:
 * @date: 2019-08-19
 */
@RestController
@RequestMapping("/api/system/user")
@Api(description = "系统管理-用户基础信息表接口")
public class SysUserController extends BaseController {

    @Autowired
    IUserService userService;

    @PostMapping(value = "/getCurrentUserInfo", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取当前登录用户信息", httpMethod = "POST", response = ApiResult.class, notes = "获取当前登录用户信息")
    public ApiResult getCurrentUserInfo(@RequestParam String token) {
//        if (TextUtils.isEmpty(token)) {
//            return ApiResult.fail("Token 为空");
//        }
        UserInfoVO info = userService.getCurrentUserInfo(token);
        return ApiResult.ok(200, "获取当前登录用户信息成功", info);
    }

    /**
     * 管理员登录后自动展示所用用户信息
     * @param filter
     * @return
     */
    @PostMapping(value = "/listPage", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取系统管理-用户基础信息表列表分页", httpMethod = "POST", response = ApiResult.class)
    public ApiResult listPage(@RequestBody UserQueryPara filter) {
       Page<User> page = new Page<>(filter.getPage(), filter.getLimit());
       userService.listPage(page, filter);
       return ApiResult.ok("获取用户基础信息表列表分页成功", page);
    }




    @PostMapping(value = "/treeUser", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取用户树", httpMethod = "POST", response = ApiResult.class)
    public ApiResult treeUser(@RequestBody UserQueryPara filter) {
       List<User> list = userService.list(filter);
       List<UserTreeNode> userTreeNodeList = new ArrayList<>();
       list.forEach(temp -> {
          UserTreeNode userTreeNode = new UserTreeNode();
          BeanUtil.copyProperties(temp, userTreeNode);
          userTreeNodeList.add(userTreeNode);
       });
       JSONObject json = new JSONObject();
       json.put("userList", list);
       json.put("userTree", userTreeNodeList);
       return ApiResult.ok("获取用户树成功", json);
    }

    @PostMapping(value = "/saveUserDept", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "保存用户部门设置", httpMethod = "POST", response = ApiResult.class)
    public ApiResult saveUserDept(@RequestBody UserDeptQueryPara filter) {
        boolean isSuccess = false;

        String userIdListString = filter.getUserIds();
        if (!TextUtils.isEmpty(userIdListString)) {
            String[] userIdList = userIdListString.split(",");
            for (String userIdString:userIdList) {
                User user = new User();
                user.setId(Integer.parseInt(userIdString));
                user.setDeptId(filter.getId());
                Integer number = userService.setUserDept(user);
                if (number != null && number > 0) {
                    isSuccess = true;
                }
            }
        }

        //删除的用户，部门设置为管理员的部门
        UserInfoVO managerInfo = userService.getCurrentUserInfo(filter.getToken());
        if (managerInfo != null) {
            int managerDeptId = managerInfo.getDeptId();

            String removedString = filter.getRemovedUserIds();
            if (!TextUtils.isEmpty(removedString)) {
                String[] removedUserIdList = removedString.split(",");
                for (String removedUserId:removedUserIdList) {
                    User user = new User();
                    user.setId(Integer.parseInt(removedUserId));
                    user.setDeptId(managerDeptId);
                    Integer number = userService.setUserDept(user);
                    if (number != null && number > 0) {
                        isSuccess = true;
                    }
                }
            }
        }

        if (isSuccess) {
            return ApiResult.ok("设置用户部门成功");
        } else {
            return ApiResult.fail("设置失败");
        }
    }


    @PostMapping(value = "/list", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取系统管理-用户基础信息表列表", httpMethod = "POST", response = ApiResult.class)
    public ApiResult list(@RequestBody UserQueryPara filter) {
       List<User> result = userService.list(filter);
       return ApiResult.ok("获取系统管理-用户基础信息表列表成功", result);
    }

    @PostMapping(value = "/listUserByDept", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "根据部门获取用户-用户基础信息表列表", httpMethod = "POST", response = ApiResult.class)
    public ApiResult listUserByDept(@RequestBody UserQueryPara filter) {
        List<User> result = userService.listByDept(filter);
        return ApiResult.ok("获取系统管理-用户基础信息表列表成功", result);
    }

    /**
     * @param key  要查询的关键字
     * @param page    起始页码，默认为1
     * @param rows    行数，默认为5
     * @return
     */
    @PostMapping(value = "/findByNameAndDept", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "根据部门和姓名查询用户基础信息表列表分页", httpMethod = "POST", response = ApiResult.class)
    public ApiResult NameAndDepPage(@RequestParam(value = "key", required = false)String key,
                                    @RequestBody DeptQueryPara filter,
                                    @RequestParam(value = "page", defaultValue = "1")Integer page,
                                    @RequestParam(value = "rows",defaultValue = "5")Integer rows) {
//        Page<User> page = new Page<>(filter.getPage(), filter.getLimit());
        PageResult<User> users = userService.NameAndDepPage(key, filter,page,rows);
        return ApiResult.ok("获取用户基础信息表列表分页成功", users);
    }

    @PostMapping(value = "/save", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "保存系统管理-用户基础信息表", httpMethod = "POST", response = ApiResult.class)
    // groups和默认校验同时应用 - 没有groups的属性和有groups的属性要想同时校验，则必须在value数组中同时指明，启动没有groups的属性通过Default.class来指定
    public ApiResult save(@RequestBody @Validated User input) {
       Integer id = userService.save(input);
       return ApiResult.ok("保存系统管理-用户基础信息表成功", id);
    }

    @PostMapping(value = "/updatePersonalInfo", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "修改个人信息", httpMethod = "POST", response = ApiResult.class)
    public ApiResult updatePersonalInfo(@RequestBody User input) {
       Integer id = userService.updatePersonalInfo(input);
       return ApiResult.ok("修改个人信息成功", id);
    }

    @PostMapping(value = "/delete", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "删除系统管理-用户基础信息表", httpMethod = "POST", response = ApiResult.class)
    public ApiResult delete(@RequestBody UserQueryPara input) {
       userService.deleteById(input.getId());
       return ApiResult.ok("删除系统管理-用户基础信息表成功");
    }

    @PostMapping(value = "/deleteBatches", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "批量删除", httpMethod = "POST", response = ApiResult.class)
    public ApiResult deleteBatches(List ids) {
        boolean b = userService.deleteBatches(ids);
        if(!b){
            return ApiResult.fail("删除失败");
        }
        return ApiResult.ok("批量删除成功");
    }

    @PostMapping(value = "/getById", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取系统管理-用户基础信息表信息", httpMethod = "POST", response = ApiResult.class)
    public ApiResult getById(@RequestBody UserQueryPara input) {
       User entity = userService.selectById(input.getId());
       return ApiResult.ok("获取系统管理-用户基础信息表信息成功", entity);
    }

}
