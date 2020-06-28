package com.fugu.modules.system.api;

import com.baomidou.mybatisplus.plugins.Page;
import com.fugu.modules.common.api.BaseController;
import com.fugu.modules.common.entity.PageResult;
import com.fugu.modules.shiro.service.ShiroService;
import com.fugu.modules.system.dto.input.UserRoleQueryPara;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.system.service.IUserRoleService;
import com.fugu.modules.common.dto.output.ApiResult;
import com.fugu.modules.system.entity.UserRole;
import com.fugu.modules.system.service.IUserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;


/**
 * <p> 系统管理 - 用户角色关联表  接口 </p>
 *
 * @author: fugu
 * @description:
 * @date: 2019-08-20
 *
 */
@RestController
@RequestMapping("/api/system/userRole")
@Api(description = "系统管理 - 用户角色关联表 接口")
public class SysUserRoleController extends BaseController {

    @Autowired
    IUserRoleService userRoleService;
    @Autowired
    private ShiroService shiroService;
    @Autowired
    IUserService userService;

    @PostMapping(value = "/list", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取系统管理 - 用户角色关联表 列表", httpMethod = "POST", response = ApiResult.class)
    public ApiResult list(@RequestBody UserRoleQueryPara filter) {
       List<UserRole> result = userRoleService.list(filter);
       return ApiResult.ok("获取系统管理 - 用户角色关联表 列表成功",result);
    }

    @PostMapping(value = "/saveOrUpdate", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "修改用户权限---用户权限管理", httpMethod = "POST", response = ApiResult.class)
    public ApiResult saveOrUpdate(@RequestBody UserRole input) {
       Integer id = userRoleService.save(input);
       return ApiResult.ok("保存系统管理 - 用户角色关联表 成功", id);
    }

    @PostMapping(value = "/delete", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "删除系统管理 - 用户角色关联表 ", httpMethod = "POST", response = ApiResult.class)
    public ApiResult delete(@RequestBody UserRoleQueryPara input) {
       userRoleService.deleteById(input.getId());
       return ApiResult.ok("删除系统管理 - 用户角色关联表 成功");
    }

    @PostMapping(value = "/detail", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "用户权限管理，根据ID获取 用户角色信息", httpMethod = "POST", response = ApiResult.class)
    public ApiResult detail(@RequestBody UserRoleQueryPara input) {
       UserRole entity = userRoleService.selectById(input.getId());
       return ApiResult.ok("获取用户角色关联信息成功", entity);
    }

    @PostMapping(value = "/saveUserRole", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "新建用户角色--用户角色管理", httpMethod = "POST", response = ApiResult.class)
    public ApiResult saveUserRole(@RequestBody UserRoleQueryPara input) {
       userRoleService.saveUserRole( input );
       // 更新shiro权限
       shiroService.updatePermissionByRoleId(input.getRole_id(), false);
       return ApiResult.ok("保存角色相关联用户成功");
    }

    @PostMapping(value = "/restPwd", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "重置用户密码", httpMethod = "POST", response = ApiResult.class)
    public ApiResult restPwd(@RequestParam(value = "id") Integer id) {
        boolean b = userRoleService.restPwd(id);
        if(!b){
            return ApiResult.fail("重置失败");
        }
        return ApiResult.ok("重置密码成功");
    }




    /**
     * @param key  要查询的关键字
     * @param page    起始页码，默认为1
     * @param rows    行数，默认为4
     * @return
     */
    @PostMapping(value = "/listByLoginname", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "根据登录名查询用户角色基本信息", httpMethod = "POST", response = ApiResult.class)
    public ApiResult listByLoginname(@RequestParam(value = "key", required = false)String key,
                                    @RequestParam(value = "page", defaultValue = "1")Integer page,
                                    @RequestParam(value = "rows",defaultValue = "4")Integer rows) {
//        Page<User> page = new Page<>(filter.getPage(), filter.getLimit());
        String name = null;
        PageResult<User> users = userService.NameAndDepPage(key,name,page,rows);
        return ApiResult.ok("获取用户基础信息表列表分页成功", users);
    }





}
