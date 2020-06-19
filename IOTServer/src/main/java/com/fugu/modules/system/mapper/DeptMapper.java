package com.fugu.modules.system.mapper;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.baomidou.mybatisplus.plugins.pagination.Pagination;
import com.fugu.modules.system.dto.input.DeptQueryPara;
import com.fugu.modules.system.entity.Dept;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * <p> 系统管理-角色表  Mapper 接口 </p>
 *
 * @author : fugu
 * @date : 2019-08-20
 */
public interface DeptMapper extends BaseMapper<Dept> {

    /**
     * 列表分页
     *
     * @param page
     * @param filter
     * @return
     */
    List<Dept> selectDepts(Pagination page, @Param("filter") DeptQueryPara filter);

    /**
     * 列表
     *
     * @param filter
     * @return
     */
    List<Dept> selectDepts(@Param("filter") DeptQueryPara filter);

    Integer getDeptIdBySecretOrName(@Param("filter") DeptQueryPara filter);



}
