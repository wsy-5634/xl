package com.fugu.modules.system.dto.output;

import com.fugu.modules.system.entity.Dept;
import com.google.common.collect.Lists;
import lombok.Data;

import java.util.List;

/**
 *  <p> 用户树节点 </p>
 *
 * @description :
 * @author : fugu
 * @date : 2019/8/20 19:16
 */
@Data
public class DeptTreeNode extends Dept {

    List<DeptTreeNode> children = Lists.newArrayList();

}
