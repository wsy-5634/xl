package com.fugu.modules.system.service;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.IService;
import com.fugu.modules.system.dto.input.DeptQueryPara;
import com.fugu.modules.system.entity.Dept;

import java.util.List;

/**
 * <p>  系统管理-部门表  服务类 </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
public interface IDeptService extends IService<Dept> {

    /**
     * 系统管理-部门表 列表分页
     *
     * @param page
     * @param filter
     * @return
     */
    void listPage(Page<Dept> page, DeptQueryPara filter);

    /**
     * 保存系统管理-部门表
     *
     * @param input
     */
    Integer save(Dept input);

    /**
     * 系统管理-部门表 列表
     *
     * @param filter
     * @return
     */
    List<Dept> list(DeptQueryPara filter);
}
