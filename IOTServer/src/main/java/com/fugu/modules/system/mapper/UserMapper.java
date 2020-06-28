package com.fugu.modules.system.mapper;

import com.baomidou.mybatisplus.mapper.BaseMapper;
import com.fugu.modules.system.dto.input.UserQueryPara;
import com.fugu.modules.system.entity.User;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import tk.mybatis.mapper.common.ExampleMapper;
import tk.mybatis.mapper.common.Marker;
import tk.mybatis.mapper.common.RowBoundsMapper;

import java.util.List;

/**
 * <p> 系统管理-用户基础信息表 Mapper 接口 </p>
 *
 * @author: fugu
 * @date: 2019-08-19
 */
public interface UserMapper extends BaseMapper<User>, ExampleMapper<User> {
    /**
     * 查询总数
     * @param filter
     * @return
     */
    int count(@Param("filter") UserQueryPara filter);


    /**
     * 注册或新增用户数账号查重
     * @param loginname
     * @return
     */
    @Select("select count(id) from t_sys_user where username=#{loginname}")
    int countBy(String loginname);

//    @Select("SELECT CODE FROM t_sys_user WHERE id=#{}")
//    Integer selectCodeByid(Integer id);


    /**
     * 列表
     *
     * @param filter
     * @return
     */
    List<User> selectUsers(@Param("filter") UserQueryPara filter);
    /**
     * 通过账号查找用户信息
     * @return: com.fugu.modules.system.entity.User
     */
    User selectUserByUsername(@Param("loginname") String loginname);

    /**
     * 批量删除
     */
    Integer deleteBatches(@Param("filter") List<Integer> ids);

    //根据用户ID查找角色ID
    Integer selectRoleidByID(@Param("id") Integer id);

    //重置用户密码
    @Update("UPDATE t_sys_user SET pwd = '123456' WHERE id = #{id}")
    void updatePwd(Integer id);

    /**
     * 通过手机号查找用户信息
     *
     * @param:
     * @return: com.fugu.modules.system.entity.User
     */
    User selectUserByMobile(@Param("mobile") String mobile);

    /**
     * 通过token查找用户信息
     *
     * @param token:
     * @return: com.fugu.modules.system.entity.User
     */
    User getUserInfoByToken(@Param("token") String token);
    /**
     * 通过移动云办公ID查找用户信息
     *
     * @param:
     * @return: com.fugu.modules.system.entity.User
     */
    User getUserInfoByMobileUserId(@Param("mobile_user_id") String userId);
    /**
     * 通过qq_oppen_id查找用户信息
     *
     * @param qqOppenId:
     * @return: com.fugu.modules.system.entity.User
     */
    User getUserInfoByQQ(@Param("qq_oppen_id") String qqOppenId);
    /**
     * 通过角色ID查询用户集合
     *
     * @param roleId:
     * @return: java.util.List<Role>
     */
    List<User> selectUserByRoleId(@Param("roleId") Integer roleId);

    Integer updateUserDept(@Param("filter") User user);

    List<User> selectUsersByDept(@Param("filter") Integer deptId);

//    @Select("SELECT * FROM t_sys_user WHERE id = #{id}")
    User getById(@Param("filter") Integer id);


    //通过loginname查找对应密码
    @Select("SELECT PASSWORD FROM t_sys_user WHERE loginname = #{loginname}")
    String passwordEncoder(String loginname);


    //根据loginname查找对应状态
    @Select("SELECT status FROM t_sys_user WHERE loginname = #{loginname}")
    int statusByloginname(String loginname);

}
