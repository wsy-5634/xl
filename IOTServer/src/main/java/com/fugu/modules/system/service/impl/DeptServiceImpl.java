package com.fugu.modules.system.service.impl;

import com.baomidou.mybatisplus.plugins.Page;
import com.baomidou.mybatisplus.service.impl.ServiceImpl;
import com.fugu.modules.system.dto.input.DeptQueryPara;
import com.fugu.modules.system.entity.Dept;
import com.fugu.modules.system.mapper.DeptMapper;
import com.fugu.modules.system.service.IDeptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * <p> 系统管理-角色表  服务实现类 </p>
 *
 * @author: fugu
 * @date: 2019-08-20
 */
@Service
@Transactional
public class DeptServiceImpl extends ServiceImpl<DeptMapper, Dept> implements IDeptService {

    @Autowired
    DeptMapper deptMapper;

    @Override
    public void listPage(Page<Dept> page, DeptQueryPara filter) {
        filter.setPage(page.getCurrent());
        filter.setLimit(page.getSize());
        page.setRecords(deptMapper.selectDepts(filter));
    }

    @Override
    public List<Dept> list(DeptQueryPara filter) {
       return deptMapper.selectDepts(filter);
    }

    @Override
    public Integer save(Dept para) {
       if (para.getId()!=null) {
          deptMapper.updateById(para);
       } else {
          deptMapper.insert(para);
       }
       return para.getId();
    }

}
