package com.fugu.modules.system.api;

import cn.hutool.core.bean.BeanUtil;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.plugins.Page;
import com.fugu.modules.common.api.BaseController;
import com.fugu.modules.common.dto.output.ApiResult;
import com.fugu.modules.system.dto.input.DeptQueryPara;
import com.fugu.modules.system.dto.output.DeptTreeNode;
import com.fugu.modules.system.dto.output.UserTreeNode;
import com.fugu.modules.system.entity.Dept;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.system.service.IDeptService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;


/**
 * <p> 系统管理-部门表  接口 </p>
 *
 * @author: fugu
 * @description:
 * @date: 2019-08-20
 *
 */
@RestController
@RequestMapping("/api/system/dept")
@Api(description = "系统管理-部门表 接口")
public class SysDeptController extends BaseController {

    @Autowired
    IDeptService deptService;

    @PostMapping(value = "/listPage", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取系统管理-部门表 列表分页", httpMethod = "POST", response = ApiResult.class)
    public ApiResult listPage(@RequestBody DeptQueryPara filter) {
       Page<Dept> page = new Page<>(filter.getPage(),filter.getLimit());
       deptService.listPage(page, filter);
       return ApiResult.ok("获取系统管理-部门表 列表分页成功", page);
    }

    @PostMapping(value = "/list", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取系统管理-部门表 列表", httpMethod = "POST", response = ApiResult.class)
    public ApiResult list(@RequestBody DeptQueryPara filter) {
       List<Dept> result = deptService.list(filter);
       return ApiResult.ok("获取系统管理-部门表 列表成功",result);
    }

    @PostMapping(value = "/treeDept", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取系统管理-部门表 列表", httpMethod = "POST", response = ApiResult.class)
    public ApiResult treeDept(@RequestBody DeptQueryPara filter) {
        List<Dept> list = deptService.list(filter);
        List<DeptTreeNode> userTreeNodeList = new ArrayList<>();
        list.forEach(temp -> {
            DeptTreeNode userTreeNode = new DeptTreeNode();
            BeanUtil.copyProperties(temp, userTreeNode);
            userTreeNodeList.add(userTreeNode);
        });
        JSONObject json = new JSONObject();
        json.put("deptList", list);
        json.put("deptTree", userTreeNodeList);
        return ApiResult.ok("获取部门树成功", json);
    }

    @PostMapping(value = "/saveOrUpdate", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "保存或更新部门", httpMethod = "POST", response = ApiResult.class)
    public ApiResult saveOrUpdate(@RequestBody @Validated Dept input) {
       Integer id = deptService.save(input);
       return ApiResult.ok("保存部门成功", id);
    }

    @PostMapping(value = "/delete", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "删除部门 ", httpMethod = "POST", response = ApiResult.class)
    public ApiResult delete(@RequestBody DeptQueryPara input) {
       deptService.deleteById(input.getId());
       return ApiResult.ok("删除部门成功");
    }

    @PostMapping(value = "/detail", produces = "application/json;charset=utf-8")
    @ApiOperation(value = "获取部门信息", httpMethod = "POST", response = ApiResult.class)
    public ApiResult detail(@RequestBody DeptQueryPara input) {
       Dept entity = deptService.selectById(input.getId());
       return ApiResult.ok("获取部门信息成功", entity);
    }

}
