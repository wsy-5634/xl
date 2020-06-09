package com.fugu.modules.system.dto.output;

import com.fugu.modules.system.entity.Menu;
import com.google.common.collect.Lists;
import lombok.Data;

import java.util.List;

/**
 *  <p> 菜单树节点 </p>
 *
 * @description :
 * @author : fugu
 * @date : 2019/8/19 18:54
 */
@Data
public class MenuTreeNode extends Menu {

    List<MenuTreeNode> children = Lists.newArrayList();

}
