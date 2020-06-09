package com.fugu.modules.system.dto.output;

import com.google.common.collect.Lists;
import com.fugu.modules.system.entity.User;
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
public class UserTreeNode extends User {

    List<UserTreeNode> children = Lists.newArrayList();

}
