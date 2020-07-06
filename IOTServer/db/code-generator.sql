/*
Navicat MySQL Data Transfer

Source Server         : main
Source Server Version : 50728
Source Host           : localhost:3306
Source Database       : filemanager

Target Server Type    : MYSQL
Target Server Version : 50728
File Encoding         : 65001

Date: 2020-02-25 17:58:41
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tb_category
-- ----------------------------
DROP TABLE IF EXISTS `tb_category`;
CREATE TABLE `tb_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `sort` int(11) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tb_category
-- ----------------------------
INSERT INTO `tb_category` VALUES ('1', '时政', null, '1', '2020-02-11 06:50:55', null);
INSERT INTO `tb_category` VALUES ('2', '国际', null, '2', '2020-02-19 06:51:14', null);
INSERT INTO `tb_category` VALUES ('3', '娱乐', null, '3', '2020-02-19 06:51:48', null);
INSERT INTO `tb_category` VALUES ('4', '先锋', null, '4', '2020-02-20 06:52:14', null);

-- ----------------------------
-- Table structure for tb_file
-- ----------------------------
DROP TABLE IF EXISTS `tb_file`;
CREATE TABLE `tb_file` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `category_id` int(255) NOT NULL COMMENT '类别',
  `category_name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of tb_file
-- ----------------------------
INSERT INTO `tb_file` VALUES ('1', '习近平讲话2', '1', '时政', 'D:\\时政\\习近平总书记关切事｜“菜篮子”里的力量——全国各地努力做好保障和改善民生工作在行动.docx', '2020-02-19 07:00:10', null);
INSERT INTO `tb_file` VALUES ('2', '习近平讲话PDF', '1', '时政', 'D:\\时政\\习近平总书记关切事｜“菜篮子”里的力量——全国各地努力做好保障和改善民生工作在行动.pdf', '2020-02-19 11:35:54', null);
INSERT INTO `tb_file` VALUES ('3', '习近平讲话3', '2', '国际', 'D:\\时政\\习近平总书记关切事｜“菜篮子”里的力量——全国各地努力做好保障和改善民生工作在行动.pdf', '2020-02-19 11:35:57', null);
INSERT INTO `tb_file` VALUES ('4', '习近平讲话1', '2', '国际', 'D:\\时政\\习近平总书记关切事｜“菜篮子”里的力量——全国各地努力做好保障和改善民生工作在行动.pdf', '2020-02-20 11:36:19', null);

-- ----------------------------
-- Table structure for t_code_bs_template
-- ----------------------------
DROP TABLE IF EXISTS `t_code_bs_template`;
CREATE TABLE `t_code_bs_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '初始模板ID',
  `type` varchar(20) DEFAULT NULL COMMENT '模板类型 ex: entity、service、mapper...',
  `file_suffix` varchar(20) DEFAULT NULL COMMENT '生成文件后缀名 .java',
  `content` text COMMENT '模板内容',
  `user_id` int(11) DEFAULT NULL COMMENT '所属用户ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='初始模板表';

-- ----------------------------
-- Records of t_code_bs_template
-- ----------------------------
INSERT INTO `t_code_bs_template` VALUES ('1', 'entity', '.java', 'package ${package.Entity};\n\n#foreach($pkg in ${table.importPackages})\nimport ${pkg};\n#end\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * <p>  ${table.comment} </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n#if(${table.convert})\n@Data\n@ApiModel(description = \"${table.comment}\")\n@TableName(\"${table.name}\")\n#end\n#if(${superEntityClass})\npublic class ${entity} extends ${superEntityClass}#if(${activeRecord})<${entity}>#end {\n#elseif(${activeRecord})\npublic class ${entity} extends Model<${entity}> {\n#else\npublic class ${entity} implements Serializable {\n#end\n\n    private static final long serialVersionUID = 1L;\n\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})\n#set($keyPropertyName=${field.propertyName})\n#end\n#if(\"$!field.comment\" != \"\")\n    /**\n     * ${field.comment}\n     */\n	@ApiModelProperty(value = \"${field.comment}\")\n#end\n#if(${field.keyFlag})\n	@TableId(value=\"${field.name}\", type= IdType.AUTO)\n#else\n	@TableField(\"${field.name}\")\n#end\n	private ${field.propertyType} ${field.propertyName};\n#end\n\n#if(${entityColumnConstant})\n#foreach($field in ${table.fields})\n	public static final String ${field.name.toUpperCase()} = \"${field.name}\";\n\n#end\n#end\n#if(${activeRecord})\n	@Override\n	protected Serializable pkVal() {\n#if(${keyPropertyName})\n		return this.${keyPropertyName};\n#else\n		return this.id;\n#end\n	}\n\n#end\n}\n', '1', '2019-08-20 14:55:29', '2019-09-18 09:04:22');
INSERT INTO `t_code_bs_template` VALUES ('2', ' mapper.xml', '.xml', '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\">\n<mapper namespace=\"${package.Mapper}.${table.mapperName}\">\n\n#if(${enableCache})\n	<!-- 开启二级缓存 -->\n	<cache type=\"org.mybatis.caches.ehcache.LoggingEhcache\"/>\n\n#end\n#if(${baseResultMap})\n	<!-- 通用查询映射结果 -->\n	<resultMap id=\"BaseResultMap\" type=\"${package.Entity}.${entity}\">\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})##生成主键排在第一位\n		<id column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n#foreach($field in ${table.fields})\n#if(!${field.keyFlag})##生成普通字段\n		<result column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n	</resultMap>\n\n#end\n#if(${baseColumnList})\n    <!-- 通用查询结果列 -->\n    <sql id=\"Base_Column_List\">\n        ${table.fieldNames}\n    </sql>\n\n#end\n\n    <select id=\"select${entity}s\" resultMap=\"BaseResultMap\">\n        SELECT\n             *\n        FROM ${table.name}\n        WHERE\n             1 = 1\n        <if test=\"filter.id!=null and filter.id!=\'\'\">\n            AND	${entity}_ID= #{filter.id}\n        </if>\n        ORDER BY ${entity}_ID DESC\n    </select>\n\n</mapper>\n', '1', '2019-08-20 14:55:10', '2019-09-18 09:04:08');
INSERT INTO `t_code_bs_template` VALUES ('3', 'mapper', '.java', 'package ${package.Mapper};\n\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${superMapperClassPackage};\nimport com.baomidou.mybatisplus.plugins.pagination.Pagination;\nimport org.apache.ibatis.annotations.Param;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} Mapper 接口 </p>\n *\n * @author : zhengqing\n * @date : ${date}\n */\npublic interface ${table.mapperName} extends ${superMapperClass}<${entity}> {\n\n    /**\n     * 列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(Pagination page, @Param(\"filter\") ${formQueryPara} filter);\n\n    /**\n     * 列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(@Param(\"filter\") ${formQueryPara} filter);\n}', '1', '2019-08-20 14:54:39', '2019-09-18 09:03:47');
INSERT INTO `t_code_bs_template` VALUES ('4', ' service', '.java', 'package ${package.Service};\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport ${superServiceClassPackage};\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\n\nimport java.util.List;\n\n/**\n * <p>  ${table.comment} 服务类 </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\npublic interface ${table.serviceName} extends ${superServiceClass}<${entity}> {\n\n    /**\n     * ${table.comment}列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    void listPage(Page<${entity}> page, ${formQueryPara} filter);\n\n    /**\n     * 保存${table.comment}\n     *\n     * @param input\n     */\n    Integer save(${entity} input);\n\n    /**\n     * ${table.comment}列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> list(${formQueryPara} filter);\n}\n', '1', '2019-08-20 14:54:14', '2019-09-18 09:03:31');
INSERT INTO `t_code_bs_template` VALUES ('5', ' service.impl', '.java', 'package ${package.ServiceImpl};\n\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${package.Mapper}.${table.mapperName};\nimport ${package.Service}.${table.serviceName};\nimport ${superServiceImplClassPackage};\nimport com.baomidou.mybatisplus.plugins.Page;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.stereotype.Service;\nimport org.springframework.transaction.annotation.Transactional;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} 服务实现类 </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n@Service\n@Transactional\npublic class ${table.serviceImplName} extends ${superServiceImplClass}<${table.mapperName}, ${entity}> implements ${table.serviceName} {\n\n    @Autowired\n    ${table.mapperName} ${entityPropertyName}Mapper;\n\n    @Override\n    public void listPage(Page<${entity}> page, ${formQueryPara} filter) {\n        page.setRecords(${entityPropertyName}Mapper.select${entity}s(page, filter));\n    }\n\n    @Override\n    public List<${entity}> list(${formQueryPara} filter) {\n        return ${entityPropertyName}Mapper.select${entity}s(filter);\n    }\n\n    @Override\n    public Integer save(${entity} para) {\n        if (para.get${entity}Id()!=null) {\n            ${entityPropertyName}Mapper.updateById(para);\n        } else {\n            ${entityPropertyName}Mapper.insert(para);\n        }\n        return para.get${entity}Id();\n    }\n}\n', '1', '2019-08-20 14:53:45', '2019-09-18 09:03:18');
INSERT INTO `t_code_bs_template` VALUES ('6', 'api', '.java', 'package ${package.Controller};\n\nimport com.zhengqing.modules.common.api.BaseController;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.web.bind.annotation.*;\n\nimport java.util.List;\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport com.zhengqing.modules.common.dto.output.ApiResult;\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${package.Service}.${table.serviceName};\nimport io.swagger.annotations.Api;\nimport io.swagger.annotations.ApiOperation;\n\n\n/**\n * <p> ${table.comment} 接口 </p>\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n *\n */\n@RestController\n@RequestMapping(\"/api#if(${package.ModuleName})/${package.ModuleName}#end/${table.entityPath}\")\n@Api(description = \"${table.comment}接口\")\npublic class ${table.controllerName} extends BaseController {\n\n    @Autowired\n    ${table.serviceName} ${entityPropertyName}Service;\n\n    @PostMapping(value = \"/listPage\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表分页\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult listPage(@RequestBody ${formQueryPara} filter) {\n        Page<${entity}> page = new Page<>(filter.getPage(),filter.getLimit());\n        ${entityPropertyName}Service.listPage(page, filter);\n        return ApiResult.ok(\"获取${table.comment}列表分页成功\", page);\n    }\n\n    @PostMapping(value = \"/list\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult list(@RequestBody ${formQueryPara} filter) {\n        List<${entity}> result = ${entityPropertyName}Service.list(filter);\n        return ApiResult.ok(\"获取${table.comment}列表成功\",result);\n    }\n\n    @PostMapping(value = \"/save\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"保存${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult save(@RequestBody ${entity} input) {\n        Integer id = ${entityPropertyName}Service.save(input);\n        return ApiResult.ok(\"保存${table.comment}成功\", id);\n    }\n\n    @PostMapping(value = \"/delete\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"删除${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult delete(@RequestBody ${formQueryPara} input) {\n        ${entityPropertyName}Service.deleteById(input.getId());\n        return ApiResult.ok(\"删除${table.comment}成功\");\n    }\n\n    @PostMapping(value = \"/getById\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}信息\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult getById(@RequestBody ${formQueryPara} input) {\n        ${entity} entity = ${entityPropertyName}Service.selectById(input.getId());\n        return ApiResult.ok(\"获取${table.comment}信息成功\", entity);\n    }\n\n}', '1', '2019-08-20 14:53:20', '2019-09-18 09:02:59');
INSERT INTO `t_code_bs_template` VALUES ('7', 'input', '.java', 'package ${package.QueryPara};\n\nimport com.zhengqing.modules.common.dto.input.BasePageQuery;\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * ${table.comment}查询参数\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n */\n@Data\n@ApiModel(description = \"${table.comment}查询参数\")\npublic class ${formQueryPara} extends BasePageQuery{\n    @ApiModelProperty(value = \"id\")\n    private int id;\n}\n', '1', '2019-08-20 14:52:44', '2019-09-18 09:02:41');
INSERT INTO `t_code_bs_template` VALUES ('8', 'vue', '.vue', '<template>\n  <div class=\"app-container\">\n    <cus-wraper>\n      <cus-filter-wraper>\n        #if(${queryFields})\n        #foreach($field in ${queryFields})\n        <el-input v-model=\"listQuery.${field.propertyName}\" placeholder=\"请输入${field.comment}\" style=\"width:200px\" clearable></el-input>\n        #end\n        <el-button type=\"primary\" @click=\"getList\" icon=\"el-icon-search\" v-waves>查询</el-button>\n        <el-button type=\"primary\" @click=\"handleCreate\" icon=\"el-icon-plus\" v-waves>添加</el-button>        \n        #end\n      </cus-filter-wraper>\n      <div class=\"table-container\">\n        <el-table v-loading=\"listLoading\" :data=\"list\" size=\"mini\" element-loading-text=\"Loading\" fit border highlight-current-row>\n	        #foreach($field in ${table.fields})\n	        #if(${field.propertyType.equals(\"Date\")})\n	        <el-table-column label=\"${field.comment}\" align=\"center\">\n	            <template slot-scope=\"scope\">\n	                <span>{{scope.row.${field.propertyName}|dateTimeFilter}}</span>\n	            </template>\n	        </el-table-column>\n	        #else\n	        <el-table-column label=\"${field.comment}\" prop=\"${field.propertyName}\" align=\"center\"></el-table-column>\n	        #end\n	        #end\n          <el-table-column align=\"center\" label=\"操作\">\n            <template slot-scope=\"scope\">\n              <el-button size=\"mini\" type=\"primary\" @click=\"handleUpdate(scope.row)\" icon=\"el-icon-edit\" plain v-waves>编辑</el-button>\n              <cus-del-btn @ok=\"handleDelete(scope.row)\"></cus-del-btn>\n            </template>\n          </el-table-column>\n        </el-table>\n        <!-- 分页 -->\n        <cus-pagination v-show=\"total>0\" :total=\"total\" :page.sync=\"listQuery.page\" :limit.sync=\"listQuery.limit\" @pagination=\"getList\"/>\n      </div>\n\n      <el-dialog :title=\"titleMap[dialogStatus]\" :visible.sync=\"dialogVisible\" width=\"40%\" @close=\"handleDialogClose\">\n        <el-form ref=\"dataForm\" :model=\"form\" :rules=\"rules\" label-width=\"100px\" class=\"demo-ruleForm\">\n        #foreach($field in ${table.fields})\n        <el-form-item label=\"${field.comment}:\" prop=\"${field.propertyName}\">\n            <el-input v-model=\"form.${field.propertyName}\"></el-input>\n        </el-form-item>\n        #end\n        </el-form>\n        <span slot=\"footer\" class=\"dialog-footer\">\n          <el-button @click=\"dialogVisible = false\" v-waves>取 消</el-button>\n          <el-button type=\"primary\" @click=\"submitForm\" v-waves>确 定</el-button>\n        </span>\n      </el-dialog>\n    </cus-wraper>\n  </div>\n</template>\n\n<script>\n import { get${entity}Page, save${entity}, delete${entity} } from \"@/api/${package.ModuleName}/${entityPropertyName}\";\n\nexport default {\n  data() {\n    return {\n      dialogVisible: false,\n      list: [],\n      listLoading: true,\n      total: 0,\n      listQuery: {\n        page: 1,\n        limit: 10,\n	    #if(${queryFields})\n	    #foreach($field in ${queryFields})\n	    ${field.propertyName}:undefined,\n	    #end\n	    #end\n      },\n      input: \'\',\n      form: {\n	     #foreach($field in ${table.fields})\n	     ${field.propertyName}: undefined, //${field.comment}\n	     #end\n      },\n     dialogStatus: \"\",\n     titleMap: {\n        update: \"编辑\",\n        create: \"创建\"\n     },\n     rules: {\n         name: [\n            { required: true, message: \'请输入项目名称\', trigger: \'blur\' }\n         ]\n      }\n    }\n  },\n  created() {\n    this.getList();\n  },\n  methods: {\n    getList() {\n      this.listLoading = true;\n      get${entity}Page(this.listQuery).then(response => {\n        this.list = response.data.records;\n    	this.total = response.data.total;\n    	this.listLoading = false;\n		});\n    },\n    handleCreate() {\n        this.resetForm();\n        this.dialogStatus = \"create\";\n        this.dialogVisible = true;\n    },\n    handleUpdate(row) {\n        this.form = Object.assign({}, row);\n        this.dialogStatus = \"update\";\n        this.dialogVisible = true;\n    },\n    handleDelete(row) {\n      #foreach($field in ${table.fields})\n		#if(${field.keyFlag})\n		 let id = row.${field.propertyName};\n		#end\n	  #end\n      delete${entity}(id).then(response => {\n            if (response.code == 200) {\n            this.getList();\n            this.submitOk(response.message);\n        } else {\n            this.submitFail(response.message);\n        }\n    });\n    },\n    submitForm() {\n    this.#[[$refs]]#.[\'dataForm\'].validate(valid => {\n        if (valid) {\n            save${entity}(this.form).then(response => {\n                if (response.code == 200) {\n                    this.getList();\n                    this.submitOk(response.message);\n                    this.dialogVisible = false;\n                } else {\n                     this.submitFail(response.message);\n                }\n        }).catch(err => { console.log(err);  });\n            }\n        });\n    },\n    resetForm() {\n        this.form = {\n            #foreach($field in ${table.fields})\n                ${field.propertyName}: undefined, //${field.comment}\n            #end\n        };\n    },\n    // 监听dialog关闭时的处理事件\n    handleDialogClose(){\n        if(this.$refs[\'dataForm\']){\n             this.$refs[\'dataForm\'].clearValidate(); // 清除整个表单的校验\n        }\n    }\n  }\n}\n</script>', '1', '2019-08-20 14:52:19', '2019-09-18 09:02:12');
INSERT INTO `t_code_bs_template` VALUES ('9', 'js', '.js', 'import request from \'@/utils/request\';\n\nexport function get${entity}Page(query) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/listPage\',\n        method: \'post\',\n        data: query\n    });\n}\n\nexport function save${entity}(form) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/save\',\n        method: \'post\',\n        data: form\n    });\n}\n\nexport function delete${entity}(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/delete\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}\n\nexport function get${entity}ById(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/getById\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}', '1', '2019-08-17 18:13:10', '2019-09-17 17:57:43');

-- ----------------------------
-- Table structure for t_code_database
-- ----------------------------
DROP TABLE IF EXISTS `t_code_database`;
CREATE TABLE `t_code_database` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '数据库ID',
  `project_id` int(11) DEFAULT NULL COMMENT '所属项目ID',
  `name` varchar(50) DEFAULT NULL COMMENT '数据库名称',
  `url` varchar(255) DEFAULT NULL COMMENT '数据库连接',
  `user` varchar(50) DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) DEFAULT NULL COMMENT '密码',
  `db_schema` varchar(50) DEFAULT NULL COMMENT 'SCHEMA',
  `db_type` tinyint(2) DEFAULT '1' COMMENT '数据库类型 1:mysql  2:oracle',
  `driver` varchar(255) DEFAULT NULL COMMENT '驱动程序',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='数据库信息表';

-- ----------------------------
-- Records of t_code_database
-- ----------------------------
INSERT INTO `t_code_database` VALUES ('2', '1', 'filemanager', 'jdbc:mysql://localhost:3306/filemanager', 'root', '123456', 'filemanager', '1', 'com.mysql.jdbc.Driver', '2019-09-13 03:01:15', '2020-02-21 20:43:37');

-- ----------------------------
-- Table structure for t_code_project
-- ----------------------------
DROP TABLE IF EXISTS `t_code_project`;
CREATE TABLE `t_code_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `name` varchar(50) CHARACTER SET utf8 DEFAULT '' COMMENT '项目名称',
  `user_id` int(11) DEFAULT NULL COMMENT '所属用户ID',
  `status` bit(1) DEFAULT NULL COMMENT '状态：是否启用  0:停用  1:启用',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='代码生成器 - 项目管理表';

-- ----------------------------
-- Records of t_code_project
-- ----------------------------
INSERT INTO `t_code_project` VALUES ('1', 'Study', '1', '', '2019-09-10 13:56:35', '2020-02-21 16:46:42');

-- ----------------------------
-- Table structure for t_code_project_package
-- ----------------------------
DROP TABLE IF EXISTS `t_code_project_package`;
CREATE TABLE `t_code_project_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '包ID',
  `name` varchar(100) DEFAULT NULL COMMENT '包名',
  `parent_id` int(11) DEFAULT NULL COMMENT '父包ID',
  `project_id` int(11) DEFAULT NULL COMMENT '关联项目ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='代码生成器 - 项目包管理表';

-- ----------------------------
-- Records of t_code_project_package
-- ----------------------------
INSERT INTO `t_code_project_package` VALUES ('1', 'com.codingcat.modules', '0', '1', '2019-09-10 13:56:35', '2020-02-21 16:35:33');
INSERT INTO `t_code_project_package` VALUES ('2', 'common', '1', '1', '2019-09-10 13:56:35', '2019-09-10 13:56:35');
INSERT INTO `t_code_project_package` VALUES ('3', 'entity', '1', '1', '2019-09-10 13:56:35', '2019-09-10 13:56:35');
INSERT INTO `t_code_project_package` VALUES ('4', 'service', '1', '1', '2019-09-10 13:56:35', '2019-09-10 13:56:35');
INSERT INTO `t_code_project_package` VALUES ('5', 'service.impl', '1', '1', '2019-09-10 13:56:35', '2019-09-17 12:41:00');
INSERT INTO `t_code_project_package` VALUES ('6', 'mapper', '1', '1', '2019-09-10 13:56:35', '2019-09-10 13:56:35');
INSERT INTO `t_code_project_package` VALUES ('7', 'mapper.xml', '1', '1', '2019-09-10 13:56:35', '2019-09-17 12:41:07');
INSERT INTO `t_code_project_package` VALUES ('18', 'api', '1', '1', '2019-09-12 19:08:07', '2019-09-12 19:08:07');
INSERT INTO `t_code_project_package` VALUES ('19', 'js', '1', '1', '2019-09-12 21:20:04', '2019-09-12 21:21:18');
INSERT INTO `t_code_project_package` VALUES ('20', 'vue', '1', '1', '2019-09-12 21:21:27', '2019-09-12 21:21:27');
INSERT INTO `t_code_project_package` VALUES ('21', 'dto', '1', '1', '2019-09-12 21:58:47', '2019-09-12 21:58:47');
INSERT INTO `t_code_project_package` VALUES ('22', 'input', '21', '1', '2019-09-12 21:58:58', '2019-09-12 21:58:58');

-- ----------------------------
-- Table structure for t_code_project_template
-- ----------------------------
DROP TABLE IF EXISTS `t_code_project_template`;
CREATE TABLE `t_code_project_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `project_id` int(11) DEFAULT NULL COMMENT '项目ID',
  `type` int(11) DEFAULT NULL COMMENT '模板类型 - 对应包ID',
  `file_suffix` varchar(20) DEFAULT NULL COMMENT '生成文件后缀名 .java',
  `content` text COMMENT '模板内容',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目代码模板表';

-- ----------------------------
-- Records of t_code_project_template
-- ----------------------------
INSERT INTO `t_code_project_template` VALUES ('19', '1', '3', '.java', 'package ${package.entity};\n\n#foreach($pkg in ${table.importPackages})\nimport ${pkg};\n#end\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * <p>  ${table.comment} </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n#if(${table.convert})\n@Data\n@ApiModel(description = \"${table.comment}\")\n@TableName(\"${table.name}\")\n#end\n#if(${superEntityClass})\npublic class ${entity} extends ${superEntityClass}#if(${activeRecord})<${entity}>#end {\n#elseif(${activeRecord})\npublic class ${entity} extends Model<${entity}> {\n#else\npublic class ${entity} implements Serializable {\n#end\n\n    private static final long serialVersionUID = 1L;\n\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})\n#set($keyPropertyName=${field.propertyName})\n#end\n#if(\"$!field.comment\" != \"\")\n    /**\n     * ${field.comment}\n     */\n	@ApiModelProperty(value = \"${field.comment}\")\n#end\n#if(${field.keyFlag})\n	@TableId(value=\"${field.name}\", type= IdType.AUTO)\n#else\n	@TableField(\"${field.name}\")\n#end\n	private ${field.propertyType} ${field.propertyName};\n#end\n\n#if(${entityColumnConstant})\n#foreach($field in ${table.fields})\n	public static final String ${field.name.toUpperCase()} = \"${field.name}\";\n\n#end\n#end\n#if(${activeRecord})\n	@Override\n	protected Serializable pkVal() {\n#if(${keyPropertyName})\n		return this.${keyPropertyName};\n#else\n		return this.id;\n#end\n	}\n\n#end\n}\n', '2019-09-11 21:40:06', '2019-09-18 09:16:01');
INSERT INTO `t_code_project_template` VALUES ('20', '1', '7', '.xml', '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE mapper PUBLIC \"-//mybatis.org//DTD Mapper 3.0//EN\" \"http://mybatis.org/dtd/mybatis-3-mapper.dtd\">\n<mapper namespace=\"${package.mapper}.${tableInfo.mapper}\">\n\n#if(${enableCache})\n	<!-- 开启二级缓存 -->\n	<cache type=\"org.mybatis.caches.ehcache.LoggingEhcache\"/>\n\n#end\n#if(${baseResultMap})\n	<!-- 通用查询映射结果 -->\n	<resultMap id=\"BaseResultMap\" type=\"${package.entity}.${entity}\">\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})##生成主键排在第一位\n		<id column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n#foreach($field in ${table.fields})\n#if(!${field.keyFlag})##生成普通字段\n		<result column=\"${field.name}\" property=\"${field.propertyName}\" />\n#end\n#end\n	</resultMap>\n\n#end\n#if(${baseColumnList})\n    <!-- 通用查询结果列 -->\n    <sql id=\"Base_Column_List\">\n        ${table.fieldNames}\n    </sql>\n\n#end\n\n  <!--    <resultMap id=\"ResultMap\" type=\"com.zhengqing.modules.system.dto.output.RoleView\" extends=\"BaseResultMap\"></resultMap>-->\n\n    <select id=\"select${entity}s\" resultMap=\"BaseResultMap\">\n        SELECT\n             *\n        FROM ${table.name}\n        WHERE\n             1 = 1\n        <if test=\"filter.id!=null and filter.id!=\'\'\">\n            AND id = #{filter.id}\n        </if>\n        ORDER BY id DESC\n    </select>\n\n</mapper>\n', '2019-09-11 21:40:06', '2019-09-18 09:23:40');
INSERT INTO `t_code_project_template` VALUES ('21', '1', '6', '.java', 'package ${package.mapper};\n\nimport ${package.entity}.${entity};\nimport ${package.input}.${tableInfo.input};\nimport ${superMapperClassPackage};\nimport com.baomidou.mybatisplus.plugins.pagination.Pagination;\nimport org.apache.ibatis.annotations.Param;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} Mapper 接口 </p>\n *\n * @author : zhengqing\n * @date : ${date}\n */\npublic interface ${tableInfo.mapper} extends ${superMapperClass}<${entity}> {\n\n    /**\n     * 列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(Pagination page, @Param(\"filter\") ${tableInfo.input} filter);\n\n    /**\n     * 列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(@Param(\"filter\") ${tableInfo.input} filter);\n\n}', '2019-09-11 21:40:06', '2019-09-18 10:57:06');
INSERT INTO `t_code_project_template` VALUES ('22', '1', '4', '.java', 'package ${package.service};\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport ${superServiceClassPackage};\nimport ${package.entity}.${entity};\nimport ${package.input}.${tableInfo.input};\n\nimport java.util.List;\n\n/**\n * <p>  ${table.comment} 服务类 </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\npublic interface ${tableInfo.service} extends ${superServiceClass}<${entity}> {\n\n    /**\n     * ${table.comment}列表分页\n     *\n     * @param page\n     * @param para\n     * @return\n     */\n    void listPage(Page<${entity}> page, ${tableInfo.input} para);\n\n    /**\n     * 保存${table.comment}\n     *\n     * @param input\n     */\n    Integer save(${entity} input);\n\n    /**\n     * ${table.comment}列表\n     *\n     * @param para\n     * @return\n     */\n    List<${entity}> list(${tableInfo.input} para);\n\n}\n', '2019-09-11 21:40:06', '2019-09-18 09:39:08');
INSERT INTO `t_code_project_template` VALUES ('23', '1', '5', '.java', 'package ${service}.impl.${tableInfo.service}Impl;\n\nimport ${package.entity}.${entity};\nimport ${package.input}.${tableInfo.input};\nimport ${package.mapper}.${tableInfo.mapper};\nimport ${package.service}.${tableInfo.service};\nimport ${superServiceImplClassPackage};\nimport com.baomidou.mybatisplus.plugins.Page;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.stereotype.Service;\nimport org.springframework.transaction.annotation.Transactional;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} 服务实现类 </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n@Service\n@Transactional\npublic class ${tableInfo.service}Impl extends ${superServiceImplClass}<${tableInfo.mapper}, ${entity}> implements ${tableInfo.service} {\n\n    @Autowired\n    ${tableInfo.mapper} ${entityPropertyName}Mapper;\n\n    @Override\n    public void listPage(Page<${entity}> page, ${tableInfo.input} para) {\n        page.setRecords(${entityPropertyName}Mapper.select${entity}s(page, para));\n    }\n\n    @Override\n    public List<${entity}> list(${tableInfo.input} para) {\n        return ${entityPropertyName}Mapper.select${entity}s(para);\n    }\n\n    @Override\n    public Integer save(${entity} para) {\n        if (para.getId()!=null) {\n            ${entityPropertyName}Mapper.updateById(para);\n        } else {\n            ${entityPropertyName}Mapper.insert(para);\n        }\n        return para.getId();\n    }\n}\n', '2019-09-11 21:40:06', '2019-09-18 10:56:23');
INSERT INTO `t_code_project_template` VALUES ('24', '1', '18', '.java', 'package ${package.api};\n\nimport com.zhengqing.modules.common.api.BaseController;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.web.bind.annotation.*;\n\nimport java.util.List;\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport com.zhengqing.modules.common.dto.output.ApiResult;\nimport ${package.entity}.${entity};\nimport ${package.input}.${tableInfo.input};\nimport ${package.service}.${tableInfo.service};\nimport io.swagger.annotations.Api;\nimport io.swagger.annotations.ApiOperation;\n\n\n/**\n * <p> ${table.comment} 接口 </p>\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n *\n */\n@RestController\n@RequestMapping(\"/api#if(${package.moduleName})/${package.moduleName}#end/${table.entityPath}\")\n@Api(description = \"${table.comment}接口\")\npublic class ${tableInfo.api} extends BaseController {\n\n    @Autowired\n    ${tableInfo.service} ${entityPropertyName}Service;\n\n    @PostMapping(value = \"/listPage\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表分页\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult listPage(@RequestBody ${tableInfo.input} filter) {\n        Page<${entity}> page = new Page<>(filter.getPage(),filter.getLimit());\n        ${entityPropertyName}Service.listPage(page, filter);\n        return ApiResult.ok(\"获取${table.comment}列表分页成功\", page);\n    }\n\n    @PostMapping(value = \"/list\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult list(@RequestBody ${tableInfo.input} filter) {\n        List<${entity}> result = ${entityPropertyName}Service.list(filter);\n        return ApiResult.ok(\"获取${table.comment}列表成功\",result);\n    }\n\n    @PostMapping(value = \"/saveOrUpdate\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"保存或更新${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult saveOrUpdate(@RequestBody ${entity} input) {\n        Integer id = ${entityPropertyName}Service.save(input);\n        return ApiResult.ok(\"保存${table.comment}成功\", id);\n    }\n\n    @PostMapping(value = \"/delete\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"删除${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult delete(@RequestBody ${tableInfo.input} input) {\n        ${entityPropertyName}Service.deleteById(input.getId());\n        return ApiResult.ok(\"删除${table.comment}成功\");\n    }\n\n    @PostMapping(value = \"/detail\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"根据ID获取${table.comment}信息\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult detail(@RequestBody ${tableInfo.input} input) {\n        ${entity} entity = ${entityPropertyName}Service.selectById(input.getId());\n        return ApiResult.ok(\"根据ID获取${table.comment}信息成功\", entity);\n    }\n\n}', '2019-09-11 21:40:06', '2019-09-18 09:20:46');
INSERT INTO `t_code_project_template` VALUES ('25', '1', '22', '.java', 'package ${package.input};\n\nimport com.zhengqing.modules.common.dto.input.BasePageQuery;\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * ${table.comment}查询参数\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n */\n@Data\n@ApiModel(description = \"${table.comment}查询参数\")\npublic class ${tableInfo.input} extends BasePageQuery{\n    @ApiModelProperty(value = \"id\")\n    private Integer id;\n}\n', '2019-09-11 21:40:06', '2019-09-18 09:09:56');
INSERT INTO `t_code_project_template` VALUES ('26', '1', '20', '.vue', '<template>\n  <div class=\"app-container\">\n    <cus-wraper>\n      <cus-filter-wraper>\n        #if(${queryFields})\n        #foreach($field in ${queryFields})\n        <el-input v-model=\"listQuery.${field.propertyName}\" placeholder=\"请输入${field.comment}\" style=\"width:200px\" clearable></el-input>\n        #end\n        <el-button type=\"primary\" @click=\"getList\" icon=\"el-icon-search\" v-waves>查询</el-button>\n        <el-button type=\"primary\" @click=\"handleCreate\" icon=\"el-icon-plus\" v-waves>添加</el-button>        \n        #end\n      </cus-filter-wraper>\n      <div class=\"table-container\">\n        <el-table v-loading=\"listLoading\" :data=\"list\" size=\"mini\" element-loading-text=\"Loading\" fit border highlight-current-row>\n	        #foreach($field in ${table.fields})\n	        #if(${field.propertyType.equals(\"Date\")})\n	        <el-table-column label=\"${field.comment}\" align=\"center\">\n	            <template slot-scope=\"scope\">\n	                <span>{{scope.row.${field.propertyName}|dateTimeFilter}}</span>\n	            </template>\n	        </el-table-column>\n	        #else\n	        <el-table-column label=\"${field.comment}\" prop=\"${field.propertyName}\" align=\"center\"></el-table-column>\n	        #end\n	        #end\n          <el-table-column align=\"center\" label=\"操作\">\n            <template slot-scope=\"scope\">\n              <el-button size=\"mini\" type=\"primary\" @click=\"handleUpdate(scope.row)\" icon=\"el-icon-edit\" plain v-waves>编辑</el-button>\n              <cus-del-btn @ok=\"handleDelete(scope.row)\"></cus-del-btn>\n            </template>\n          </el-table-column>\n        </el-table>\n        <!-- 分页 -->\n        <cus-pagination v-show=\"total>0\" :total=\"total\" :page.sync=\"listQuery.page\" :limit.sync=\"listQuery.limit\" @pagination=\"getList\"/>\n      </div>\n\n      <el-dialog :title=\"titleMap[dialogStatus]\" :visible.sync=\"dialogVisible\" width=\"40%\" @close=\"handleDialogClose\">\n        <el-form ref=\"dataForm\" :model=\"form\" :rules=\"rules\" label-width=\"100px\" class=\"demo-ruleForm\">\n        #foreach($field in ${table.fields})\n        <el-form-item label=\"${field.comment}:\" prop=\"${field.propertyName}\">\n            <el-input v-model=\"form.${field.propertyName}\"></el-input>\n        </el-form-item>\n        #end\n        </el-form>\n        <span slot=\"footer\" class=\"dialog-footer\">\n          <el-button @click=\"dialogVisible = false\" v-waves>取 消</el-button>\n          <el-button type=\"primary\" @click=\"submitForm\" v-waves>确 定</el-button>\n        </span>\n      </el-dialog>\n    </cus-wraper>\n  </div>\n</template>\n\n<script>\n import { get${entity}Page, saveOrUpdate${entity}, delete${entity} } from \"@/api/${package.moduleName}/${entityPropertyName}\";\n\nexport default {\n  name: \'${entity}\',\n  data() {\n    return {\n      dialogVisible: false,\n      list: [],\n      listLoading: true,\n      total: 0,\n      listQuery: {\n        page: 1,\n        limit: 10,\n	    #if(${queryFields})\n	    #foreach($field in ${queryFields})\n	    ${field.propertyName}:undefined,\n	    #end\n	    #end\n      },\n      input: \'\',\n      form: {\n	     #foreach($field in ${table.fields})\n	     ${field.propertyName}: undefined, //${field.comment}\n	     #end\n      },\n     dialogStatus: \"\",\n     titleMap: {\n        update: \"编辑\",\n        create: \"创建\"\n     },\n     rules: {\n         name: [\n            { required: true, message: \'请输入项目名称\', trigger: \'blur\' }\n         ]\n      }\n    }\n  },\n  created() {\n    this.getList();\n  },\n  methods: {\n    getList() {\n      this.listLoading = true;\n      get${entity}Page(this.listQuery).then(response => {\n        this.list = response.data.records;\n    	this.total = response.data.total;\n    	this.listLoading = false;\n		});\n    },\n    handleCreate() {\n        this.resetForm();\n        this.dialogStatus = \"create\";\n        this.dialogVisible = true;\n    },\n    handleUpdate(row) {\n        this.form = Object.assign({}, row);\n        this.dialogStatus = \"update\";\n        this.dialogVisible = true;\n    },\n    handleDelete(row) {\n      #foreach($field in ${table.fields})\n		#if(${field.keyFlag})\n		 let id = row.${field.propertyName};\n		#end\n	  #end\n      delete${entity}(id).then(response => {\n            if (response.code == 200) {\n            this.getList();\n            this.submitOk(response.message);\n        } else {\n            this.submitFail(response.message);\n        }\n    });\n    },\n    submitForm() {\n    this.#[[$refs]]#.dataForm.validate(valid => {\n        if (valid) {\n            saveOrUpdate${entity}(this.form).then(response => {\n                if (response.code == 200) {\n                    this.getList();\n                    this.submitOk(response.message);\n                    this.dialogVisible = false;\n                } else {\n                     this.submitFail(response.message);\n                }\n        }).catch(err => { console.log(err);  });\n            }\n        });\n    },\n    resetForm() {\n        this.form = {\n            #foreach($field in ${table.fields})\n                ${field.propertyName}: undefined, //${field.comment}\n            #end\n        };\n    },\n    // 监听dialog关闭时的处理事件\n    handleDialogClose(){\n        if(this.$refs[\'dataForm\']){\n             this.$refs[\'dataForm\'].clearValidate(); // 清除整个表单的校验\n        }\n    }\n  }\n}\n</script>\n', '2019-09-11 21:40:06', '2019-09-18 09:32:20');
INSERT INTO `t_code_project_template` VALUES ('27', '1', '19', '.js', 'import request from \'@/utils/request\';\n\nexport function get${entity}Page(query) {\n    return request({\n        url: \'/api/${package.moduleName}/${entityPropertyName}/listPage\',\n        method: \'post\',\n        data: query\n    });\n}\n\nexport function saveOrUpdate${entity}(form) {\n    return request({\n        url: \'/api/${package.moduleName}/${entityPropertyName}/saveOrUpdate\',\n        method: \'post\',\n        data: form\n    });\n}\n\nexport function delete${entity}(id) {\n    return request({\n        url: \'/api/${package.moduleName}/${entityPropertyName}/delete\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}\n\nexport function get${entity}ById(id) {\n    return request({\n        url: \'/api/${package.moduleName}/${entityPropertyName}/detail\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}', '2019-09-11 21:40:06', '2019-09-14 22:20:44');
INSERT INTO `t_code_project_template` VALUES ('28', '1', '3', '.java', 'package ${package.Entity};\n\n#foreach($pkg in ${table.importPackages})\nimport ${pkg};\n#end\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * <p>  ${table.comment} </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n#if(${table.convert})\n@Data\n@ApiModel(description = \"${table.comment}\")\n@TableName(\"${table.name}\")\n#end\n#if(${superEntityClass})\npublic class ${entity} extends ${superEntityClass}#if(${activeRecord})<${entity}>#end {\n#elseif(${activeRecord})\npublic class ${entity} extends Model<${entity}> {\n#else\npublic class ${entity} implements Serializable {\n#end\n\n    private static final long serialVersionUID = 1L;\n\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})\n#set($keyPropertyName=${field.propertyName})\n#end\n#if(\"$!field.comment\" != \"\")\n    /**\n     * ${field.comment}\n     */\n	@ApiModelProperty(value = \"${field.comment}\")\n#end\n#if(${field.keyFlag})\n	@TableId(value=\"${field.name}\", type= IdType.AUTO)\n#else\n	@TableField(\"${field.name}\")\n#end\n	private ${field.propertyType} ${field.propertyName};\n#end\n\n#if(${entityColumnConstant})\n#foreach($field in ${table.fields})\n	public static final String ${field.name.toUpperCase()} = \"${field.name}\";\n\n#end\n#end\n#if(${activeRecord})\n	@Override\n	protected Serializable pkVal() {\n#if(${keyPropertyName})\n		return this.${keyPropertyName};\n#else\n		return this.id;\n#end\n	}\n\n#end\n}\n', '2020-02-21 16:34:42', '2020-02-21 16:34:42');
INSERT INTO `t_code_project_template` VALUES ('29', '1', '6', '.java', 'package ${package.Mapper};\n\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${superMapperClassPackage};\nimport com.baomidou.mybatisplus.plugins.pagination.Pagination;\nimport org.apache.ibatis.annotations.Param;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} Mapper 接口 </p>\n *\n * @author : zhengqing\n * @date : ${date}\n */\npublic interface ${table.mapperName} extends ${superMapperClass}<${entity}> {\n\n    /**\n     * 列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(Pagination page, @Param(\"filter\") ${formQueryPara} filter);\n\n    /**\n     * 列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(@Param(\"filter\") ${formQueryPara} filter);\n}', '2020-02-21 16:34:42', '2020-02-21 16:34:42');
INSERT INTO `t_code_project_template` VALUES ('30', '1', '18', '.java', 'package ${package.Controller};\n\nimport com.zhengqing.modules.common.api.BaseController;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.web.bind.annotation.*;\n\nimport java.util.List;\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport com.zhengqing.modules.common.dto.output.ApiResult;\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${package.Service}.${table.serviceName};\nimport io.swagger.annotations.Api;\nimport io.swagger.annotations.ApiOperation;\n\n\n/**\n * <p> ${table.comment} 接口 </p>\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n *\n */\n@RestController\n@RequestMapping(\"/api#if(${package.ModuleName})/${package.ModuleName}#end/${table.entityPath}\")\n@Api(description = \"${table.comment}接口\")\npublic class ${table.controllerName} extends BaseController {\n\n    @Autowired\n    ${table.serviceName} ${entityPropertyName}Service;\n\n    @PostMapping(value = \"/listPage\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表分页\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult listPage(@RequestBody ${formQueryPara} filter) {\n        Page<${entity}> page = new Page<>(filter.getPage(),filter.getLimit());\n        ${entityPropertyName}Service.listPage(page, filter);\n        return ApiResult.ok(\"获取${table.comment}列表分页成功\", page);\n    }\n\n    @PostMapping(value = \"/list\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult list(@RequestBody ${formQueryPara} filter) {\n        List<${entity}> result = ${entityPropertyName}Service.list(filter);\n        return ApiResult.ok(\"获取${table.comment}列表成功\",result);\n    }\n\n    @PostMapping(value = \"/save\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"保存${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult save(@RequestBody ${entity} input) {\n        Integer id = ${entityPropertyName}Service.save(input);\n        return ApiResult.ok(\"保存${table.comment}成功\", id);\n    }\n\n    @PostMapping(value = \"/delete\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"删除${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult delete(@RequestBody ${formQueryPara} input) {\n        ${entityPropertyName}Service.deleteById(input.getId());\n        return ApiResult.ok(\"删除${table.comment}成功\");\n    }\n\n    @PostMapping(value = \"/getById\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}信息\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult getById(@RequestBody ${formQueryPara} input) {\n        ${entity} entity = ${entityPropertyName}Service.selectById(input.getId());\n        return ApiResult.ok(\"获取${table.comment}信息成功\", entity);\n    }\n\n}', '2020-02-21 16:34:42', '2020-02-21 16:34:42');
INSERT INTO `t_code_project_template` VALUES ('31', '1', '22', '.java', 'package ${package.QueryPara};\n\nimport com.zhengqing.modules.common.dto.input.BasePageQuery;\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * ${table.comment}查询参数\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n */\n@Data\n@ApiModel(description = \"${table.comment}查询参数\")\npublic class ${formQueryPara} extends BasePageQuery{\n    @ApiModelProperty(value = \"id\")\n    private int id;\n}\n', '2020-02-21 16:34:42', '2020-02-21 16:34:42');
INSERT INTO `t_code_project_template` VALUES ('32', '1', '20', '.vue', '<template>\n  <div class=\"app-container\">\n    <cus-wraper>\n      <cus-filter-wraper>\n        #if(${queryFields})\n        #foreach($field in ${queryFields})\n        <el-input v-model=\"listQuery.${field.propertyName}\" placeholder=\"请输入${field.comment}\" style=\"width:200px\" clearable></el-input>\n        #end\n        <el-button type=\"primary\" @click=\"getList\" icon=\"el-icon-search\" v-waves>查询</el-button>\n        <el-button type=\"primary\" @click=\"handleCreate\" icon=\"el-icon-plus\" v-waves>添加</el-button>        \n        #end\n      </cus-filter-wraper>\n      <div class=\"table-container\">\n        <el-table v-loading=\"listLoading\" :data=\"list\" size=\"mini\" element-loading-text=\"Loading\" fit border highlight-current-row>\n	        #foreach($field in ${table.fields})\n	        #if(${field.propertyType.equals(\"Date\")})\n	        <el-table-column label=\"${field.comment}\" align=\"center\">\n	            <template slot-scope=\"scope\">\n	                <span>{{scope.row.${field.propertyName}|dateTimeFilter}}</span>\n	            </template>\n	        </el-table-column>\n	        #else\n	        <el-table-column label=\"${field.comment}\" prop=\"${field.propertyName}\" align=\"center\"></el-table-column>\n	        #end\n	        #end\n          <el-table-column align=\"center\" label=\"操作\">\n            <template slot-scope=\"scope\">\n              <el-button size=\"mini\" type=\"primary\" @click=\"handleUpdate(scope.row)\" icon=\"el-icon-edit\" plain v-waves>编辑</el-button>\n              <cus-del-btn @ok=\"handleDelete(scope.row)\"></cus-del-btn>\n            </template>\n          </el-table-column>\n        </el-table>\n        <!-- 分页 -->\n        <cus-pagination v-show=\"total>0\" :total=\"total\" :page.sync=\"listQuery.page\" :limit.sync=\"listQuery.limit\" @pagination=\"getList\"/>\n      </div>\n\n      <el-dialog :title=\"titleMap[dialogStatus]\" :visible.sync=\"dialogVisible\" width=\"40%\" @close=\"handleDialogClose\">\n        <el-form ref=\"dataForm\" :model=\"form\" :rules=\"rules\" label-width=\"100px\" class=\"demo-ruleForm\">\n        #foreach($field in ${table.fields})\n        <el-form-item label=\"${field.comment}:\" prop=\"${field.propertyName}\">\n            <el-input v-model=\"form.${field.propertyName}\"></el-input>\n        </el-form-item>\n        #end\n        </el-form>\n        <span slot=\"footer\" class=\"dialog-footer\">\n          <el-button @click=\"dialogVisible = false\" v-waves>取 消</el-button>\n          <el-button type=\"primary\" @click=\"submitForm\" v-waves>确 定</el-button>\n        </span>\n      </el-dialog>\n    </cus-wraper>\n  </div>\n</template>\n\n<script>\n import { get${entity}Page, save${entity}, delete${entity} } from \"@/api/${package.ModuleName}/${entityPropertyName}\";\n\nexport default {\n  data() {\n    return {\n      dialogVisible: false,\n      list: [],\n      listLoading: true,\n      total: 0,\n      listQuery: {\n        page: 1,\n        limit: 10,\n	    #if(${queryFields})\n	    #foreach($field in ${queryFields})\n	    ${field.propertyName}:undefined,\n	    #end\n	    #end\n      },\n      input: \'\',\n      form: {\n	     #foreach($field in ${table.fields})\n	     ${field.propertyName}: undefined, //${field.comment}\n	     #end\n      },\n     dialogStatus: \"\",\n     titleMap: {\n        update: \"编辑\",\n        create: \"创建\"\n     },\n     rules: {\n         name: [\n            { required: true, message: \'请输入项目名称\', trigger: \'blur\' }\n         ]\n      }\n    }\n  },\n  created() {\n    this.getList();\n  },\n  methods: {\n    getList() {\n      this.listLoading = true;\n      get${entity}Page(this.listQuery).then(response => {\n        this.list = response.data.records;\n    	this.total = response.data.total;\n    	this.listLoading = false;\n		});\n    },\n    handleCreate() {\n        this.resetForm();\n        this.dialogStatus = \"create\";\n        this.dialogVisible = true;\n    },\n    handleUpdate(row) {\n        this.form = Object.assign({}, row);\n        this.dialogStatus = \"update\";\n        this.dialogVisible = true;\n    },\n    handleDelete(row) {\n      #foreach($field in ${table.fields})\n		#if(${field.keyFlag})\n		 let id = row.${field.propertyName};\n		#end\n	  #end\n      delete${entity}(id).then(response => {\n            if (response.code == 200) {\n            this.getList();\n            this.submitOk(response.message);\n        } else {\n            this.submitFail(response.message);\n        }\n    });\n    },\n    submitForm() {\n    this.#[[$refs]]#.[\'dataForm\'].validate(valid => {\n        if (valid) {\n            save${entity}(this.form).then(response => {\n                if (response.code == 200) {\n                    this.getList();\n                    this.submitOk(response.message);\n                    this.dialogVisible = false;\n                } else {\n                     this.submitFail(response.message);\n                }\n        }).catch(err => { console.log(err);  });\n            }\n        });\n    },\n    resetForm() {\n        this.form = {\n            #foreach($field in ${table.fields})\n                ${field.propertyName}: undefined, //${field.comment}\n            #end\n        };\n    },\n    // 监听dialog关闭时的处理事件\n    handleDialogClose(){\n        if(this.$refs[\'dataForm\']){\n             this.$refs[\'dataForm\'].clearValidate(); // 清除整个表单的校验\n        }\n    }\n  }\n}\n</script>', '2020-02-21 16:34:42', '2020-02-21 16:34:42');
INSERT INTO `t_code_project_template` VALUES ('33', '1', '19', '.js', 'import request from \'@/utils/request\';\n\nexport function get${entity}Page(query) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/listPage\',\n        method: \'post\',\n        data: query\n    });\n}\n\nexport function save${entity}(form) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/save\',\n        method: \'post\',\n        data: form\n    });\n}\n\nexport function delete${entity}(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/delete\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}\n\nexport function get${entity}ById(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/getById\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}', '2020-02-21 16:34:42', '2020-02-21 16:34:42');
INSERT INTO `t_code_project_template` VALUES ('34', '1', '3', '.java', 'package ${package.Entity};\n\n#foreach($pkg in ${table.importPackages})\nimport ${pkg};\n#end\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * <p>  ${table.comment} </p>\n *\n * @author: ${author}\n * @date: ${date}\n */\n#if(${table.convert})\n@Data\n@ApiModel(description = \"${table.comment}\")\n@TableName(\"${table.name}\")\n#end\n#if(${superEntityClass})\npublic class ${entity} extends ${superEntityClass}#if(${activeRecord})<${entity}>#end {\n#elseif(${activeRecord})\npublic class ${entity} extends Model<${entity}> {\n#else\npublic class ${entity} implements Serializable {\n#end\n\n    private static final long serialVersionUID = 1L;\n\n#foreach($field in ${table.fields})\n#if(${field.keyFlag})\n#set($keyPropertyName=${field.propertyName})\n#end\n#if(\"$!field.comment\" != \"\")\n    /**\n     * ${field.comment}\n     */\n	@ApiModelProperty(value = \"${field.comment}\")\n#end\n#if(${field.keyFlag})\n	@TableId(value=\"${field.name}\", type= IdType.AUTO)\n#else\n	@TableField(\"${field.name}\")\n#end\n	private ${field.propertyType} ${field.propertyName};\n#end\n\n#if(${entityColumnConstant})\n#foreach($field in ${table.fields})\n	public static final String ${field.name.toUpperCase()} = \"${field.name}\";\n\n#end\n#end\n#if(${activeRecord})\n	@Override\n	protected Serializable pkVal() {\n#if(${keyPropertyName})\n		return this.${keyPropertyName};\n#else\n		return this.id;\n#end\n	}\n\n#end\n}\n', '2020-02-21 18:12:42', '2020-02-21 18:12:42');
INSERT INTO `t_code_project_template` VALUES ('35', '1', '6', '.java', 'package ${package.Mapper};\n\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${superMapperClassPackage};\nimport com.baomidou.mybatisplus.plugins.pagination.Pagination;\nimport org.apache.ibatis.annotations.Param;\n\nimport java.util.List;\n\n/**\n * <p> ${table.comment} Mapper 接口 </p>\n *\n * @author : zhengqing\n * @date : ${date}\n */\npublic interface ${table.mapperName} extends ${superMapperClass}<${entity}> {\n\n    /**\n     * 列表分页\n     *\n     * @param page\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(Pagination page, @Param(\"filter\") ${formQueryPara} filter);\n\n    /**\n     * 列表\n     *\n     * @param filter\n     * @return\n     */\n    List<${entity}> select${entity}s(@Param(\"filter\") ${formQueryPara} filter);\n}', '2020-02-21 18:12:42', '2020-02-21 18:12:42');
INSERT INTO `t_code_project_template` VALUES ('36', '1', '18', '.java', 'package ${package.Controller};\n\nimport com.zhengqing.modules.common.api.BaseController;\nimport org.springframework.beans.factory.annotation.Autowired;\nimport org.springframework.web.bind.annotation.*;\n\nimport java.util.List;\n\nimport com.baomidou.mybatisplus.plugins.Page;\nimport com.zhengqing.modules.common.dto.output.ApiResult;\nimport ${package.Entity}.${entity};\nimport ${package.QueryPara}.${formQueryPara};\nimport ${package.Service}.${table.serviceName};\nimport io.swagger.annotations.Api;\nimport io.swagger.annotations.ApiOperation;\n\n\n/**\n * <p> ${table.comment} 接口 </p>\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n *\n */\n@RestController\n@RequestMapping(\"/api#if(${package.ModuleName})/${package.ModuleName}#end/${table.entityPath}\")\n@Api(description = \"${table.comment}接口\")\npublic class ${table.controllerName} extends BaseController {\n\n    @Autowired\n    ${table.serviceName} ${entityPropertyName}Service;\n\n    @PostMapping(value = \"/listPage\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表分页\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult listPage(@RequestBody ${formQueryPara} filter) {\n        Page<${entity}> page = new Page<>(filter.getPage(),filter.getLimit());\n        ${entityPropertyName}Service.listPage(page, filter);\n        return ApiResult.ok(\"获取${table.comment}列表分页成功\", page);\n    }\n\n    @PostMapping(value = \"/list\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}列表\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult list(@RequestBody ${formQueryPara} filter) {\n        List<${entity}> result = ${entityPropertyName}Service.list(filter);\n        return ApiResult.ok(\"获取${table.comment}列表成功\",result);\n    }\n\n    @PostMapping(value = \"/save\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"保存${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult save(@RequestBody ${entity} input) {\n        Integer id = ${entityPropertyName}Service.save(input);\n        return ApiResult.ok(\"保存${table.comment}成功\", id);\n    }\n\n    @PostMapping(value = \"/delete\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"删除${table.comment}\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult delete(@RequestBody ${formQueryPara} input) {\n        ${entityPropertyName}Service.deleteById(input.getId());\n        return ApiResult.ok(\"删除${table.comment}成功\");\n    }\n\n    @PostMapping(value = \"/getById\", produces = \"application/json;charset=utf-8\")\n    @ApiOperation(value = \"获取${table.comment}信息\", httpMethod = \"POST\", response = ApiResult.class)\n    public ApiResult getById(@RequestBody ${formQueryPara} input) {\n        ${entity} entity = ${entityPropertyName}Service.selectById(input.getId());\n        return ApiResult.ok(\"获取${table.comment}信息成功\", entity);\n    }\n\n}', '2020-02-21 18:12:42', '2020-02-21 18:12:42');
INSERT INTO `t_code_project_template` VALUES ('37', '1', '22', '.java', 'package ${package.QueryPara};\n\nimport com.zhengqing.modules.common.dto.input.BasePageQuery;\nimport io.swagger.annotations.ApiModel;\nimport io.swagger.annotations.ApiModelProperty;\nimport lombok.Data;\n\n/**\n * ${table.comment}查询参数\n *\n * @author: zhengqing\n * @description:\n * @date: ${date}\n */\n@Data\n@ApiModel(description = \"${table.comment}查询参数\")\npublic class ${formQueryPara} extends BasePageQuery{\n    @ApiModelProperty(value = \"id\")\n    private int id;\n}\n', '2020-02-21 18:12:42', '2020-02-21 18:12:42');
INSERT INTO `t_code_project_template` VALUES ('38', '1', '20', '.vue', '<template>\n  <div class=\"app-container\">\n    <cus-wraper>\n      <cus-filter-wraper>\n        #if(${queryFields})\n        #foreach($field in ${queryFields})\n        <el-input v-model=\"listQuery.${field.propertyName}\" placeholder=\"请输入${field.comment}\" style=\"width:200px\" clearable></el-input>\n        #end\n        <el-button type=\"primary\" @click=\"getList\" icon=\"el-icon-search\" v-waves>查询</el-button>\n        <el-button type=\"primary\" @click=\"handleCreate\" icon=\"el-icon-plus\" v-waves>添加</el-button>        \n        #end\n      </cus-filter-wraper>\n      <div class=\"table-container\">\n        <el-table v-loading=\"listLoading\" :data=\"list\" size=\"mini\" element-loading-text=\"Loading\" fit border highlight-current-row>\n	        #foreach($field in ${table.fields})\n	        #if(${field.propertyType.equals(\"Date\")})\n	        <el-table-column label=\"${field.comment}\" align=\"center\">\n	            <template slot-scope=\"scope\">\n	                <span>{{scope.row.${field.propertyName}|dateTimeFilter}}</span>\n	            </template>\n	        </el-table-column>\n	        #else\n	        <el-table-column label=\"${field.comment}\" prop=\"${field.propertyName}\" align=\"center\"></el-table-column>\n	        #end\n	        #end\n          <el-table-column align=\"center\" label=\"操作\">\n            <template slot-scope=\"scope\">\n              <el-button size=\"mini\" type=\"primary\" @click=\"handleUpdate(scope.row)\" icon=\"el-icon-edit\" plain v-waves>编辑</el-button>\n              <cus-del-btn @ok=\"handleDelete(scope.row)\"></cus-del-btn>\n            </template>\n          </el-table-column>\n        </el-table>\n        <!-- 分页 -->\n        <cus-pagination v-show=\"total>0\" :total=\"total\" :page.sync=\"listQuery.page\" :limit.sync=\"listQuery.limit\" @pagination=\"getList\"/>\n      </div>\n\n      <el-dialog :title=\"titleMap[dialogStatus]\" :visible.sync=\"dialogVisible\" width=\"40%\" @close=\"handleDialogClose\">\n        <el-form ref=\"dataForm\" :model=\"form\" :rules=\"rules\" label-width=\"100px\" class=\"demo-ruleForm\">\n        #foreach($field in ${table.fields})\n        <el-form-item label=\"${field.comment}:\" prop=\"${field.propertyName}\">\n            <el-input v-model=\"form.${field.propertyName}\"></el-input>\n        </el-form-item>\n        #end\n        </el-form>\n        <span slot=\"footer\" class=\"dialog-footer\">\n          <el-button @click=\"dialogVisible = false\" v-waves>取 消</el-button>\n          <el-button type=\"primary\" @click=\"submitForm\" v-waves>确 定</el-button>\n        </span>\n      </el-dialog>\n    </cus-wraper>\n  </div>\n</template>\n\n<script>\n import { get${entity}Page, save${entity}, delete${entity} } from \"@/api/${package.ModuleName}/${entityPropertyName}\";\n\nexport default {\n  data() {\n    return {\n      dialogVisible: false,\n      list: [],\n      listLoading: true,\n      total: 0,\n      listQuery: {\n        page: 1,\n        limit: 10,\n	    #if(${queryFields})\n	    #foreach($field in ${queryFields})\n	    ${field.propertyName}:undefined,\n	    #end\n	    #end\n      },\n      input: \'\',\n      form: {\n	     #foreach($field in ${table.fields})\n	     ${field.propertyName}: undefined, //${field.comment}\n	     #end\n      },\n     dialogStatus: \"\",\n     titleMap: {\n        update: \"编辑\",\n        create: \"创建\"\n     },\n     rules: {\n         name: [\n            { required: true, message: \'请输入项目名称\', trigger: \'blur\' }\n         ]\n      }\n    }\n  },\n  created() {\n    this.getList();\n  },\n  methods: {\n    getList() {\n      this.listLoading = true;\n      get${entity}Page(this.listQuery).then(response => {\n        this.list = response.data.records;\n    	this.total = response.data.total;\n    	this.listLoading = false;\n		});\n    },\n    handleCreate() {\n        this.resetForm();\n        this.dialogStatus = \"create\";\n        this.dialogVisible = true;\n    },\n    handleUpdate(row) {\n        this.form = Object.assign({}, row);\n        this.dialogStatus = \"update\";\n        this.dialogVisible = true;\n    },\n    handleDelete(row) {\n      #foreach($field in ${table.fields})\n		#if(${field.keyFlag})\n		 let id = row.${field.propertyName};\n		#end\n	  #end\n      delete${entity}(id).then(response => {\n            if (response.code == 200) {\n            this.getList();\n            this.submitOk(response.message);\n        } else {\n            this.submitFail(response.message);\n        }\n    });\n    },\n    submitForm() {\n    this.#[[$refs]]#.[\'dataForm\'].validate(valid => {\n        if (valid) {\n            save${entity}(this.form).then(response => {\n                if (response.code == 200) {\n                    this.getList();\n                    this.submitOk(response.message);\n                    this.dialogVisible = false;\n                } else {\n                     this.submitFail(response.message);\n                }\n        }).catch(err => { console.log(err);  });\n            }\n        });\n    },\n    resetForm() {\n        this.form = {\n            #foreach($field in ${table.fields})\n                ${field.propertyName}: undefined, //${field.comment}\n            #end\n        };\n    },\n    // 监听dialog关闭时的处理事件\n    handleDialogClose(){\n        if(this.$refs[\'dataForm\']){\n             this.$refs[\'dataForm\'].clearValidate(); // 清除整个表单的校验\n        }\n    }\n  }\n}\n</script>', '2020-02-21 18:12:42', '2020-02-21 18:12:42');
INSERT INTO `t_code_project_template` VALUES ('39', '1', '19', '.js', 'import request from \'@/utils/request\';\n\nexport function get${entity}Page(query) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/listPage\',\n        method: \'post\',\n        data: query\n    });\n}\n\nexport function save${entity}(form) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/save\',\n        method: \'post\',\n        data: form\n    });\n}\n\nexport function delete${entity}(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/delete\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}\n\nexport function get${entity}ById(id) {\n    return request({\n        url: \'/api/${package.ModuleName}/${entityPropertyName}/getById\',\n        method: \'post\',\n        data: { \'id\': id }\n    });\n}', '2020-02-21 18:12:42', '2020-02-21 18:12:42');

-- ----------------------------
-- Table structure for t_code_project_velocity_context
-- ----------------------------
DROP TABLE IF EXISTS `t_code_project_velocity_context`;
CREATE TABLE `t_code_project_velocity_context` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `velocity` varchar(100) DEFAULT NULL COMMENT '模板数据',
  `context` text COMMENT '内容',
  `project_id` int(11) DEFAULT NULL COMMENT '所属项目',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=279 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='代码生成器 - 项目 - 模板数据源';

-- ----------------------------
-- Records of t_code_project_velocity_context
-- ----------------------------
INSERT INTO `t_code_project_velocity_context` VALUES ('247', 'date', '\"2019-09-18 10:51:57\"', '1', '2019-09-18 10:51:58', '2019-09-18 10:51:58');
INSERT INTO `t_code_project_velocity_context` VALUES ('248', 'superControllerClassPackage', 'null', '1', '2019-09-18 10:51:58', '2019-09-18 10:51:58');
INSERT INTO `t_code_project_velocity_context` VALUES ('249', 'superServiceImplClassPackage', '\"com.baomidou.mybatisplus.service.impl.ServiceImpl\"', '1', '2019-09-18 10:51:58', '2019-09-18 10:51:58');
INSERT INTO `t_code_project_velocity_context` VALUES ('250', 'baseResultMap', 'true', '1', '2019-09-18 10:51:58', '2019-09-18 10:51:58');
INSERT INTO `t_code_project_velocity_context` VALUES ('251', 'vue', '\"com.zhengqing.modules.system.vue\"', '1', '2019-09-18 10:51:58', '2019-09-18 10:51:58');
INSERT INTO `t_code_project_velocity_context` VALUES ('252', 'service.impl', '\"com.zhengqing.modules.system.service.impl\"', '1', '2019-09-18 10:51:58', '2019-09-18 10:51:58');
INSERT INTO `t_code_project_velocity_context` VALUES ('253', 'moduleName', '\"system\"', '1', '2019-09-18 10:51:58', '2019-09-18 10:51:58');
INSERT INTO `t_code_project_velocity_context` VALUES ('254', 'js', '\"com.zhengqing.modules.system.js\"', '1', '2019-09-18 10:51:58', '2019-09-18 10:51:58');
INSERT INTO `t_code_project_velocity_context` VALUES ('255', 'mapper', '\"com.zhengqing.modules.system.mapper\"', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('256', 'superMapperClass', '\"BaseMapper\"', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('257', 'mapper.xml', '\"com.zhengqing.modules.system.mapper.xml\"', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('258', 'superControllerClass', 'null', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('259', 'entityPropertyName', '\"log\"', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('260', 'activeRecord', 'true', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('261', 'superServiceClass', '\"IService\"', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('262', 'api', '\"com.zhengqing.modules.system.api\"', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('263', 'superServiceImplClass', '\"ServiceImpl\"', '1', '2019-09-18 10:51:59', '2019-09-18 10:51:59');
INSERT INTO `t_code_project_velocity_context` VALUES ('264', 'table', '{\"comment\":\"系统管理 - 日志表\",\"commonFields\":[],\"convert\":true,\"entityName\":\"Log\",\"entityPath\":\"log\",\"fieldNames\":\"id AS id, name AS name, url AS url, ip AS ip, user_id AS userId, status AS status, execute_time AS executeTime, gmt_create AS gmtCreate, gmt_modified AS gmtModified\",\"fields\":[{\"capitalName\":\"Id\",\"columnType\":\"INTEGER\",\"comment\":\"主键ID\",\"convert\":true,\"keyFlag\":true,\"keyIdentityFlag\":true,\"name\":\"id\",\"propertyName\":\"id\",\"propertyType\":\"Integer\",\"type\":\"int(11)\"},{\"capitalName\":\"Name\",\"columnType\":\"STRING\",\"comment\":\"接口名称\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"name\",\"propertyName\":\"name\",\"propertyType\":\"String\",\"type\":\"varchar(100)\"},{\"capitalName\":\"Url\",\"columnType\":\"STRING\",\"comment\":\"接口地址\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"url\",\"propertyName\":\"url\",\"propertyType\":\"String\",\"type\":\"varchar(255)\"},{\"capitalName\":\"Ip\",\"columnType\":\"STRING\",\"comment\":\"访问人IP\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"ip\",\"propertyName\":\"ip\",\"propertyType\":\"String\",\"type\":\"varchar(30)\"},{\"capitalName\":\"UserId\",\"columnType\":\"INTEGER\",\"comment\":\"访问人ID\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"user_id\",\"propertyName\":\"userId\",\"propertyType\":\"Integer\",\"type\":\"int(11)\"},{\"capitalName\":\"Status\",\"columnType\":\"INTEGER\",\"comment\":\"1 成功 0失败\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"status\",\"propertyName\":\"status\",\"propertyType\":\"Integer\",\"type\":\"int(2)\"},{\"capitalName\":\"ExecuteTime\",\"columnType\":\"STRING\",\"comment\":\"接口执行时间\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"execute_time\",\"propertyName\":\"executeTime\",\"propertyType\":\"String\",\"type\":\"varchar(20)\"},{\"capitalName\":\"GmtCreate\",\"columnType\":\"DATE\",\"comment\":\"创建时间\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"gmt_create\",\"propertyName\":\"gmtCreate\",\"propertyType\":\"Date\",\"type\":\"datetime\"},{\"capitalName\":\"GmtModified\",\"columnType\":\"DATE\",\"comment\":\"更新时间\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"gmt_modified\",\"propertyName\":\"gmtModified\",\"propertyType\":\"Date\",\"type\":\"datetime\"}],\"importPackages\":[\"com.baomidou.mybatisplus.enums.IdType\",\"java.util.Date\",\"com.baomidou.mybatisplus.annotations.TableId\",\"com.baomidou.mybatisplus.annotations.TableField\",\"com.baomidou.mybatisplus.enums.IdType\",\"com.baomidou.mybatisplus.activerecord.Model\",\"com.baomidou.mybatisplus.annotations.TableName\",\"java.io.Serializable\"],\"name\":\"t_log\",\"packageInfo\":{\"input\":\"LogInput\",\"service\":\"LogService\",\"vue\":\"LogVue\",\"service.impl\":\"LogServiceImpl\",\"js\":\"LogJs\",\"mapper\":\"LogMapper\",\"api\":\"LogApi\",\"mapper.xml\":\"LogMapperXml\",\"entity\":\"LogEntity\"}}', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('265', 'package', '{\"input\":\"com.zhengqing.modules.system.dto.input\",\"service\":\"com.zhengqing.modules.system.service\",\"vue\":\"com.zhengqing.modules.system.vue\",\"service.impl\":\"com.zhengqing.modules.system.service.impl\",\"moduleName\":\"system\",\"js\":\"com.zhengqing.modules.system.js\",\"mapper\":\"com.zhengqing.modules.system.mapper\",\"api\":\"com.zhengqing.modules.system.api\",\"mapper.xml\":\"com.zhengqing.modules.system.mapper.xml\",\"entity\":\"com.zhengqing.modules.system.entity\"}', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('266', 'queryFields', '[{\"capitalName\":\"GmtCreate\",\"columnType\":\"DATE\",\"comment\":\"创建时间\",\"convert\":true,\"keyFlag\":false,\"keyIdentityFlag\":false,\"name\":\"gmt_create\",\"propertyName\":\"gmtCreate\",\"propertyType\":\"Date\",\"type\":\"datetime\"}]', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('267', 'author', '\"zhengqing\"', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('268', 'baseColumnList', 'false', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('269', 'tableInfo', '{\"input\":\"LogInput\",\"service\":\"LogService\",\"vue\":\"LogVue\",\"service.impl\":\"LogServiceImpl\",\"js\":\"LogJs\",\"mapper\":\"LogMapper\",\"api\":\"LogApi\",\"mapper.xml\":\"LogMapperXml\",\"entity\":\"LogEntity\"}', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('270', 'superMapperClassPackage', '\"com.baomidou.mybatisplus.mapper.BaseMapper\"', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('271', 'input', '\"com.zhengqing.modules.system.dto.input\"', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('272', 'entityBuilderModel', 'false', '1', '2019-09-18 10:52:00', '2019-09-18 10:52:00');
INSERT INTO `t_code_project_velocity_context` VALUES ('273', 'superServiceClassPackage', '\"com.baomidou.mybatisplus.service.IService\"', '1', '2019-09-18 10:52:01', '2019-09-18 10:52:01');
INSERT INTO `t_code_project_velocity_context` VALUES ('274', 'service', '\"com.zhengqing.modules.system.service\"', '1', '2019-09-18 10:52:01', '2019-09-18 10:52:01');
INSERT INTO `t_code_project_velocity_context` VALUES ('275', 'entityColumnConstant', 'false', '1', '2019-09-18 10:52:01', '2019-09-18 10:52:01');
INSERT INTO `t_code_project_velocity_context` VALUES ('276', 'enableCache', 'false', '1', '2019-09-18 10:52:01', '2019-09-18 10:52:01');
INSERT INTO `t_code_project_velocity_context` VALUES ('277', 'entity', '\"Log\"', '1', '2019-09-18 10:52:01', '2019-09-18 10:52:01');
INSERT INTO `t_code_project_velocity_context` VALUES ('278', 'superEntityClass', 'null', '1', '2019-09-18 10:52:01', '2019-09-18 10:52:01');

-- ----------------------------
-- Table structure for t_code_table_config
-- ----------------------------
DROP TABLE IF EXISTS `t_code_table_config`;
CREATE TABLE `t_code_table_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` int(11) DEFAULT NULL COMMENT '项目ID',
  `table_name` varchar(255) DEFAULT NULL COMMENT '表名',
  `query_columns` varchar(1024) DEFAULT NULL COMMENT '用于检索字段',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='项目数据表配置表';

-- ----------------------------
-- Records of t_code_table_config
-- ----------------------------

-- ----------------------------
-- Table structure for t_sys_log
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_log`;
CREATE TABLE `t_sys_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) DEFAULT NULL COMMENT '接口名称',
  `url` varchar(255) DEFAULT NULL COMMENT '接口地址',
  `ip` varchar(30) DEFAULT NULL COMMENT '访问人IP',
  `user_id` int(11) DEFAULT '0' COMMENT '访问人ID 0:未登录用户操作',
  `status` int(2) DEFAULT '1' COMMENT '访问状态',
  `execute_time` varchar(10) DEFAULT NULL COMMENT '接口执行时间',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=648 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='系统管理 - 日志表';

-- ----------------------------
-- Records of t_sys_log
-- ----------------------------
INSERT INTO `t_sys_log` VALUES ('1', '未登录', 'http://127.0.0.1:9100/api/auth/unLogin', '127.0.0.1', '0', '401', '2 ms', '2020-02-21 10:18:30', '2020-02-21 10:18:30');
INSERT INTO `t_sys_log` VALUES ('2', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_b689a4cb-bdd3-4d0d-8317-04ffc430a0bb', '0:0:0:0:0:0:0:1', '0', '401', '3 ms', '2020-02-21 10:23:53', '2020-02-21 10:23:53');
INSERT INTO `t_sys_log` VALUES ('3', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_530a254d-f9e3-402f-8780-98340aeeeda8', '0:0:0:0:0:0:0:1', '0', '401', '3 ms', '2020-02-21 10:23:53', '2020-02-21 10:23:53');
INSERT INTO `t_sys_log` VALUES ('4', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_e112d698-7990-425a-bdb1-60edbdc388a7', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 10:23:55', '2020-02-21 10:23:55');
INSERT INTO `t_sys_log` VALUES ('5', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_e9d45d3f-830f-4015-9ef5-fa44d5fa90d1', '0:0:0:0:0:0:0:1', '0', '401', '4 ms', '2020-02-21 14:05:12', '2020-02-21 14:05:12');
INSERT INTO `t_sys_log` VALUES ('6', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_0abeadb9-b6e5-4b19-9985-8d25039361da', '0:0:0:0:0:0:0:1', '0', '401', '4 ms', '2020-02-21 14:05:12', '2020-02-21 14:05:12');
INSERT INTO `t_sys_log` VALUES ('7', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_bb6953cf-7787-43cf-a738-f88c3076766b', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:05:14', '2020-02-21 14:05:14');
INSERT INTO `t_sys_log` VALUES ('8', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_1c055418-84f1-4075-9e8f-a66d35456068', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:05:14', '2020-02-21 14:05:14');
INSERT INTO `t_sys_log` VALUES ('9', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_f8bcbc2b-50f6-4970-942b-0f47fcb4d6c4', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:05:14', '2020-02-21 14:05:14');
INSERT INTO `t_sys_log` VALUES ('10', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_fd8c9b00-ccaa-4a77-b858-248d5c835218', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:05:16', '2020-02-21 14:05:16');
INSERT INTO `t_sys_log` VALUES ('11', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_63f2ae3f-b539-44ff-8953-b881e41e837b', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:05:28', '2020-02-21 14:05:28');
INSERT INTO `t_sys_log` VALUES ('12', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_eb94b9c8-4fe3-43df-9d8a-d0e1572d2adb', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:05:31', '2020-02-21 14:05:31');
INSERT INTO `t_sys_log` VALUES ('13', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_843df0fd-3904-4f2c-85ab-6cf09745e9a6', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:05:31', '2020-02-21 14:05:31');
INSERT INTO `t_sys_log` VALUES ('14', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_7d0ef1c6-ba11-46ba-8adf-1302268f1e1f', '0:0:0:0:0:0:0:1', '0', '401', '1 ms', '2020-02-21 14:05:31', '2020-02-21 14:05:31');
INSERT INTO `t_sys_log` VALUES ('15', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_a2f54227-9930-4f37-b241-2621f2ee2f22', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:05:32', '2020-02-21 14:05:32');
INSERT INTO `t_sys_log` VALUES ('16', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_33c76e9e-5c54-4bd4-8eba-6f7795e3ff4e', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:06:49', '2020-02-21 14:06:49');
INSERT INTO `t_sys_log` VALUES ('17', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_71772aa5-48aa-40b9-8527-695dfbca0754', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:07:32', '2020-02-21 14:07:32');
INSERT INTO `t_sys_log` VALUES ('18', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_111f567c-3a2e-4ddd-9b2a-481cded3ccad', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:07:35', '2020-02-21 14:07:35');
INSERT INTO `t_sys_log` VALUES ('19', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_8ee83620-462c-49b3-b65c-b7ec5645e48d', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:10:36', '2020-02-21 14:10:36');
INSERT INTO `t_sys_log` VALUES ('20', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_4ca01a73-b7fd-4eb3-95e0-0a343f58c505', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:30:30', '2020-02-21 14:30:30');
INSERT INTO `t_sys_log` VALUES ('21', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_3ed10f6d-3c18-4a3c-89bd-52fcecd2eadd', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:30:32', '2020-02-21 14:30:32');
INSERT INTO `t_sys_log` VALUES ('22', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_9b9ed75a-e267-4bfd-b577-2ac7b6bfa881', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:30:34', '2020-02-21 14:30:34');
INSERT INTO `t_sys_log` VALUES ('23', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_c4f83781-d57a-4cdd-a393-d1fb35411519', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:30:34', '2020-02-21 14:30:34');
INSERT INTO `t_sys_log` VALUES ('24', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_06f3d94e-6748-4d49-a76a-52c9f3019dee', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-21 14:30:34', '2020-02-21 14:30:34');
INSERT INTO `t_sys_log` VALUES ('25', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '68 ms', '2020-02-21 16:30:05', '2020-02-21 16:30:05');
INSERT INTO `t_sys_log` VALUES ('26', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '75 ms', '2020-02-21 16:30:05', '2020-02-21 16:30:05');
INSERT INTO `t_sys_log` VALUES ('27', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9001/api/code/project/listPage', '127.0.0.1', '1', '200', '52 ms', '2020-02-21 16:30:12', '2020-02-21 16:30:12');
INSERT INTO `t_sys_log` VALUES ('28', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:30:18', '2020-02-21 16:30:18');
INSERT INTO `t_sys_log` VALUES ('29', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-02-21 16:30:18', '2020-02-21 16:30:18');
INSERT INTO `t_sys_log` VALUES ('30', '保存数据库信息表', 'http://127.0.0.1:9001/api/code/database/save', '127.0.0.1', '1', '200', '13 ms', '2020-02-21 16:33:32', '2020-02-21 16:33:32');
INSERT INTO `t_sys_log` VALUES ('31', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 16:33:32', '2020-02-21 16:33:32');
INSERT INTO `t_sys_log` VALUES ('32', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:33:36', '2020-02-21 16:33:36');
INSERT INTO `t_sys_log` VALUES ('33', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:33:41', '2020-02-21 16:33:41');
INSERT INTO `t_sys_log` VALUES ('34', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '31 ms', '2020-02-21 16:33:41', '2020-02-21 16:33:41');
INSERT INTO `t_sys_log` VALUES ('35', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '24 ms', '2020-02-21 16:33:51', '2020-02-21 16:33:51');
INSERT INTO `t_sys_log` VALUES ('36', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9001/api/code/project/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:33:53', '2020-02-21 16:33:53');
INSERT INTO `t_sys_log` VALUES ('37', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:33:58', '2020-02-21 16:33:58');
INSERT INTO `t_sys_log` VALUES ('38', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '11 ms', '2020-02-21 16:33:58', '2020-02-21 16:33:58');
INSERT INTO `t_sys_log` VALUES ('39', '生成项目代码模板', 'http://127.0.0.1:9001/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '37 ms', '2020-02-21 16:34:42', '2020-02-21 16:34:42');
INSERT INTO `t_sys_log` VALUES ('40', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 16:34:42', '2020-02-21 16:34:42');
INSERT INTO `t_sys_log` VALUES ('41', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 16:34:49', '2020-02-21 16:34:49');
INSERT INTO `t_sys_log` VALUES ('42', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:34:49', '2020-02-21 16:34:49');
INSERT INTO `t_sys_log` VALUES ('43', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9001/api/code/project/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:34:50', '2020-02-21 16:34:50');
INSERT INTO `t_sys_log` VALUES ('44', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:34:56', '2020-02-21 16:34:56');
INSERT INTO `t_sys_log` VALUES ('45', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '2 ms', '2020-02-21 16:35:00', '2020-02-21 16:35:00');
INSERT INTO `t_sys_log` VALUES ('46', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 16:35:00', '2020-02-21 16:35:00');
INSERT INTO `t_sys_log` VALUES ('47', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:35:04', '2020-02-21 16:35:04');
INSERT INTO `t_sys_log` VALUES ('48', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 16:35:04', '2020-02-21 16:35:04');
INSERT INTO `t_sys_log` VALUES ('49', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '181 ms', '2020-02-21 16:35:07', '2020-02-21 16:35:07');
INSERT INTO `t_sys_log` VALUES ('50', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:35:15', '2020-02-21 16:35:15');
INSERT INTO `t_sys_log` VALUES ('51', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:35:16', '2020-02-21 16:35:16');
INSERT INTO `t_sys_log` VALUES ('52', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '7 ms', '2020-02-21 16:35:16', '2020-02-21 16:35:16');
INSERT INTO `t_sys_log` VALUES ('53', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '2 ms', '2020-02-21 16:35:18', '2020-02-21 16:35:18');
INSERT INTO `t_sys_log` VALUES ('54', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:35:18', '2020-02-21 16:35:18');
INSERT INTO `t_sys_log` VALUES ('55', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9001/api/code/project/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:35:19', '2020-02-21 16:35:19');
INSERT INTO `t_sys_log` VALUES ('56', '获取项目包架构树', 'http://127.0.0.1:9001/api/code/project/tree', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:35:24', '2020-02-21 16:35:24');
INSERT INTO `t_sys_log` VALUES ('57', '获取项目包类型列表', 'http://127.0.0.1:9001/api/code/project/listPackage', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:35:27', '2020-02-21 16:35:27');
INSERT INTO `t_sys_log` VALUES ('58', '保存或更新代码生成器 - 项目包', 'http://127.0.0.1:9001/api/code/project/saveOrUpdatePackage', '127.0.0.1', '1', '200', '7 ms', '2020-02-21 16:35:33', '2020-02-21 16:35:33');
INSERT INTO `t_sys_log` VALUES ('59', '获取项目包架构树', 'http://127.0.0.1:9001/api/code/project/tree', '127.0.0.1', '1', '200', '2 ms', '2020-02-21 16:35:33', '2020-02-21 16:35:33');
INSERT INTO `t_sys_log` VALUES ('60', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:35:57', '2020-02-21 16:35:57');
INSERT INTO `t_sys_log` VALUES ('61', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:36:00', '2020-02-21 16:36:00');
INSERT INTO `t_sys_log` VALUES ('62', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:36:04', '2020-02-21 16:36:04');
INSERT INTO `t_sys_log` VALUES ('63', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '7 ms', '2020-02-21 16:36:04', '2020-02-21 16:36:04');
INSERT INTO `t_sys_log` VALUES ('64', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '2 ms', '2020-02-21 16:36:12', '2020-02-21 16:36:12');
INSERT INTO `t_sys_log` VALUES ('65', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:36:12', '2020-02-21 16:36:12');
INSERT INTO `t_sys_log` VALUES ('66', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:36:18', '2020-02-21 16:36:18');
INSERT INTO `t_sys_log` VALUES ('67', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '15 ms', '2020-02-21 16:36:18', '2020-02-21 16:36:18');
INSERT INTO `t_sys_log` VALUES ('68', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:36:31', '2020-02-21 16:36:31');
INSERT INTO `t_sys_log` VALUES ('69', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 16:36:31', '2020-02-21 16:36:31');
INSERT INTO `t_sys_log` VALUES ('70', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 16:36:32', '2020-02-21 16:36:32');
INSERT INTO `t_sys_log` VALUES ('71', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:36:34', '2020-02-21 16:36:34');
INSERT INTO `t_sys_log` VALUES ('72', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:36:35', '2020-02-21 16:36:35');
INSERT INTO `t_sys_log` VALUES ('73', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:36:35', '2020-02-21 16:36:35');
INSERT INTO `t_sys_log` VALUES ('74', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9001/api/code/project/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:36:50', '2020-02-21 16:36:50');
INSERT INTO `t_sys_log` VALUES ('75', '获取项目包架构树', 'http://127.0.0.1:9001/api/code/project/tree', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:37:01', '2020-02-21 16:37:01');
INSERT INTO `t_sys_log` VALUES ('76', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:39:55', '2020-02-21 16:39:55');
INSERT INTO `t_sys_log` VALUES ('77', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:39:55', '2020-02-21 16:39:55');
INSERT INTO `t_sys_log` VALUES ('78', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '35 ms', '2020-02-21 16:40:02', '2020-02-21 16:40:02');
INSERT INTO `t_sys_log` VALUES ('79', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '55 ms', '2020-02-21 16:40:09', '2020-02-21 16:40:09');
INSERT INTO `t_sys_log` VALUES ('80', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=code-generator_token_81159c63-df08-4a2b-b0e0-04c9cf4a9a9a', '127.0.0.1', '1', '401', '2 ms', '2020-02-21 16:46:24', '2020-02-21 16:46:24');
INSERT INTO `t_sys_log` VALUES ('81', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '28 ms', '2020-02-21 16:46:28', '2020-02-21 16:46:28');
INSERT INTO `t_sys_log` VALUES ('82', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '47 ms', '2020-02-21 16:46:28', '2020-02-21 16:46:28');
INSERT INTO `t_sys_log` VALUES ('83', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '35 ms', '2020-02-21 16:46:31', '2020-02-21 16:46:31');
INSERT INTO `t_sys_log` VALUES ('84', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9001/api/code/project/listPage', '127.0.0.1', '1', '200', '21 ms', '2020-02-21 16:46:32', '2020-02-21 16:46:32');
INSERT INTO `t_sys_log` VALUES ('85', '保存或更新代码生成器 - 项目管理', 'http://127.0.0.1:9001/api/code/project/saveOrUpdateProject', '127.0.0.1', '1', '200', '8 ms', '2020-02-21 16:46:42', '2020-02-21 16:46:42');
INSERT INTO `t_sys_log` VALUES ('86', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9001/api/code/project/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:46:42', '2020-02-21 16:46:42');
INSERT INTO `t_sys_log` VALUES ('87', '获取项目包架构树', 'http://127.0.0.1:9001/api/code/project/tree', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:46:44', '2020-02-21 16:46:44');
INSERT INTO `t_sys_log` VALUES ('88', '获取项目包架构树', 'http://127.0.0.1:9001/api/code/project/tree', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:46:49', '2020-02-21 16:46:49');
INSERT INTO `t_sys_log` VALUES ('89', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '7 ms', '2020-02-21 16:46:54', '2020-02-21 16:46:54');
INSERT INTO `t_sys_log` VALUES ('90', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:47:28', '2020-02-21 16:47:28');
INSERT INTO `t_sys_log` VALUES ('91', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '16 ms', '2020-02-21 16:47:28', '2020-02-21 16:47:28');
INSERT INTO `t_sys_log` VALUES ('92', '获取项目包类型列表', 'http://127.0.0.1:9001/api/code/project/listPackage', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 16:47:37', '2020-02-21 16:47:37');
INSERT INTO `t_sys_log` VALUES ('93', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 16:47:45', '2020-02-21 16:47:45');
INSERT INTO `t_sys_log` VALUES ('94', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '7 ms', '2020-02-21 16:47:45', '2020-02-21 16:47:45');
INSERT INTO `t_sys_log` VALUES ('95', '保存数据库信息表', 'http://127.0.0.1:9001/api/code/database/save', '127.0.0.1', '1', '200', '8 ms', '2020-02-21 16:47:59', '2020-02-21 16:47:59');
INSERT INTO `t_sys_log` VALUES ('96', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 16:47:59', '2020-02-21 16:47:59');
INSERT INTO `t_sys_log` VALUES ('97', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '109 ms', '2020-02-21 16:48:02', '2020-02-21 16:48:02');
INSERT INTO `t_sys_log` VALUES ('98', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '50 ms', '2020-02-21 16:48:06', '2020-02-21 16:48:06');
INSERT INTO `t_sys_log` VALUES ('99', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '59 ms', '2020-02-21 16:51:38', '2020-02-21 16:51:38');
INSERT INTO `t_sys_log` VALUES ('100', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '5988 ms', '2020-02-21 16:51:44', '2020-02-21 16:51:44');
INSERT INTO `t_sys_log` VALUES ('101', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '24050 ms', '2020-02-21 16:52:14', '2020-02-21 16:52:14');
INSERT INTO `t_sys_log` VALUES ('102', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '1371 ms', '2020-02-21 16:52:21', '2020-02-21 16:52:21');
INSERT INTO `t_sys_log` VALUES ('103', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '22 ms', '2020-02-21 16:52:48', '2020-02-21 16:52:48');
INSERT INTO `t_sys_log` VALUES ('104', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '30 ms', '2020-02-21 16:52:48', '2020-02-21 16:52:48');
INSERT INTO `t_sys_log` VALUES ('105', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '30 ms', '2020-02-21 16:52:51', '2020-02-21 16:52:51');
INSERT INTO `t_sys_log` VALUES ('106', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '9252 ms', '2020-02-21 16:53:05', '2020-02-21 16:53:05');
INSERT INTO `t_sys_log` VALUES ('107', '??????????', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '58 ms', '2020-02-21 16:57:57', '2020-02-21 16:57:57');
INSERT INTO `t_sys_log` VALUES ('108', '?????', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '95 ms', '2020-02-21 16:57:58', '2020-02-21 16:57:58');
INSERT INTO `t_sys_log` VALUES ('109', '??????? - ??????', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '12 ms', '2020-02-21 16:58:01', '2020-02-21 16:58:01');
INSERT INTO `t_sys_log` VALUES ('110', '????????????', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '38 ms', '2020-02-21 16:58:01', '2020-02-21 16:58:01');
INSERT INTO `t_sys_log` VALUES ('111', '?????', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '30 ms', '2020-02-21 16:58:03', '2020-02-21 16:58:03');
INSERT INTO `t_sys_log` VALUES ('112', '?????', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '47 ms', '2020-02-21 16:58:07', '2020-02-21 16:58:07');
INSERT INTO `t_sys_log` VALUES ('113', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 17:22:56', '2020-02-21 17:22:56');
INSERT INTO `t_sys_log` VALUES ('114', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '36 ms', '2020-02-21 17:22:56', '2020-02-21 17:22:56');
INSERT INTO `t_sys_log` VALUES ('115', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '34 ms', '2020-02-21 17:22:59', '2020-02-21 17:22:59');
INSERT INTO `t_sys_log` VALUES ('116', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '5324 ms', '2020-02-21 17:23:08', '2020-02-21 17:23:08');
INSERT INTO `t_sys_log` VALUES ('117', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '28 ms', '2020-02-21 17:25:16', '2020-02-21 17:25:16');
INSERT INTO `t_sys_log` VALUES ('118', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '38 ms', '2020-02-21 17:25:18', '2020-02-21 17:25:18');
INSERT INTO `t_sys_log` VALUES ('119', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=code-generator_token_be41ce5a-d9af-4d96-ae61-094fb82d2d95', '127.0.0.1', '1', '401', '3 ms', '2020-02-21 17:40:53', '2020-02-21 17:40:53');
INSERT INTO `t_sys_log` VALUES ('120', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '42 ms', '2020-02-21 17:40:57', '2020-02-21 17:40:57');
INSERT INTO `t_sys_log` VALUES ('121', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '71 ms', '2020-02-21 17:40:57', '2020-02-21 17:40:57');
INSERT INTO `t_sys_log` VALUES ('122', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '26 ms', '2020-02-21 17:40:57', '2020-02-21 17:40:57');
INSERT INTO `t_sys_log` VALUES ('123', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '17 ms', '2020-02-21 17:41:02', '2020-02-21 17:41:02');
INSERT INTO `t_sys_log` VALUES ('124', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '14 ms', '2020-02-21 17:41:39', '2020-02-21 17:41:39');
INSERT INTO `t_sys_log` VALUES ('125', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '14 ms', '2020-02-21 17:41:40', '2020-02-21 17:41:40');
INSERT INTO `t_sys_log` VALUES ('126', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 17:41:47', '2020-02-21 17:41:47');
INSERT INTO `t_sys_log` VALUES ('127', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 17:41:48', '2020-02-21 17:41:48');
INSERT INTO `t_sys_log` VALUES ('128', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=code-generator_token_c29606c5-e88c-4110-946c-68ec561d1dc3', '127.0.0.1', '1', '401', '1 ms', '2020-02-21 18:12:02', '2020-02-21 18:12:02');
INSERT INTO `t_sys_log` VALUES ('129', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '10 ms', '2020-02-21 18:12:05', '2020-02-21 18:12:05');
INSERT INTO `t_sys_log` VALUES ('130', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '7 ms', '2020-02-21 18:12:05', '2020-02-21 18:12:05');
INSERT INTO `t_sys_log` VALUES ('131', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-21 18:12:05', '2020-02-21 18:12:05');
INSERT INTO `t_sys_log` VALUES ('132', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '12 ms', '2020-02-21 18:12:09', '2020-02-21 18:12:09');
INSERT INTO `t_sys_log` VALUES ('133', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '20 ms', '2020-02-21 18:12:09', '2020-02-21 18:12:09');
INSERT INTO `t_sys_log` VALUES ('134', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '14 ms', '2020-02-21 18:12:11', '2020-02-21 18:12:11');
INSERT INTO `t_sys_log` VALUES ('135', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 18:12:17', '2020-02-21 18:12:17');
INSERT INTO `t_sys_log` VALUES ('136', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '14 ms', '2020-02-21 18:12:17', '2020-02-21 18:12:17');
INSERT INTO `t_sys_log` VALUES ('137', '获取项目包类型列表', 'http://127.0.0.1:9001/api/code/project/listPackage', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 18:12:24', '2020-02-21 18:12:24');
INSERT INTO `t_sys_log` VALUES ('138', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 18:12:28', '2020-02-21 18:12:28');
INSERT INTO `t_sys_log` VALUES ('139', '生成项目代码模板', 'http://127.0.0.1:9001/api/code/project_template/generateTemplate', '127.0.0.1', '1', '200', '32 ms', '2020-02-21 18:12:42', '2020-02-21 18:12:42');
INSERT INTO `t_sys_log` VALUES ('140', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '7 ms', '2020-02-21 18:12:42', '2020-02-21 18:12:42');
INSERT INTO `t_sys_log` VALUES ('141', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 18:12:48', '2020-02-21 18:12:48');
INSERT INTO `t_sys_log` VALUES ('142', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 18:12:51', '2020-02-21 18:12:51');
INSERT INTO `t_sys_log` VALUES ('143', '获取项目代码模板对应数据源模板列表', 'http://127.0.0.1:9001/api/code/project_template/listPageCodeProjectVelocityContext', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 18:12:57', '2020-02-21 18:12:57');
INSERT INTO `t_sys_log` VALUES ('144', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 18:13:06', '2020-02-21 18:13:06');
INSERT INTO `t_sys_log` VALUES ('145', '获取项目代码模板表列表分页', 'http://127.0.0.1:9001/api/code/bsTemplate/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 18:13:27', '2020-02-21 18:13:27');
INSERT INTO `t_sys_log` VALUES ('146', '获取代码生成器 - 项目管理列表分页', 'http://127.0.0.1:9001/api/code/project/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-21 18:13:29', '2020-02-21 18:13:29');
INSERT INTO `t_sys_log` VALUES ('147', '获取项目包架构树', 'http://127.0.0.1:9001/api/code/project/tree', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 18:13:34', '2020-02-21 18:13:34');
INSERT INTO `t_sys_log` VALUES ('148', '获取项目包类型列表', 'http://127.0.0.1:9001/api/code/project/listPackage', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 18:13:38', '2020-02-21 18:13:38');
INSERT INTO `t_sys_log` VALUES ('149', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '2 ms', '2020-02-21 18:14:26', '2020-02-21 18:14:26');
INSERT INTO `t_sys_log` VALUES ('150', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 18:14:26', '2020-02-21 18:14:26');
INSERT INTO `t_sys_log` VALUES ('151', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '411 ms', '2020-02-21 18:14:30', '2020-02-21 18:14:30');
INSERT INTO `t_sys_log` VALUES ('152', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '44 ms', '2020-02-21 18:14:33', '2020-02-21 18:14:33');
INSERT INTO `t_sys_log` VALUES ('153', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 18:25:12', '2020-02-21 18:25:12');
INSERT INTO `t_sys_log` VALUES ('154', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-21 18:25:12', '2020-02-21 18:25:12');
INSERT INTO `t_sys_log` VALUES ('155', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '30 ms', '2020-02-21 18:25:18', '2020-02-21 18:25:18');
INSERT INTO `t_sys_log` VALUES ('156', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '38 ms', '2020-02-21 18:25:21', '2020-02-21 18:25:21');
INSERT INTO `t_sys_log` VALUES ('157', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '60 ms', '2020-02-21 18:39:23', '2020-02-21 18:39:23');
INSERT INTO `t_sys_log` VALUES ('158', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '50 ms', '2020-02-21 18:39:23', '2020-02-21 18:39:23');
INSERT INTO `t_sys_log` VALUES ('159', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '34 ms', '2020-02-21 18:39:28', '2020-02-21 18:39:28');
INSERT INTO `t_sys_log` VALUES ('160', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '110 ms', '2020-02-21 20:42:58', '2020-02-21 20:42:58');
INSERT INTO `t_sys_log` VALUES ('161', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '105 ms', '2020-02-21 20:42:59', '2020-02-21 20:42:59');
INSERT INTO `t_sys_log` VALUES ('162', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '50 ms', '2020-02-21 20:43:05', '2020-02-21 20:43:05');
INSERT INTO `t_sys_log` VALUES ('163', '获取项目代码模板列表分页', 'http://127.0.0.1:9001/api/code/project_template/listPage', '127.0.0.1', '1', '200', '121 ms', '2020-02-21 20:43:05', '2020-02-21 20:43:05');
INSERT INTO `t_sys_log` VALUES ('164', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '12 ms', '2020-02-21 20:43:11', '2020-02-21 20:43:11');
INSERT INTO `t_sys_log` VALUES ('165', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '36 ms', '2020-02-21 20:43:11', '2020-02-21 20:43:11');
INSERT INTO `t_sys_log` VALUES ('166', '保存数据库信息表', 'http://127.0.0.1:9001/api/code/database/save', '127.0.0.1', '1', '200', '13 ms', '2020-02-21 20:43:37', '2020-02-21 20:43:37');
INSERT INTO `t_sys_log` VALUES ('167', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '11 ms', '2020-02-21 20:43:37', '2020-02-21 20:43:37');
INSERT INTO `t_sys_log` VALUES ('168', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '35 ms', '2020-02-21 20:43:41', '2020-02-21 20:43:41');
INSERT INTO `t_sys_log` VALUES ('169', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '80 ms', '2020-02-21 20:43:47', '2020-02-21 20:43:47');
INSERT INTO `t_sys_log` VALUES ('170', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '20 ms', '2020-02-21 20:46:08', '2020-02-21 20:46:08');
INSERT INTO `t_sys_log` VALUES ('171', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '43 ms', '2020-02-21 20:46:13', '2020-02-21 20:46:13');
INSERT INTO `t_sys_log` VALUES ('172', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '21 ms', '2020-02-21 20:46:41', '2020-02-21 20:46:41');
INSERT INTO `t_sys_log` VALUES ('173', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '44 ms', '2020-02-21 20:46:45', '2020-02-21 20:46:45');
INSERT INTO `t_sys_log` VALUES ('174', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '15 ms', '2020-02-21 20:47:00', '2020-02-21 20:47:00');
INSERT INTO `t_sys_log` VALUES ('175', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '36 ms', '2020-02-21 20:47:24', '2020-02-21 20:47:24');
INSERT INTO `t_sys_log` VALUES ('176', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '11 ms', '2020-02-21 20:47:34', '2020-02-21 20:47:34');
INSERT INTO `t_sys_log` VALUES ('177', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '32 ms', '2020-02-21 20:47:39', '2020-02-21 20:47:39');
INSERT INTO `t_sys_log` VALUES ('178', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '17 ms', '2020-02-21 20:47:49', '2020-02-21 20:47:49');
INSERT INTO `t_sys_log` VALUES ('179', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '31 ms', '2020-02-21 20:47:53', '2020-02-21 20:47:53');
INSERT INTO `t_sys_log` VALUES ('180', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '14 ms', '2020-02-21 20:52:43', '2020-02-21 20:52:43');
INSERT INTO `t_sys_log` VALUES ('181', '参数不全', 'http://localhost:9001/api/auth/login', '0:0:0:0:0:0:0:1', '0', '4000', '0 ms', '2020-02-21 21:02:49', '2020-02-21 21:02:49');
INSERT INTO `t_sys_log` VALUES ('182', '参数不全', 'http://localhost:9001/api/auth/login', '0:0:0:0:0:0:0:1', '0', '4000', '0 ms', '2020-02-21 21:04:07', '2020-02-21 21:04:07');
INSERT INTO `t_sys_log` VALUES ('183', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '3 ms', '2020-02-21 21:05:23', '2020-02-21 21:05:23');
INSERT INTO `t_sys_log` VALUES ('184', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '14 ms', '2020-02-21 21:05:27', '2020-02-21 21:05:27');
INSERT INTO `t_sys_log` VALUES ('185', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '13 ms', '2020-02-21 21:05:27', '2020-02-21 21:05:27');
INSERT INTO `t_sys_log` VALUES ('186', '参数不全', 'http://localhost:9001/api/auth/login', '0:0:0:0:0:0:0:1', '0', '4000', '5 ms', '2020-02-22 07:10:19', '2020-02-22 07:10:19');
INSERT INTO `t_sys_log` VALUES ('187', '参数不全', 'http://localhost:9001/api/auth/login', '0:0:0:0:0:0:0:1', '0', '4000', '0 ms', '2020-02-22 07:11:51', '2020-02-22 07:11:51');
INSERT INTO `t_sys_log` VALUES ('188', '参数不全', 'http://localhost:9001/api/auth/login', '0:0:0:0:0:0:0:1', '0', '4000', '342675 ms', '2020-02-22 07:17:57', '2020-02-22 07:17:57');
INSERT INTO `t_sys_log` VALUES ('189', '参数不全', 'http://localhost:9001/api/auth/login', '0:0:0:0:0:0:0:1', '0', '4000', '1042243 ms', '2020-02-22 07:35:23', '2020-02-22 07:35:23');
INSERT INTO `t_sys_log` VALUES ('190', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '395 ms', '2020-02-22 07:35:33', '2020-02-22 07:35:33');
INSERT INTO `t_sys_log` VALUES ('191', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '131 ms', '2020-02-22 07:35:33', '2020-02-22 07:35:33');
INSERT INTO `t_sys_log` VALUES ('192', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '43 ms', '2020-02-22 07:35:38', '2020-02-22 07:35:38');
INSERT INTO `t_sys_log` VALUES ('193', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '116 ms', '2020-02-22 07:36:10', '2020-02-22 07:36:10');
INSERT INTO `t_sys_log` VALUES ('194', '获取角色信息', 'http://127.0.0.1:9001/api/system/role/detail', '127.0.0.1', '1', '200', '16 ms', '2020-02-22 07:36:18', '2020-02-22 07:36:18');
INSERT INTO `t_sys_log` VALUES ('195', '获取用户树', 'http://127.0.0.1:9001/api/system/user/treeUser', '127.0.0.1', '1', '200', '14 ms', '2020-02-22 07:36:18', '2020-02-22 07:36:18');
INSERT INTO `t_sys_log` VALUES ('196', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9001/api/system/roleMenu/list', '127.0.0.1', '1', '200', '63 ms', '2020-02-22 07:36:18', '2020-02-22 07:36:18');
INSERT INTO `t_sys_log` VALUES ('197', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '58 ms', '2020-02-22 07:36:18', '2020-02-22 07:36:18');
INSERT INTO `t_sys_log` VALUES ('198', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9001/api/system/userRole/list', '127.0.0.1', '1', '200', '47 ms', '2020-02-22 07:36:18', '2020-02-22 07:36:18');
INSERT INTO `t_sys_log` VALUES ('199', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_e3c40c53-998f-4f7d-be38-ecfe79e6b06a', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:41:46', '2020-02-22 07:41:46');
INSERT INTO `t_sys_log` VALUES ('200', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_2f962fd7-d9bd-476b-90cf-c8cc55688c1a', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:41:47', '2020-02-22 07:41:47');
INSERT INTO `t_sys_log` VALUES ('201', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_59619896-1265-4c8c-b248-ccfde09634b8', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:41:50', '2020-02-22 07:41:50');
INSERT INTO `t_sys_log` VALUES ('202', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_2c92ea9a-81bb-4c36-a756-5be23c28eb1e', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:41:52', '2020-02-22 07:41:52');
INSERT INTO `t_sys_log` VALUES ('203', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_5c73549b-ccb8-40ec-a357-8c41bafe3286', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:42:17', '2020-02-22 07:42:17');
INSERT INTO `t_sys_log` VALUES ('204', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_b16af749-fefa-48f4-a33a-a4ff290d171c', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:42:26', '2020-02-22 07:42:26');
INSERT INTO `t_sys_log` VALUES ('205', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_9a5087ea-8c1f-4718-b767-038c1c7b5148', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:42:26', '2020-02-22 07:42:26');
INSERT INTO `t_sys_log` VALUES ('206', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_65cb1896-9b5b-4832-86ec-6e703af4cabd', '0:0:0:0:0:0:0:1', '0', '401', '6 ms', '2020-02-22 07:50:29', '2020-02-22 07:50:29');
INSERT INTO `t_sys_log` VALUES ('207', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_70c4f12e-83f3-4783-a619-5f3646f08a79', '0:0:0:0:0:0:0:1', '0', '401', '6 ms', '2020-02-22 07:50:29', '2020-02-22 07:50:29');
INSERT INTO `t_sys_log` VALUES ('208', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_1abcfec1-ff64-41f7-817d-aa2b1754213e', '0:0:0:0:0:0:0:1', '0', '401', '6 ms', '2020-02-22 07:50:29', '2020-02-22 07:50:29');
INSERT INTO `t_sys_log` VALUES ('209', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_11bcf539-45f1-46fc-85d0-3534086bc322', '0:0:0:0:0:0:0:1', '0', '401', '6 ms', '2020-02-22 07:50:29', '2020-02-22 07:50:29');
INSERT INTO `t_sys_log` VALUES ('210', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_2e6f1c9e-cea6-48cb-8bb0-127c2b2e20c8', '0:0:0:0:0:0:0:1', '0', '401', '6 ms', '2020-02-22 07:50:29', '2020-02-22 07:50:29');
INSERT INTO `t_sys_log` VALUES ('211', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_39f9d1ce-44fc-4434-ad6c-ebc7879e9251', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:50:37', '2020-02-22 07:50:37');
INSERT INTO `t_sys_log` VALUES ('212', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_f2ca2e16-0eee-4bfe-9e60-c17452e44cf8', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:50:43', '2020-02-22 07:50:43');
INSERT INTO `t_sys_log` VALUES ('213', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_17b9b70c-9b06-409d-8e5e-5725538bb584', '0:0:0:0:0:0:0:1', '0', '401', '5 ms', '2020-02-22 07:52:41', '2020-02-22 07:52:41');
INSERT INTO `t_sys_log` VALUES ('214', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_d93dd50d-4f1e-4b0f-857f-5b97eab6b83b', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:52:42', '2020-02-22 07:52:42');
INSERT INTO `t_sys_log` VALUES ('215', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_fae2f028-aeae-49a5-8736-ef62839cf465', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:52:43', '2020-02-22 07:52:43');
INSERT INTO `t_sys_log` VALUES ('216', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_fe8adc76-3d27-4684-a4b2-b3f455bc6fa5', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:52:43', '2020-02-22 07:52:43');
INSERT INTO `t_sys_log` VALUES ('217', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_d7e6cba4-4e3b-4291-add1-5c6b090d1270', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:52:43', '2020-02-22 07:52:43');
INSERT INTO `t_sys_log` VALUES ('218', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_ee71529e-ccd4-44ef-9316-caa8961804f3', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:52:43', '2020-02-22 07:52:43');
INSERT INTO `t_sys_log` VALUES ('219', '未登录', 'http://localhost:9001/api/auth/unLogin;JSESSIONID=code-generator_token_53c630ad-1f4a-40fd-bc5f-1721af5c785a', '0:0:0:0:0:0:0:1', '0', '401', '0 ms', '2020-02-22 07:52:46', '2020-02-22 07:52:46');
INSERT INTO `t_sys_log` VALUES ('220', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '113 ms', '2020-02-22 21:57:53', '2020-02-22 21:57:53');
INSERT INTO `t_sys_log` VALUES ('221', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '118 ms', '2020-02-22 21:57:54', '2020-02-22 21:57:54');
INSERT INTO `t_sys_log` VALUES ('222', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '32 ms', '2020-02-22 22:07:17', '2020-02-22 22:07:17');
INSERT INTO `t_sys_log` VALUES ('223', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '39 ms', '2020-02-22 22:10:16', '2020-02-22 22:10:16');
INSERT INTO `t_sys_log` VALUES ('224', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '29 ms', '2020-02-22 22:11:20', '2020-02-22 22:11:20');
INSERT INTO `t_sys_log` VALUES ('225', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '88 ms', '2020-02-22 22:11:46', '2020-02-22 22:11:46');
INSERT INTO `t_sys_log` VALUES ('226', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '31 ms', '2020-02-22 22:12:05', '2020-02-22 22:12:05');
INSERT INTO `t_sys_log` VALUES ('227', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '13 ms', '2020-02-22 22:12:09', '2020-02-22 22:12:09');
INSERT INTO `t_sys_log` VALUES ('228', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '44 ms', '2020-02-22 22:12:21', '2020-02-22 22:12:21');
INSERT INTO `t_sys_log` VALUES ('229', '获取角色信息', 'http://127.0.0.1:9001/api/system/role/detail', '127.0.0.1', '1', '200', '12 ms', '2020-02-22 22:12:24', '2020-02-22 22:12:24');
INSERT INTO `t_sys_log` VALUES ('230', '获取用户树', 'http://127.0.0.1:9001/api/system/user/treeUser', '127.0.0.1', '1', '200', '11 ms', '2020-02-22 22:12:25', '2020-02-22 22:12:25');
INSERT INTO `t_sys_log` VALUES ('231', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '18 ms', '2020-02-22 22:12:25', '2020-02-22 22:12:25');
INSERT INTO `t_sys_log` VALUES ('232', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9001/api/system/roleMenu/list', '127.0.0.1', '1', '200', '40 ms', '2020-02-22 22:12:25', '2020-02-22 22:12:25');
INSERT INTO `t_sys_log` VALUES ('233', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9001/api/system/userRole/list', '127.0.0.1', '1', '200', '91 ms', '2020-02-22 22:12:25', '2020-02-22 22:12:25');
INSERT INTO `t_sys_log` VALUES ('234', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '15 ms', '2020-02-22 22:12:35', '2020-02-22 22:12:35');
INSERT INTO `t_sys_log` VALUES ('235', '获取角色信息', 'http://127.0.0.1:9001/api/system/role/detail', '127.0.0.1', '1', '200', '2 ms', '2020-02-22 22:12:41', '2020-02-22 22:12:41');
INSERT INTO `t_sys_log` VALUES ('236', '获取用户树', 'http://127.0.0.1:9001/api/system/user/treeUser', '127.0.0.1', '1', '200', '6 ms', '2020-02-22 22:12:42', '2020-02-22 22:12:42');
INSERT INTO `t_sys_log` VALUES ('237', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9001/api/system/userRole/list', '127.0.0.1', '1', '200', '14 ms', '2020-02-22 22:12:42', '2020-02-22 22:12:42');
INSERT INTO `t_sys_log` VALUES ('238', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '19 ms', '2020-02-22 22:12:42', '2020-02-22 22:12:42');
INSERT INTO `t_sys_log` VALUES ('239', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9001/api/system/roleMenu/list', '127.0.0.1', '1', '200', '26 ms', '2020-02-22 22:12:42', '2020-02-22 22:12:42');
INSERT INTO `t_sys_log` VALUES ('240', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '30 ms', '2020-02-22 22:13:01', '2020-02-22 22:13:01');
INSERT INTO `t_sys_log` VALUES ('241', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '13 ms', '2020-02-22 22:13:03', '2020-02-22 22:13:03');
INSERT INTO `t_sys_log` VALUES ('242', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '8 ms', '2020-02-22 22:13:26', '2020-02-22 22:13:26');
INSERT INTO `t_sys_log` VALUES ('243', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '7 ms', '2020-02-22 22:14:37', '2020-02-22 22:14:37');
INSERT INTO `t_sys_log` VALUES ('244', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '22 ms', '2020-02-22 22:15:27', '2020-02-22 22:15:27');
INSERT INTO `t_sys_log` VALUES ('245', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '23 ms', '2020-02-22 22:17:20', '2020-02-22 22:17:20');
INSERT INTO `t_sys_log` VALUES ('246', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '22 ms', '2020-02-22 22:25:44', '2020-02-22 22:25:44');
INSERT INTO `t_sys_log` VALUES ('247', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '118 ms', '2020-02-23 12:24:41', '2020-02-23 12:24:41');
INSERT INTO `t_sys_log` VALUES ('248', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '122671 ms', '2020-02-23 12:29:35', '2020-02-23 12:29:35');
INSERT INTO `t_sys_log` VALUES ('249', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '18648 ms', '2020-02-23 12:29:58', '2020-02-23 12:29:58');
INSERT INTO `t_sys_log` VALUES ('250', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '46938 ms', '2020-02-23 12:30:48', '2020-02-23 12:30:48');
INSERT INTO `t_sys_log` VALUES ('251', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '138615 ms', '2020-02-23 12:33:09', '2020-02-23 12:33:09');
INSERT INTO `t_sys_log` VALUES ('252', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '38295 ms', '2020-02-23 12:33:51', '2020-02-23 12:33:51');
INSERT INTO `t_sys_log` VALUES ('253', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '88834 ms', '2020-02-23 12:35:23', '2020-02-23 12:35:23');
INSERT INTO `t_sys_log` VALUES ('254', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '44430 ms', '2020-02-23 12:36:09', '2020-02-23 12:36:09');
INSERT INTO `t_sys_log` VALUES ('255', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '225841 ms', '2020-02-23 12:39:57', '2020-02-23 12:39:57');
INSERT INTO `t_sys_log` VALUES ('256', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '4574 ms', '2020-02-23 12:40:08', '2020-02-23 12:40:08');
INSERT INTO `t_sys_log` VALUES ('257', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '450517 ms', '2020-02-23 12:47:46', '2020-02-23 12:47:46');
INSERT INTO `t_sys_log` VALUES ('258', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '124107 ms', '2020-02-23 12:52:24', '2020-02-23 12:52:24');
INSERT INTO `t_sys_log` VALUES ('259', '用户名或者密码错误!', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '0', '4000', '315457 ms', '2020-02-23 12:58:58', '2020-02-23 12:58:58');
INSERT INTO `t_sys_log` VALUES ('260', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '23226 ms', '2020-02-23 12:59:25', '2020-02-23 12:59:25');
INSERT INTO `t_sys_log` VALUES ('261', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 12:59:30', '2020-02-23 12:59:30');
INSERT INTO `t_sys_log` VALUES ('262', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '124 ms', '2020-02-23 12:59:31', '2020-02-23 12:59:31');
INSERT INTO `t_sys_log` VALUES ('263', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 12:59:35', '2020-02-23 12:59:35');
INSERT INTO `t_sys_log` VALUES ('264', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '334 ms', '2020-02-23 13:00:22', '2020-02-23 13:00:22');
INSERT INTO `t_sys_log` VALUES ('265', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '85 ms', '2020-02-23 13:00:22', '2020-02-23 13:00:22');
INSERT INTO `t_sys_log` VALUES ('266', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 13:02:09', '2020-02-23 13:02:09');
INSERT INTO `t_sys_log` VALUES ('267', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '616736 ms', '2020-02-23 13:12:29', '2020-02-23 13:12:29');
INSERT INTO `t_sys_log` VALUES ('268', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 13:12:29', '2020-02-23 13:12:29');
INSERT INTO `t_sys_log` VALUES ('269', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '100 ms', '2020-02-23 13:12:57', '2020-02-23 13:12:57');
INSERT INTO `t_sys_log` VALUES ('270', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '75 ms', '2020-02-23 13:12:58', '2020-02-23 13:12:58');
INSERT INTO `t_sys_log` VALUES ('271', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '130 ms', '2020-02-23 13:49:29', '2020-02-23 13:49:29');
INSERT INTO `t_sys_log` VALUES ('272', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '81 ms', '2020-02-23 13:49:29', '2020-02-23 13:49:29');
INSERT INTO `t_sys_log` VALUES ('273', '获取代码生成器 - 项目管理列表', 'http://127.0.0.1:9001/api/code/project/list', '127.0.0.1', '1', '200', '42 ms', '2020-02-23 13:49:34', '2020-02-23 13:49:34');
INSERT INTO `t_sys_log` VALUES ('274', '获取数据库信息表列表分页', 'http://127.0.0.1:9001/api/code/database/listPage', '127.0.0.1', '1', '200', '83 ms', '2020-02-23 13:49:34', '2020-02-23 13:49:34');
INSERT INTO `t_sys_log` VALUES ('275', '获取数据表', 'http://127.0.0.1:9001/api/code/database/tableList', '127.0.0.1', '1', '200', '31 ms', '2020-02-23 13:49:38', '2020-02-23 13:49:38');
INSERT INTO `t_sys_log` VALUES ('276', '表字段列表', 'http://127.0.0.1:9001/api/code/database/columnList', '127.0.0.1', '1', '200', '87 ms', '2020-02-23 13:49:44', '2020-02-23 13:49:44');
INSERT INTO `t_sys_log` VALUES ('277', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_8a6aee71-dbff-45af-83b6-165d2714db24', '127.0.0.1', '0', '401', '6 ms', '2020-02-23 15:03:44', '2020-02-23 15:03:44');
INSERT INTO `t_sys_log` VALUES ('278', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_608388cd-d9ab-49be-a202-e01df6528425', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:05:21', '2020-02-23 15:05:21');
INSERT INTO `t_sys_log` VALUES ('279', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_ad8a7af1-a630-4e02-be5e-b7b6f7a03c2e', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:06:27', '2020-02-23 15:06:27');
INSERT INTO `t_sys_log` VALUES ('280', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_3e12e58d-ad5f-4bd2-a698-bafee6aa4464', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:07:26', '2020-02-23 15:07:26');
INSERT INTO `t_sys_log` VALUES ('281', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_3ef68803-12a9-41ff-a2a1-f409e8a3bb56', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:08:59', '2020-02-23 15:08:59');
INSERT INTO `t_sys_log` VALUES ('282', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_c5128ead-cb0d-4fe8-af0e-ca98f7ff65c8', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:15:45', '2020-02-23 15:15:45');
INSERT INTO `t_sys_log` VALUES ('283', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '6823 ms', '2020-02-23 15:17:36', '2020-02-23 15:17:36');
INSERT INTO `t_sys_log` VALUES ('284', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12742 ms', '2020-02-23 15:17:49', '2020-02-23 15:17:49');
INSERT INTO `t_sys_log` VALUES ('285', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_7c596003-5f85-4a5d-bcce-324c333529bb', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:18:23', '2020-02-23 15:18:23');
INSERT INTO `t_sys_log` VALUES ('286', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_f3b01564-56cc-435b-bccf-61cd1d8cd7c5', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:18:46', '2020-02-23 15:18:46');
INSERT INTO `t_sys_log` VALUES ('287', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 15:18:56', '2020-02-23 15:18:56');
INSERT INTO `t_sys_log` VALUES ('288', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '22 ms', '2020-02-23 15:18:56', '2020-02-23 15:18:56');
INSERT INTO `t_sys_log` VALUES ('289', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 15:19:39', '2020-02-23 15:19:39');
INSERT INTO `t_sys_log` VALUES ('290', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_c9cee536-03eb-4c54-bd92-2d0aeba36c0f', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:20:02', '2020-02-23 15:20:02');
INSERT INTO `t_sys_log` VALUES ('291', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '36 ms', '2020-02-23 15:20:02', '2020-02-23 15:20:02');
INSERT INTO `t_sys_log` VALUES ('292', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '21 ms', '2020-02-23 15:20:17', '2020-02-23 15:20:17');
INSERT INTO `t_sys_log` VALUES ('293', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_e4d18c61-456a-496e-b422-b192f2f57602', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:21:33', '2020-02-23 15:21:33');
INSERT INTO `t_sys_log` VALUES ('294', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_5ec9c0e7-f176-44bc-89f2-bb6630b0f34c', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 15:25:26', '2020-02-23 15:25:26');
INSERT INTO `t_sys_log` VALUES ('295', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '38 ms', '2020-02-23 15:25:43', '2020-02-23 15:25:43');
INSERT INTO `t_sys_log` VALUES ('296', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 15:25:43', '2020-02-23 15:25:43');
INSERT INTO `t_sys_log` VALUES ('297', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '21 ms', '2020-02-23 15:26:52', '2020-02-23 15:26:52');
INSERT INTO `t_sys_log` VALUES ('298', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '18 ms', '2020-02-23 15:27:00', '2020-02-23 15:27:00');
INSERT INTO `t_sys_log` VALUES ('299', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '27 ms', '2020-02-23 15:37:12', '2020-02-23 15:37:12');
INSERT INTO `t_sys_log` VALUES ('300', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '31 ms', '2020-02-23 15:38:23', '2020-02-23 15:38:23');
INSERT INTO `t_sys_log` VALUES ('301', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 15:40:26', '2020-02-23 15:40:26');
INSERT INTO `t_sys_log` VALUES ('302', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '37 ms', '2020-02-23 15:41:30', '2020-02-23 15:41:30');
INSERT INTO `t_sys_log` VALUES ('303', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 15:41:37', '2020-02-23 15:41:37');
INSERT INTO `t_sys_log` VALUES ('304', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '23 ms', '2020-02-23 15:48:49', '2020-02-23 15:48:49');
INSERT INTO `t_sys_log` VALUES ('305', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 15:48:50', '2020-02-23 15:48:50');
INSERT INTO `t_sys_log` VALUES ('306', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '17 ms', '2020-02-23 15:51:27', '2020-02-23 15:51:27');
INSERT INTO `t_sys_log` VALUES ('307', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 15:56:00', '2020-02-23 15:56:00');
INSERT INTO `t_sys_log` VALUES ('308', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 15:56:00', '2020-02-23 15:56:00');
INSERT INTO `t_sys_log` VALUES ('309', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 15:56:02', '2020-02-23 15:56:02');
INSERT INTO `t_sys_log` VALUES ('310', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-23 16:02:14', '2020-02-23 16:02:14');
INSERT INTO `t_sys_log` VALUES ('311', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 16:02:19', '2020-02-23 16:02:19');
INSERT INTO `t_sys_log` VALUES ('312', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '22 ms', '2020-02-23 16:03:56', '2020-02-23 16:03:56');
INSERT INTO `t_sys_log` VALUES ('313', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 16:07:35', '2020-02-23 16:07:35');
INSERT INTO `t_sys_log` VALUES ('314', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 16:08:23', '2020-02-23 16:08:23');
INSERT INTO `t_sys_log` VALUES ('315', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 16:09:29', '2020-02-23 16:09:29');
INSERT INTO `t_sys_log` VALUES ('316', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '35 ms', '2020-02-23 16:09:36', '2020-02-23 16:09:36');
INSERT INTO `t_sys_log` VALUES ('317', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '25 ms', '2020-02-23 16:09:39', '2020-02-23 16:09:39');
INSERT INTO `t_sys_log` VALUES ('318', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-23 16:11:00', '2020-02-23 16:11:00');
INSERT INTO `t_sys_log` VALUES ('319', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 16:11:01', '2020-02-23 16:11:01');
INSERT INTO `t_sys_log` VALUES ('320', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 16:13:34', '2020-02-23 16:13:34');
INSERT INTO `t_sys_log` VALUES ('321', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '13 ms', '2020-02-23 16:13:35', '2020-02-23 16:13:35');
INSERT INTO `t_sys_log` VALUES ('322', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 16:15:14', '2020-02-23 16:15:14');
INSERT INTO `t_sys_log` VALUES ('323', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '12 ms', '2020-02-23 16:15:15', '2020-02-23 16:15:15');
INSERT INTO `t_sys_log` VALUES ('324', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-02-23 16:15:58', '2020-02-23 16:15:58');
INSERT INTO `t_sys_log` VALUES ('325', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 16:15:58', '2020-02-23 16:15:58');
INSERT INTO `t_sys_log` VALUES ('326', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 16:16:07', '2020-02-23 16:16:07');
INSERT INTO `t_sys_log` VALUES ('327', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '17 ms', '2020-02-23 16:17:21', '2020-02-23 16:17:21');
INSERT INTO `t_sys_log` VALUES ('328', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 16:17:21', '2020-02-23 16:17:21');
INSERT INTO `t_sys_log` VALUES ('329', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-02-23 16:18:10', '2020-02-23 16:18:10');
INSERT INTO `t_sys_log` VALUES ('330', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '7 ms', '2020-02-23 16:18:10', '2020-02-23 16:18:10');
INSERT INTO `t_sys_log` VALUES ('331', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 16:25:07', '2020-02-23 16:25:07');
INSERT INTO `t_sys_log` VALUES ('332', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 16:25:07', '2020-02-23 16:25:07');
INSERT INTO `t_sys_log` VALUES ('333', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 16:26:35', '2020-02-23 16:26:35');
INSERT INTO `t_sys_log` VALUES ('334', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 16:26:35', '2020-02-23 16:26:35');
INSERT INTO `t_sys_log` VALUES ('335', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 16:26:39', '2020-02-23 16:26:39');
INSERT INTO `t_sys_log` VALUES ('336', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '7 ms', '2020-02-23 16:26:39', '2020-02-23 16:26:39');
INSERT INTO `t_sys_log` VALUES ('337', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 16:26:42', '2020-02-23 16:26:42');
INSERT INTO `t_sys_log` VALUES ('338', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '17 ms', '2020-02-23 16:26:43', '2020-02-23 16:26:43');
INSERT INTO `t_sys_log` VALUES ('339', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 16:26:43', '2020-02-23 16:26:43');
INSERT INTO `t_sys_log` VALUES ('340', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:26:43', '2020-02-23 16:26:43');
INSERT INTO `t_sys_log` VALUES ('341', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 16:29:27', '2020-02-23 16:29:27');
INSERT INTO `t_sys_log` VALUES ('342', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 16:29:53', '2020-02-23 16:29:53');
INSERT INTO `t_sys_log` VALUES ('343', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 16:30:55', '2020-02-23 16:30:55');
INSERT INTO `t_sys_log` VALUES ('344', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 16:32:01', '2020-02-23 16:32:01');
INSERT INTO `t_sys_log` VALUES ('345', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 16:32:01', '2020-02-23 16:32:01');
INSERT INTO `t_sys_log` VALUES ('346', '保存菜单 ', 'http://127.0.0.1:9001/api/system/menu/save', '127.0.0.1', '1', '200', '36 ms', '2020-02-23 16:32:35', '2020-02-23 16:32:35');
INSERT INTO `t_sys_log` VALUES ('347', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:32:35', '2020-02-23 16:32:35');
INSERT INTO `t_sys_log` VALUES ('348', '保存菜单 ', 'http://127.0.0.1:9001/api/system/menu/save', '127.0.0.1', '1', '200', '39 ms', '2020-02-23 16:33:01', '2020-02-23 16:33:01');
INSERT INTO `t_sys_log` VALUES ('349', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 16:33:01', '2020-02-23 16:33:01');
INSERT INTO `t_sys_log` VALUES ('350', '保存菜单 ', 'http://127.0.0.1:9001/api/system/menu/save', '127.0.0.1', '1', '200', '33 ms', '2020-02-23 16:33:36', '2020-02-23 16:33:36');
INSERT INTO `t_sys_log` VALUES ('351', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 16:33:36', '2020-02-23 16:33:36');
INSERT INTO `t_sys_log` VALUES ('352', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 16:33:53', '2020-02-23 16:33:53');
INSERT INTO `t_sys_log` VALUES ('353', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 16:33:53', '2020-02-23 16:33:53');
INSERT INTO `t_sys_log` VALUES ('354', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 16:33:57', '2020-02-23 16:33:57');
INSERT INTO `t_sys_log` VALUES ('355', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:34:15', '2020-02-23 16:34:15');
INSERT INTO `t_sys_log` VALUES ('356', '获取角色信息', 'http://127.0.0.1:9001/api/system/role/detail', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 16:34:22', '2020-02-23 16:34:22');
INSERT INTO `t_sys_log` VALUES ('357', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '17 ms', '2020-02-23 16:34:22', '2020-02-23 16:34:22');
INSERT INTO `t_sys_log` VALUES ('358', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9001/api/system/roleMenu/list', '127.0.0.1', '1', '200', '42 ms', '2020-02-23 16:34:22', '2020-02-23 16:34:22');
INSERT INTO `t_sys_log` VALUES ('359', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9001/api/system/userRole/list', '127.0.0.1', '1', '200', '57 ms', '2020-02-23 16:34:22', '2020-02-23 16:34:22');
INSERT INTO `t_sys_log` VALUES ('360', '获取用户树', 'http://127.0.0.1:9001/api/system/user/treeUser', '127.0.0.1', '1', '200', '57 ms', '2020-02-23 16:34:22', '2020-02-23 16:34:22');
INSERT INTO `t_sys_log` VALUES ('361', '保存角色相关联菜单', 'http://127.0.0.1:9001/api/system/roleMenu/saveRoleMenu', '127.0.0.1', '1', '200', '93 ms', '2020-02-23 16:34:26', '2020-02-23 16:34:26');
INSERT INTO `t_sys_log` VALUES ('362', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '13 ms', '2020-02-23 16:34:30', '2020-02-23 16:34:30');
INSERT INTO `t_sys_log` VALUES ('363', '获取用户树', 'http://127.0.0.1:9001/api/system/user/treeUser', '127.0.0.1', '1', '200', '7 ms', '2020-02-23 16:34:30', '2020-02-23 16:34:30');
INSERT INTO `t_sys_log` VALUES ('364', '获取角色信息', 'http://127.0.0.1:9001/api/system/role/detail', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:34:30', '2020-02-23 16:34:30');
INSERT INTO `t_sys_log` VALUES ('365', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9001/api/system/userRole/list', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 16:34:30', '2020-02-23 16:34:30');
INSERT INTO `t_sys_log` VALUES ('366', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9001/api/system/roleMenu/list', '127.0.0.1', '1', '200', '7 ms', '2020-02-23 16:34:30', '2020-02-23 16:34:30');
INSERT INTO `t_sys_log` VALUES ('367', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 16:34:30', '2020-02-23 16:34:30');
INSERT INTO `t_sys_log` VALUES ('368', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:34:34', '2020-02-23 16:34:34');
INSERT INTO `t_sys_log` VALUES ('369', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:34:38', '2020-02-23 16:34:38');
INSERT INTO `t_sys_log` VALUES ('370', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 16:34:39', '2020-02-23 16:34:39');
INSERT INTO `t_sys_log` VALUES ('371', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '7 ms', '2020-02-23 16:34:39', '2020-02-23 16:34:39');
INSERT INTO `t_sys_log` VALUES ('372', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:34:39', '2020-02-23 16:34:39');
INSERT INTO `t_sys_log` VALUES ('373', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:34:47', '2020-02-23 16:34:47');
INSERT INTO `t_sys_log` VALUES ('374', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9001/api/system/userRole/list', '127.0.0.1', '1', '200', '3 ms', '2020-02-23 16:34:53', '2020-02-23 16:34:53');
INSERT INTO `t_sys_log` VALUES ('375', '获取角色信息', 'http://127.0.0.1:9001/api/system/role/detail', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:34:53', '2020-02-23 16:34:53');
INSERT INTO `t_sys_log` VALUES ('376', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9001/api/system/roleMenu/list', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 16:34:53', '2020-02-23 16:34:53');
INSERT INTO `t_sys_log` VALUES ('377', '获取用户树', 'http://127.0.0.1:9001/api/system/user/treeUser', '127.0.0.1', '1', '200', '7 ms', '2020-02-23 16:34:53', '2020-02-23 16:34:53');
INSERT INTO `t_sys_log` VALUES ('378', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 16:34:53', '2020-02-23 16:34:53');
INSERT INTO `t_sys_log` VALUES ('379', '保存角色相关联菜单', 'http://127.0.0.1:9001/api/system/roleMenu/saveRoleMenu', '127.0.0.1', '1', '200', '88 ms', '2020-02-23 16:34:58', '2020-02-23 16:34:58');
INSERT INTO `t_sys_log` VALUES ('380', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '3 ms', '2020-02-23 16:35:01', '2020-02-23 16:35:01');
INSERT INTO `t_sys_log` VALUES ('381', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 16:35:04', '2020-02-23 16:35:04');
INSERT INTO `t_sys_log` VALUES ('382', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 16:35:07', '2020-02-23 16:35:07');
INSERT INTO `t_sys_log` VALUES ('383', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 16:35:31', '2020-02-23 16:35:31');
INSERT INTO `t_sys_log` VALUES ('384', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 16:35:33', '2020-02-23 16:35:33');
INSERT INTO `t_sys_log` VALUES ('385', '保存或更新角色', 'http://127.0.0.1:9001/api/system/role/saveOrUpdate', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 16:35:38', '2020-02-23 16:35:38');
INSERT INTO `t_sys_log` VALUES ('386', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '3 ms', '2020-02-23 16:35:38', '2020-02-23 16:35:38');
INSERT INTO `t_sys_log` VALUES ('387', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=code-generator_token_09343292-dd66-4805-922d-a4ad5fd60511', '127.0.0.1', '1', '401', '3 ms', '2020-02-23 16:37:17', '2020-02-23 16:37:17');
INSERT INTO `t_sys_log` VALUES ('388', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '41 ms', '2020-02-23 16:37:20', '2020-02-23 16:37:20');
INSERT INTO `t_sys_log` VALUES ('389', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '94 ms', '2020-02-23 16:37:20', '2020-02-23 16:37:20');
INSERT INTO `t_sys_log` VALUES ('390', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '70 ms', '2020-02-23 16:37:23', '2020-02-23 16:37:23');
INSERT INTO `t_sys_log` VALUES ('391', '获取角色信息', 'http://127.0.0.1:9001/api/system/role/detail', '127.0.0.1', '1', '200', '41 ms', '2020-02-23 16:37:26', '2020-02-23 16:37:26');
INSERT INTO `t_sys_log` VALUES ('392', '获取用户树', 'http://127.0.0.1:9001/api/system/user/treeUser', '127.0.0.1', '1', '200', '21 ms', '2020-02-23 16:37:26', '2020-02-23 16:37:26');
INSERT INTO `t_sys_log` VALUES ('393', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '51 ms', '2020-02-23 16:37:26', '2020-02-23 16:37:26');
INSERT INTO `t_sys_log` VALUES ('394', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9001/api/system/roleMenu/list', '127.0.0.1', '1', '200', '47 ms', '2020-02-23 16:37:26', '2020-02-23 16:37:26');
INSERT INTO `t_sys_log` VALUES ('395', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9001/api/system/userRole/list', '127.0.0.1', '1', '200', '102 ms', '2020-02-23 16:37:26', '2020-02-23 16:37:26');
INSERT INTO `t_sys_log` VALUES ('396', '保存角色相关联菜单', 'http://127.0.0.1:9001/api/system/roleMenu/saveRoleMenu', '127.0.0.1', '1', '200', '98 ms', '2020-02-23 16:37:37', '2020-02-23 16:37:37');
INSERT INTO `t_sys_log` VALUES ('397', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 16:37:43', '2020-02-23 16:37:43');
INSERT INTO `t_sys_log` VALUES ('398', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 16:37:44', '2020-02-23 16:37:44');
INSERT INTO `t_sys_log` VALUES ('399', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 16:37:44', '2020-02-23 16:37:44');
INSERT INTO `t_sys_log` VALUES ('400', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 16:37:48', '2020-02-23 16:37:48');
INSERT INTO `t_sys_log` VALUES ('401', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '12 ms', '2020-02-23 16:37:49', '2020-02-23 16:37:49');
INSERT INTO `t_sys_log` VALUES ('402', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 16:46:55', '2020-02-23 16:46:55');
INSERT INTO `t_sys_log` VALUES ('403', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '93 ms', '2020-02-23 17:00:19', '2020-02-23 17:00:19');
INSERT INTO `t_sys_log` VALUES ('404', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '93 ms', '2020-02-23 17:00:20', '2020-02-23 17:00:20');
INSERT INTO `t_sys_log` VALUES ('405', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '54 ms', '2020-02-23 17:00:24', '2020-02-23 17:00:24');
INSERT INTO `t_sys_log` VALUES ('406', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '32 ms', '2020-02-23 17:00:26', '2020-02-23 17:00:26');
INSERT INTO `t_sys_log` VALUES ('407', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '32 ms', '2020-02-23 17:00:28', '2020-02-23 17:00:28');
INSERT INTO `t_sys_log` VALUES ('408', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '25 ms', '2020-02-23 17:00:30', '2020-02-23 17:00:30');
INSERT INTO `t_sys_log` VALUES ('409', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '12 ms', '2020-02-23 17:00:32', '2020-02-23 17:00:32');
INSERT INTO `t_sys_log` VALUES ('410', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 17:00:33', '2020-02-23 17:00:33');
INSERT INTO `t_sys_log` VALUES ('411', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 17:00:43', '2020-02-23 17:00:43');
INSERT INTO `t_sys_log` VALUES ('412', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '17 ms', '2020-02-23 17:00:50', '2020-02-23 17:00:50');
INSERT INTO `t_sys_log` VALUES ('413', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '12 ms', '2020-02-23 17:00:55', '2020-02-23 17:00:55');
INSERT INTO `t_sys_log` VALUES ('414', '保存菜单 ', 'http://127.0.0.1:9001/api/system/menu/save', '127.0.0.1', '1', '200', '35 ms', '2020-02-23 17:01:19', '2020-02-23 17:01:19');
INSERT INTO `t_sys_log` VALUES ('415', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 17:01:19', '2020-02-23 17:01:19');
INSERT INTO `t_sys_log` VALUES ('416', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 17:01:24', '2020-02-23 17:01:24');
INSERT INTO `t_sys_log` VALUES ('417', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 17:01:24', '2020-02-23 17:01:24');
INSERT INTO `t_sys_log` VALUES ('418', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 17:01:34', '2020-02-23 17:01:34');
INSERT INTO `t_sys_log` VALUES ('419', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 17:02:20', '2020-02-23 17:02:20');
INSERT INTO `t_sys_log` VALUES ('420', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 17:03:25', '2020-02-23 17:03:25');
INSERT INTO `t_sys_log` VALUES ('421', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '13 ms', '2020-02-23 17:09:23', '2020-02-23 17:09:23');
INSERT INTO `t_sys_log` VALUES ('422', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 17:10:02', '2020-02-23 17:10:02');
INSERT INTO `t_sys_log` VALUES ('423', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '20 ms', '2020-02-23 17:11:18', '2020-02-23 17:11:18');
INSERT INTO `t_sys_log` VALUES ('424', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11 ms', '2020-02-23 17:13:24', '2020-02-23 17:13:24');
INSERT INTO `t_sys_log` VALUES ('425', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '7 ms', '2020-02-23 17:14:57', '2020-02-23 17:14:57');
INSERT INTO `t_sys_log` VALUES ('426', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '52 ms', '2020-02-23 17:14:59', '2020-02-23 17:14:59');
INSERT INTO `t_sys_log` VALUES ('427', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '108 ms', '2020-02-23 17:14:59', '2020-02-23 17:14:59');
INSERT INTO `t_sys_log` VALUES ('428', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '23 ms', '2020-02-23 17:16:02', '2020-02-23 17:16:02');
INSERT INTO `t_sys_log` VALUES ('429', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '26 ms', '2020-02-23 17:17:01', '2020-02-23 17:17:01');
INSERT INTO `t_sys_log` VALUES ('430', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '18 ms', '2020-02-23 17:17:30', '2020-02-23 17:17:30');
INSERT INTO `t_sys_log` VALUES ('431', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '25 ms', '2020-02-23 17:17:50', '2020-02-23 17:17:50');
INSERT INTO `t_sys_log` VALUES ('432', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '38 ms', '2020-02-23 17:30:33', '2020-02-23 17:30:33');
INSERT INTO `t_sys_log` VALUES ('433', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 17:30:33', '2020-02-23 17:30:33');
INSERT INTO `t_sys_log` VALUES ('434', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 17:30:35', '2020-02-23 17:30:35');
INSERT INTO `t_sys_log` VALUES ('435', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '8 ms', '2020-02-23 17:30:49', '2020-02-23 17:30:49');
INSERT INTO `t_sys_log` VALUES ('436', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '41 ms', '2020-02-23 17:30:52', '2020-02-23 17:30:52');
INSERT INTO `t_sys_log` VALUES ('437', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11 ms', '2020-02-23 17:30:52', '2020-02-23 17:30:52');
INSERT INTO `t_sys_log` VALUES ('438', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 17:30:56', '2020-02-23 17:30:56');
INSERT INTO `t_sys_log` VALUES ('439', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '13 ms', '2020-02-23 17:37:38', '2020-02-23 17:37:38');
INSERT INTO `t_sys_log` VALUES ('440', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 17:37:40', '2020-02-23 17:37:40');
INSERT INTO `t_sys_log` VALUES ('441', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 17:52:39', '2020-02-23 17:52:39');
INSERT INTO `t_sys_log` VALUES ('442', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 17:52:41', '2020-02-23 17:52:41');
INSERT INTO `t_sys_log` VALUES ('443', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '92 ms', '2020-02-23 17:56:35', '2020-02-23 17:56:35');
INSERT INTO `t_sys_log` VALUES ('444', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '8 ms', '2020-02-23 17:56:37', '2020-02-23 17:56:37');
INSERT INTO `t_sys_log` VALUES ('445', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_7ffe3b73-a77a-4e61-9be7-31ee55735981', '127.0.0.1', '1', '401', '1 ms', '2020-02-23 18:42:15', '2020-02-23 18:42:15');
INSERT INTO `t_sys_log` VALUES ('446', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '56 ms', '2020-02-23 18:54:06', '2020-02-23 18:54:06');
INSERT INTO `t_sys_log` VALUES ('447', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '24 ms', '2020-02-23 18:54:06', '2020-02-23 18:54:06');
INSERT INTO `t_sys_log` VALUES ('448', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 18:54:19', '2020-02-23 18:54:19');
INSERT INTO `t_sys_log` VALUES ('449', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '28 ms', '2020-02-23 18:54:51', '2020-02-23 18:54:51');
INSERT INTO `t_sys_log` VALUES ('450', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 18:54:53', '2020-02-23 18:54:53');
INSERT INTO `t_sys_log` VALUES ('451', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '34 ms', '2020-02-23 18:59:39', '2020-02-23 18:59:39');
INSERT INTO `t_sys_log` VALUES ('452', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:00:05', '2020-02-23 19:00:05');
INSERT INTO `t_sys_log` VALUES ('453', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 19:15:03', '2020-02-23 19:15:03');
INSERT INTO `t_sys_log` VALUES ('454', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '2', '200', '38 ms', '2020-02-23 19:15:23', '2020-02-23 19:15:23');
INSERT INTO `t_sys_log` VALUES ('455', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '2', '200', '19 ms', '2020-02-23 19:15:23', '2020-02-23 19:15:23');
INSERT INTO `t_sys_log` VALUES ('456', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '2', '200', '0 ms', '2020-02-23 19:15:39', '2020-02-23 19:15:39');
INSERT INTO `t_sys_log` VALUES ('457', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '2', '200', '4 ms', '2020-02-23 19:16:18', '2020-02-23 19:16:18');
INSERT INTO `t_sys_log` VALUES ('458', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '24 ms', '2020-02-23 19:16:25', '2020-02-23 19:16:25');
INSERT INTO `t_sys_log` VALUES ('459', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 19:16:25', '2020-02-23 19:16:25');
INSERT INTO `t_sys_log` VALUES ('460', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:16:38', '2020-02-23 19:16:38');
INSERT INTO `t_sys_log` VALUES ('461', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '2 ms', '2020-02-23 19:34:20', '2020-02-23 19:34:20');
INSERT INTO `t_sys_log` VALUES ('462', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '22 ms', '2020-02-23 19:34:29', '2020-02-23 19:34:29');
INSERT INTO `t_sys_log` VALUES ('463', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '14 ms', '2020-02-23 19:34:29', '2020-02-23 19:34:29');
INSERT INTO `t_sys_log` VALUES ('464', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:34:48', '2020-02-23 19:34:48');
INSERT INTO `t_sys_log` VALUES ('465', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 19:39:04', '2020-02-23 19:39:04');
INSERT INTO `t_sys_log` VALUES ('466', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '84 ms', '2020-02-23 19:39:08', '2020-02-23 19:39:08');
INSERT INTO `t_sys_log` VALUES ('467', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '199 ms', '2020-02-23 19:39:09', '2020-02-23 19:39:09');
INSERT INTO `t_sys_log` VALUES ('468', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:39:20', '2020-02-23 19:39:20');
INSERT INTO `t_sys_log` VALUES ('469', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '183 ms', '2020-02-23 19:40:55', '2020-02-23 19:40:55');
INSERT INTO `t_sys_log` VALUES ('470', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:42:02', '2020-02-23 19:42:02');
INSERT INTO `t_sys_log` VALUES ('471', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '3 ms', '2020-02-23 19:43:32', '2020-02-23 19:43:32');
INSERT INTO `t_sys_log` VALUES ('472', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 19:43:36', '2020-02-23 19:43:36');
INSERT INTO `t_sys_log` VALUES ('473', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '69284 ms', '2020-02-23 19:45:01', '2020-02-23 19:45:01');
INSERT INTO `t_sys_log` VALUES ('474', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:45:11', '2020-02-23 19:45:11');
INSERT INTO `t_sys_log` VALUES ('475', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '13417 ms', '2020-02-23 19:45:25', '2020-02-23 19:45:25');
INSERT INTO `t_sys_log` VALUES ('476', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:45:28', '2020-02-23 19:45:28');
INSERT INTO `t_sys_log` VALUES ('477', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '18 ms', '2020-02-23 19:45:28', '2020-02-23 19:45:28');
INSERT INTO `t_sys_log` VALUES ('478', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:45:32', '2020-02-23 19:45:32');
INSERT INTO `t_sys_log` VALUES ('479', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '3 ms', '2020-02-23 19:45:36', '2020-02-23 19:45:36');
INSERT INTO `t_sys_log` VALUES ('480', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 19:45:40', '2020-02-23 19:45:40');
INSERT INTO `t_sys_log` VALUES ('481', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '26 ms', '2020-02-23 19:45:40', '2020-02-23 19:45:40');
INSERT INTO `t_sys_log` VALUES ('482', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:45:50', '2020-02-23 19:45:50');
INSERT INTO `t_sys_log` VALUES ('483', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '2 ms', '2020-02-23 19:45:54', '2020-02-23 19:45:54');
INSERT INTO `t_sys_log` VALUES ('484', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '18 ms', '2020-02-23 19:46:06', '2020-02-23 19:46:06');
INSERT INTO `t_sys_log` VALUES ('485', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '13 ms', '2020-02-23 19:46:21', '2020-02-23 19:46:21');
INSERT INTO `t_sys_log` VALUES ('486', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 19:48:57', '2020-02-23 19:48:57');
INSERT INTO `t_sys_log` VALUES ('487', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 19:49:01', '2020-02-23 19:49:01');
INSERT INTO `t_sys_log` VALUES ('488', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '12 ms', '2020-02-23 19:49:09', '2020-02-23 19:49:09');
INSERT INTO `t_sys_log` VALUES ('489', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '24 ms', '2020-02-23 19:49:12', '2020-02-23 19:49:12');
INSERT INTO `t_sys_log` VALUES ('490', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '8 ms', '2020-02-23 19:59:59', '2020-02-23 19:59:59');
INSERT INTO `t_sys_log` VALUES ('491', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 20:00:08', '2020-02-23 20:00:08');
INSERT INTO `t_sys_log` VALUES ('492', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '43 ms', '2020-02-23 20:00:11', '2020-02-23 20:00:11');
INSERT INTO `t_sys_log` VALUES ('493', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '76 ms', '2020-02-23 20:00:11', '2020-02-23 20:00:11');
INSERT INTO `t_sys_log` VALUES ('494', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 20:00:15', '2020-02-23 20:00:15');
INSERT INTO `t_sys_log` VALUES ('495', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 20:00:18', '2020-02-23 20:00:18');
INSERT INTO `t_sys_log` VALUES ('496', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '31 ms', '2020-02-23 20:04:18', '2020-02-23 20:04:18');
INSERT INTO `t_sys_log` VALUES ('497', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '18 ms', '2020-02-23 20:04:18', '2020-02-23 20:04:18');
INSERT INTO `t_sys_log` VALUES ('498', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 20:14:06', '2020-02-23 20:14:06');
INSERT INTO `t_sys_log` VALUES ('499', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 20:14:06', '2020-02-23 20:14:06');
INSERT INTO `t_sys_log` VALUES ('500', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 20:14:08', '2020-02-23 20:14:08');
INSERT INTO `t_sys_log` VALUES ('501', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '3 ms', '2020-02-23 20:14:12', '2020-02-23 20:14:12');
INSERT INTO `t_sys_log` VALUES ('502', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '93 ms', '2020-02-23 20:30:17', '2020-02-23 20:30:17');
INSERT INTO `t_sys_log` VALUES ('503', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '90 ms', '2020-02-23 20:30:18', '2020-02-23 20:30:18');
INSERT INTO `t_sys_log` VALUES ('504', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 20:30:22', '2020-02-23 20:30:22');
INSERT INTO `t_sys_log` VALUES ('505', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 20:30:25', '2020-02-23 20:30:25');
INSERT INTO `t_sys_log` VALUES ('506', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '28 ms', '2020-02-23 20:30:36', '2020-02-23 20:30:36');
INSERT INTO `t_sys_log` VALUES ('507', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '18 ms', '2020-02-23 20:30:36', '2020-02-23 20:30:36');
INSERT INTO `t_sys_log` VALUES ('508', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_0cc5ee55-8be2-4674-ae88-32ae575594b8', '127.0.0.1', '0', '401', '4 ms', '2020-02-23 20:33:28', '2020-02-23 20:33:28');
INSERT INTO `t_sys_log` VALUES ('509', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '58 ms', '2020-02-23 20:33:33', '2020-02-23 20:33:33');
INSERT INTO `t_sys_log` VALUES ('510', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '91 ms', '2020-02-23 20:33:33', '2020-02-23 20:33:33');
INSERT INTO `t_sys_log` VALUES ('511', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '22 ms', '2020-02-23 20:39:30', '2020-02-23 20:39:30');
INSERT INTO `t_sys_log` VALUES ('512', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '20 ms', '2020-02-23 20:39:30', '2020-02-23 20:39:30');
INSERT INTO `t_sys_log` VALUES ('513', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 20:44:48', '2020-02-23 20:44:48');
INSERT INTO `t_sys_log` VALUES ('514', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '18 ms', '2020-02-23 20:44:48', '2020-02-23 20:44:48');
INSERT INTO `t_sys_log` VALUES ('515', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '28 ms', '2020-02-23 20:45:09', '2020-02-23 20:45:09');
INSERT INTO `t_sys_log` VALUES ('516', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '16 ms', '2020-02-23 20:45:12', '2020-02-23 20:45:12');
INSERT INTO `t_sys_log` VALUES ('517', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '31 ms', '2020-02-23 20:45:14', '2020-02-23 20:45:14');
INSERT INTO `t_sys_log` VALUES ('518', '获取系统管理 - 日志表列表分页', 'http://127.0.0.1:9001/api/system/log/listPage', '127.0.0.1', '1', '200', '22 ms', '2020-02-23 20:45:16', '2020-02-23 20:45:16');
INSERT INTO `t_sys_log` VALUES ('519', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 20:45:18', '2020-02-23 20:45:18');
INSERT INTO `t_sys_log` VALUES ('520', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 20:45:18', '2020-02-23 20:45:18');
INSERT INTO `t_sys_log` VALUES ('521', '获取系统管理-用户基础信息表列表分页', 'http://127.0.0.1:9001/api/system/user/listPage', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 20:45:20', '2020-02-23 20:45:20');
INSERT INTO `t_sys_log` VALUES ('522', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_cf5e67a8-7b72-4c68-9bc9-0f7c6322b890', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 20:48:07', '2020-02-23 20:48:07');
INSERT INTO `t_sys_log` VALUES ('523', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 20:48:10', '2020-02-23 20:48:10');
INSERT INTO `t_sys_log` VALUES ('524', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 20:48:10', '2020-02-23 20:48:10');
INSERT INTO `t_sys_log` VALUES ('525', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 20:48:32', '2020-02-23 20:48:32');
INSERT INTO `t_sys_log` VALUES ('526', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 20:57:18', '2020-02-23 20:57:18');
INSERT INTO `t_sys_log` VALUES ('527', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 20:58:49', '2020-02-23 20:58:49');
INSERT INTO `t_sys_log` VALUES ('528', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '1 ms', '2020-02-23 21:01:07', '2020-02-23 21:01:07');
INSERT INTO `t_sys_log` VALUES ('529', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 21:07:08', '2020-02-23 21:07:08');
INSERT INTO `t_sys_log` VALUES ('530', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 21:26:51', '2020-02-23 21:26:51');
INSERT INTO `t_sys_log` VALUES ('531', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 21:30:54', '2020-02-23 21:30:54');
INSERT INTO `t_sys_log` VALUES ('532', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 21:33:32', '2020-02-23 21:33:32');
INSERT INTO `t_sys_log` VALUES ('533', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 21:33:50', '2020-02-23 21:33:50');
INSERT INTO `t_sys_log` VALUES ('534', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 21:34:37', '2020-02-23 21:34:37');
INSERT INTO `t_sys_log` VALUES ('535', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 21:35:37', '2020-02-23 21:35:37');
INSERT INTO `t_sys_log` VALUES ('536', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '135 ms', '2020-02-23 21:50:33', '2020-02-23 21:50:33');
INSERT INTO `t_sys_log` VALUES ('537', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11642 ms', '2020-02-23 21:50:45', '2020-02-23 21:50:45');
INSERT INTO `t_sys_log` VALUES ('538', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 21:50:50', '2020-02-23 21:50:50');
INSERT INTO `t_sys_log` VALUES ('539', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '6121 ms', '2020-02-23 21:50:56', '2020-02-23 21:50:56');
INSERT INTO `t_sys_log` VALUES ('540', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '34 ms', '2020-02-23 21:53:04', '2020-02-23 21:53:04');
INSERT INTO `t_sys_log` VALUES ('541', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '20 ms', '2020-02-23 21:53:05', '2020-02-23 21:53:05');
INSERT INTO `t_sys_log` VALUES ('542', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '33 ms', '2020-02-23 21:53:14', '2020-02-23 21:53:14');
INSERT INTO `t_sys_log` VALUES ('543', '保存菜单 ', 'http://127.0.0.1:9001/api/system/menu/save', '127.0.0.1', '1', '200', '61 ms', '2020-02-23 21:55:10', '2020-02-23 21:55:10');
INSERT INTO `t_sys_log` VALUES ('544', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '24 ms', '2020-02-23 21:55:10', '2020-02-23 21:55:10');
INSERT INTO `t_sys_log` VALUES ('545', '保存菜单 ', 'http://127.0.0.1:9001/api/system/menu/save', '127.0.0.1', '1', '200', '46 ms', '2020-02-23 21:58:56', '2020-02-23 21:58:56');
INSERT INTO `t_sys_log` VALUES ('546', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '9 ms', '2020-02-23 21:58:56', '2020-02-23 21:58:56');
INSERT INTO `t_sys_log` VALUES ('547', '保存菜单 ', 'http://127.0.0.1:9001/api/system/menu/save', '127.0.0.1', '1', '200', '91 ms', '2020-02-23 21:59:26', '2020-02-23 21:59:26');
INSERT INTO `t_sys_log` VALUES ('548', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 21:59:26', '2020-02-23 21:59:26');
INSERT INTO `t_sys_log` VALUES ('549', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '37 ms', '2020-02-23 21:59:40', '2020-02-23 21:59:40');
INSERT INTO `t_sys_log` VALUES ('550', '获取角色信息', 'http://127.0.0.1:9001/api/system/role/detail', '127.0.0.1', '1', '200', '6 ms', '2020-02-23 21:59:54', '2020-02-23 21:59:54');
INSERT INTO `t_sys_log` VALUES ('551', '获取用户树', 'http://127.0.0.1:9001/api/system/user/treeUser', '127.0.0.1', '1', '200', '9600 ms', '2020-02-23 21:59:54', '2020-02-23 21:59:54');
INSERT INTO `t_sys_log` VALUES ('552', '获取系统管理 - 角色-菜单关联表 列表', 'http://127.0.0.1:9001/api/system/roleMenu/list', '127.0.0.1', '1', '200', '9660 ms', '2020-02-23 21:59:54', '2020-02-23 21:59:54');
INSERT INTO `t_sys_log` VALUES ('553', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '68 ms', '2020-02-23 21:59:54', '2020-02-23 21:59:54');
INSERT INTO `t_sys_log` VALUES ('554', '获取系统管理 - 用户角色关联表 列表', 'http://127.0.0.1:9001/api/system/userRole/list', '127.0.0.1', '1', '200', '123 ms', '2020-02-23 21:59:54', '2020-02-23 21:59:54');
INSERT INTO `t_sys_log` VALUES ('555', '保存角色相关联菜单', 'http://127.0.0.1:9001/api/system/roleMenu/saveRoleMenu', '127.0.0.1', '1', '200', '128 ms', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_log` VALUES ('556', '获取系统管理-角色表 列表分页', 'http://127.0.0.1:9001/api/system/role/listPage', '127.0.0.1', '1', '200', '3 ms', '2020-02-23 22:00:18', '2020-02-23 22:00:18');
INSERT INTO `t_sys_log` VALUES ('557', '获取菜单树', 'http://127.0.0.1:9001/api/system/menu/treeMenu', '127.0.0.1', '1', '200', '7 ms', '2020-02-23 22:00:22', '2020-02-23 22:00:22');
INSERT INTO `t_sys_log` VALUES ('558', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_baf8f4c9-0591-40e4-8fba-9cd72ce9ff96', '127.0.0.1', '0', '401', '0 ms', '2020-02-23 22:01:21', '2020-02-23 22:01:21');
INSERT INTO `t_sys_log` VALUES ('559', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '28 ms', '2020-02-23 22:01:24', '2020-02-23 22:01:24');
INSERT INTO `t_sys_log` VALUES ('560', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11 ms', '2020-02-23 22:01:24', '2020-02-23 22:01:24');
INSERT INTO `t_sys_log` VALUES ('561', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '12 ms', '2020-02-23 22:02:20', '2020-02-23 22:02:20');
INSERT INTO `t_sys_log` VALUES ('562', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 22:02:22', '2020-02-23 22:02:22');
INSERT INTO `t_sys_log` VALUES ('563', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '323057 ms', '2020-02-23 22:07:45', '2020-02-23 22:07:45');
INSERT INTO `t_sys_log` VALUES ('564', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 22:07:49', '2020-02-23 22:07:49');
INSERT INTO `t_sys_log` VALUES ('565', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '3938 ms', '2020-02-23 22:07:53', '2020-02-23 22:07:53');
INSERT INTO `t_sys_log` VALUES ('566', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '5 ms', '2020-02-23 22:13:13', '2020-02-23 22:13:13');
INSERT INTO `t_sys_log` VALUES ('567', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '13 ms', '2020-02-23 22:13:16', '2020-02-23 22:13:16');
INSERT INTO `t_sys_log` VALUES ('568', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 22:13:16', '2020-02-23 22:13:16');
INSERT INTO `t_sys_log` VALUES ('569', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '23 ms', '2020-02-23 22:16:19', '2020-02-23 22:16:19');
INSERT INTO `t_sys_log` VALUES ('570', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '22 ms', '2020-02-23 22:17:06', '2020-02-23 22:17:06');
INSERT INTO `t_sys_log` VALUES ('571', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '24 ms', '2020-02-23 22:17:14', '2020-02-23 22:17:14');
INSERT INTO `t_sys_log` VALUES ('572', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 22:20:18', '2020-02-23 22:20:18');
INSERT INTO `t_sys_log` VALUES ('573', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 22:20:18', '2020-02-23 22:20:18');
INSERT INTO `t_sys_log` VALUES ('574', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '0 ms', '2020-02-23 22:20:23', '2020-02-23 22:20:23');
INSERT INTO `t_sys_log` VALUES ('575', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 22:20:23', '2020-02-23 22:20:23');
INSERT INTO `t_sys_log` VALUES ('576', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '3 ms', '2020-02-23 22:20:51', '2020-02-23 22:20:51');
INSERT INTO `t_sys_log` VALUES ('577', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '15 ms', '2020-02-23 22:20:55', '2020-02-23 22:20:55');
INSERT INTO `t_sys_log` VALUES ('578', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 22:20:55', '2020-02-23 22:20:55');
INSERT INTO `t_sys_log` VALUES ('579', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '19 ms', '2020-02-23 22:23:11', '2020-02-23 22:23:11');
INSERT INTO `t_sys_log` VALUES ('580', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '4 ms', '2020-02-23 22:24:23', '2020-02-23 22:24:23');
INSERT INTO `t_sys_log` VALUES ('581', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '13 ms', '2020-02-23 22:24:26', '2020-02-23 22:24:26');
INSERT INTO `t_sys_log` VALUES ('582', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 22:24:26', '2020-02-23 22:24:26');
INSERT INTO `t_sys_log` VALUES ('583', '退出系统', 'http://127.0.0.1:9001/api/auth/logout', '127.0.0.1', '1', '200', '27 ms', '2020-02-23 22:24:36', '2020-02-23 22:24:36');
INSERT INTO `t_sys_log` VALUES ('584', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '11 ms', '2020-02-23 22:25:32', '2020-02-23 22:25:32');
INSERT INTO `t_sys_log` VALUES ('585', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '10 ms', '2020-02-23 22:25:33', '2020-02-23 22:25:33');
INSERT INTO `t_sys_log` VALUES ('586', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '116 ms', '2020-02-25 09:55:29', '2020-02-25 09:55:29');
INSERT INTO `t_sys_log` VALUES ('587', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '92 ms', '2020-02-25 10:05:44', '2020-02-25 10:05:44');
INSERT INTO `t_sys_log` VALUES ('588', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '89 ms', '2020-02-25 10:05:44', '2020-02-25 10:05:44');
INSERT INTO `t_sys_log` VALUES ('589', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '89 ms', '2020-02-25 10:37:23', '2020-02-25 10:37:23');
INSERT INTO `t_sys_log` VALUES ('590', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_b43dbe88-0159-4146-80af-d6385fee048f', '127.0.0.1', '1', '401', '6 ms', '2020-02-25 13:00:22', '2020-02-25 13:00:22');
INSERT INTO `t_sys_log` VALUES ('591', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '25 ms', '2020-02-25 13:00:26', '2020-02-25 13:00:26');
INSERT INTO `t_sys_log` VALUES ('592', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '72 ms', '2020-02-25 13:00:26', '2020-02-25 13:00:26');
INSERT INTO `t_sys_log` VALUES ('593', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '108 ms', '2020-02-25 14:32:48', '2020-02-25 14:32:48');
INSERT INTO `t_sys_log` VALUES ('594', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-25 14:33:40', '2020-02-25 14:33:40');
INSERT INTO `t_sys_log` VALUES ('595', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-02-25 14:35:10', '2020-02-25 14:35:10');
INSERT INTO `t_sys_log` VALUES ('596', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11 ms', '2020-02-25 14:37:28', '2020-02-25 14:37:28');
INSERT INTO `t_sys_log` VALUES ('597', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11 ms', '2020-02-25 14:43:43', '2020-02-25 14:43:43');
INSERT INTO `t_sys_log` VALUES ('598', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11 ms', '2020-02-25 14:43:53', '2020-02-25 14:43:53');
INSERT INTO `t_sys_log` VALUES ('599', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '9 ms', '2020-02-25 14:45:55', '2020-02-25 14:45:55');
INSERT INTO `t_sys_log` VALUES ('600', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '107 ms', '2020-02-25 14:54:52', '2020-02-25 14:54:52');
INSERT INTO `t_sys_log` VALUES ('601', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '19 ms', '2020-02-25 15:02:05', '2020-02-25 15:02:05');
INSERT INTO `t_sys_log` VALUES ('602', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '106 ms', '2020-02-25 15:08:32', '2020-02-25 15:08:32');
INSERT INTO `t_sys_log` VALUES ('603', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '17 ms', '2020-02-25 15:10:11', '2020-02-25 15:10:11');
INSERT INTO `t_sys_log` VALUES ('604', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '113 ms', '2020-02-25 15:15:46', '2020-02-25 15:15:46');
INSERT INTO `t_sys_log` VALUES ('605', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-25 15:19:06', '2020-02-25 15:19:06');
INSERT INTO `t_sys_log` VALUES ('606', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '15 ms', '2020-02-25 15:19:19', '2020-02-25 15:19:19');
INSERT INTO `t_sys_log` VALUES ('607', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_58c164b1-d31e-486f-8aba-3203866ea307', '127.0.0.1', '1', '401', '7 ms', '2020-02-25 16:11:44', '2020-02-25 16:11:44');
INSERT INTO `t_sys_log` VALUES ('608', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_30e2c652-ed6f-41c4-9676-bfb321b46823', '127.0.0.1', '1', '401', '0 ms', '2020-02-25 16:11:45', '2020-02-25 16:11:45');
INSERT INTO `t_sys_log` VALUES ('609', '登录系统', 'http://127.0.0.1:9001/api/auth/login', '127.0.0.1', '1', '200', '29 ms', '2020-02-25 16:11:49', '2020-02-25 16:11:49');
INSERT INTO `t_sys_log` VALUES ('610', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '10 ms', '2020-02-25 16:11:49', '2020-02-25 16:11:49');
INSERT INTO `t_sys_log` VALUES ('611', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '111 ms', '2020-02-25 16:40:23', '2020-02-25 16:40:23');
INSERT INTO `t_sys_log` VALUES ('612', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '13 ms', '2020-02-25 16:40:28', '2020-02-25 16:40:28');
INSERT INTO `t_sys_log` VALUES ('613', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_dc269d61-223a-43fb-ba1a-d8fd46ec7f21', '127.0.0.1', '0', '401', '4 ms', '2020-02-25 16:40:37', '2020-02-25 16:40:37');
INSERT INTO `t_sys_log` VALUES ('614', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '14 ms', '2020-02-25 16:42:33', '2020-02-25 16:42:33');
INSERT INTO `t_sys_log` VALUES ('615', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_460a1b75-96fe-4c5c-8254-b7eda6efc3e3', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 16:42:41', '2020-02-25 16:42:41');
INSERT INTO `t_sys_log` VALUES ('616', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '104 ms', '2020-02-25 16:57:58', '2020-02-25 16:57:58');
INSERT INTO `t_sys_log` VALUES ('617', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_b96730b8-8057-4343-91ae-48c0d824fc9a', '127.0.0.1', '0', '401', '5 ms', '2020-02-25 16:58:06', '2020-02-25 16:58:06');
INSERT INTO `t_sys_log` VALUES ('618', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '22 ms', '2020-02-25 16:58:47', '2020-02-25 16:58:47');
INSERT INTO `t_sys_log` VALUES ('619', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_1fe9bf9b-cd15-4f72-b17a-f495529a50d7', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 16:58:58', '2020-02-25 16:58:58');
INSERT INTO `t_sys_log` VALUES ('620', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '13 ms', '2020-02-25 16:59:43', '2020-02-25 16:59:43');
INSERT INTO `t_sys_log` VALUES ('621', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_63051c1e-fcfc-4317-afc8-9d672348976c', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 17:00:16', '2020-02-25 17:00:16');
INSERT INTO `t_sys_log` VALUES ('622', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-02-25 17:02:07', '2020-02-25 17:02:07');
INSERT INTO `t_sys_log` VALUES ('623', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_78384b79-37bf-47f3-ab2e-8fcf383e3c3a', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 17:02:22', '2020-02-25 17:02:22');
INSERT INTO `t_sys_log` VALUES ('624', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11 ms', '2020-02-25 17:03:01', '2020-02-25 17:03:01');
INSERT INTO `t_sys_log` VALUES ('625', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_8d281b5c-b2c2-4450-adcc-08e4fb203475', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 17:03:06', '2020-02-25 17:03:06');
INSERT INTO `t_sys_log` VALUES ('626', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-02-25 17:03:54', '2020-02-25 17:03:54');
INSERT INTO `t_sys_log` VALUES ('627', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_e3b2c77b-2746-46ab-9419-afa1dcdacd8e', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 17:04:05', '2020-02-25 17:04:05');
INSERT INTO `t_sys_log` VALUES ('628', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '10 ms', '2020-02-25 17:04:25', '2020-02-25 17:04:25');
INSERT INTO `t_sys_log` VALUES ('629', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '9 ms', '2020-02-25 17:04:28', '2020-02-25 17:04:28');
INSERT INTO `t_sys_log` VALUES ('630', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_c78a8c04-ee21-4ec3-905d-f8b3d9b9ae6a', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 17:04:41', '2020-02-25 17:04:41');
INSERT INTO `t_sys_log` VALUES ('631', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-25 17:05:46', '2020-02-25 17:05:46');
INSERT INTO `t_sys_log` VALUES ('632', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_1b1c56cb-df8d-4328-a01d-09ee46ebfe47', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 17:05:51', '2020-02-25 17:05:51');
INSERT INTO `t_sys_log` VALUES ('633', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '7 ms', '2020-02-25 17:06:33', '2020-02-25 17:06:33');
INSERT INTO `t_sys_log` VALUES ('634', '未登录', 'http://127.0.0.1:9001/api/auth/unLogin;JSESSIONID=Study-Api_token_ea0d877b-f4dc-4a0f-8ce7-3353918a5cf3', '127.0.0.1', '0', '401', '0 ms', '2020-02-25 17:07:05', '2020-02-25 17:07:05');
INSERT INTO `t_sys_log` VALUES ('635', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-25 17:07:35', '2020-02-25 17:07:35');
INSERT INTO `t_sys_log` VALUES ('636', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-25 17:18:04', '2020-02-25 17:18:04');
INSERT INTO `t_sys_log` VALUES ('637', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '9 ms', '2020-02-25 17:30:23', '2020-02-25 17:30:23');
INSERT INTO `t_sys_log` VALUES ('638', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-25 17:30:26', '2020-02-25 17:30:26');
INSERT INTO `t_sys_log` VALUES ('639', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '9 ms', '2020-02-25 17:33:32', '2020-02-25 17:33:32');
INSERT INTO `t_sys_log` VALUES ('640', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-02-25 17:34:27', '2020-02-25 17:34:27');
INSERT INTO `t_sys_log` VALUES ('641', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '12 ms', '2020-02-25 17:35:42', '2020-02-25 17:35:42');
INSERT INTO `t_sys_log` VALUES ('642', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-25 17:37:15', '2020-02-25 17:37:15');
INSERT INTO `t_sys_log` VALUES ('643', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-25 17:37:19', '2020-02-25 17:37:19');
INSERT INTO `t_sys_log` VALUES ('644', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '11 ms', '2020-02-25 17:37:38', '2020-02-25 17:37:38');
INSERT INTO `t_sys_log` VALUES ('645', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '9 ms', '2020-02-25 17:40:48', '2020-02-25 17:40:48');
INSERT INTO `t_sys_log` VALUES ('646', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '16 ms', '2020-02-25 17:44:46', '2020-02-25 17:44:46');
INSERT INTO `t_sys_log` VALUES ('647', '获取当前登录用户信息', 'http://127.0.0.1:9001/api/system/user/getCurrentUserInfo', '127.0.0.1', '1', '200', '8 ms', '2020-02-25 17:55:51', '2020-02-25 17:55:51');

-- ----------------------------
-- Table structure for t_sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_menu`;
CREATE TABLE `t_sys_menu` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` varchar(32) DEFAULT NULL COMMENT '上级资源ID',
  `url` varchar(255) DEFAULT NULL COMMENT 'url',
  `resources` varchar(255) DEFAULT NULL COMMENT '资源编码',
  `title` varchar(100) DEFAULT NULL COMMENT '资源名称',
  `level` int(11) DEFAULT NULL COMMENT '资源级别',
  `sort_no` int(11) DEFAULT NULL COMMENT '排序',
  `icon` varchar(32) DEFAULT NULL COMMENT '资源图标',
  `type` varchar(32) DEFAULT NULL COMMENT '类型 menu、button',
  `remarks` varchar(500) DEFAULT NULL COMMENT '备注',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理-权限资源表 ';

-- ----------------------------
-- Records of t_sys_menu
-- ----------------------------
INSERT INTO `t_sys_menu` VALUES ('1', '0', null, 'systemManage', 'systemManage', '1', '3', 'component', 'menu', '', '2019-03-28 18:51:08', '2019-03-28 18:51:10');
INSERT INTO `t_sys_menu` VALUES ('2', '1', '/system/user/listPage', 'user', 'userManage', '2', '1', 'my-user', 'menu', '', '2019-03-28 18:52:13', '2019-08-31 21:26:57');
INSERT INTO `t_sys_menu` VALUES ('3', '2', null, 'sys:user:add', '添加', '3', '1', 'el-icon-edit', 'button', '', '2019-03-28 18:53:31', '2019-04-01 20:19:55');
INSERT INTO `t_sys_menu` VALUES ('4', '2', null, 'sys:user:edit', '编辑', '3', '2', null, 'button', '', '2019-03-28 18:54:26', '2019-04-01 20:20:16');
INSERT INTO `t_sys_menu` VALUES ('5', '2', '/system/user/delete', 'sys:user:delete', '删除', '3', '3', null, 'button', '', '2019-03-28 18:55:25', '2019-04-01 20:20:09');
INSERT INTO `t_sys_menu` VALUES ('13', '0', null, 'codeGenerator', '代码生成器', '1', '2', 'table', 'menu', '', '2019-03-30 13:54:43', '2019-09-07 21:06:55');
INSERT INTO `t_sys_menu` VALUES ('15', '13', '/code/project/listPage', 'project', '项目管理', '1', '1', 'icon-news', 'menu', '', '2019-03-30 13:58:00', '2019-09-01 15:01:58');
INSERT INTO `t_sys_menu` VALUES ('16', '1', '/system/role/listPage', 'role', 'roleManage', '2', '2', 'my-role', 'menu', '', '2019-03-30 14:00:03', '2019-03-30 14:20:59');
INSERT INTO `t_sys_menu` VALUES ('17', '1', '/system/menu/treeMenu', 'menu', 'menuManage', '2', '3', 'my-sysmenu', 'menu', '', '2019-03-30 14:00:53', '2019-03-30 14:21:10');
INSERT INTO `t_sys_menu` VALUES ('43', '16', null, 'sys:role:add', '添加', '3', '1', '', 'button', '', '2019-04-01 20:20:46', '2019-04-01 20:20:46');
INSERT INTO `t_sys_menu` VALUES ('44', '16', null, 'sys:role:edit', '编辑', '3', '2', '', 'button', '', '2019-04-01 20:21:03', '2019-04-01 20:21:03');
INSERT INTO `t_sys_menu` VALUES ('45', '16', null, 'roleSetting', '权限设置', '3', '3', '', 'button', '', '2019-04-01 20:21:24', '2019-04-01 20:21:24');
INSERT INTO `t_sys_menu` VALUES ('46', '16', '/system/role/delete', 'sys:role:delete', '删除', '3', '4', '', 'button', '', '2019-04-01 20:21:55', '2019-04-01 20:21:55');
INSERT INTO `t_sys_menu` VALUES ('47', '17', '', 'sys:menu:add', '添加', '3', '1', '', 'button', '', '2019-04-01 20:22:31', '2019-04-01 20:22:31');
INSERT INTO `t_sys_menu` VALUES ('48', '17', null, 'sys:menu:addsub', '添加下级', '3', '2', '', 'button', '', '2019-04-01 20:23:00', '2019-04-01 20:23:00');
INSERT INTO `t_sys_menu` VALUES ('49', '17', null, 'sys:menu:edit', '编辑', '3', '3', '', 'button', '', '2019-04-01 20:23:28', '2019-04-01 20:23:28');
INSERT INTO `t_sys_menu` VALUES ('50', '17', '/system/menu/delete', 'sys:menu:delete', '删除', '3', '4', '', 'button', '', '2019-04-01 20:23:46', '2019-04-01 20:23:46');
INSERT INTO `t_sys_menu` VALUES ('53', '13', '/code/bsTemplate/listPage', 'bs_template', '初始模板', '2', '2', 'icon-news', 'menu', null, '2019-09-01 15:01:42', '2019-09-01 15:02:05');
INSERT INTO `t_sys_menu` VALUES ('54', '13', '/code/project_template/listPage', 'project_template', '项目模板管理', '3', '3', 'documentation', 'menu', null, '2019-09-01 15:03:02', '2019-09-01 15:03:02');
INSERT INTO `t_sys_menu` VALUES ('55', '13', '/code/database/listPage', 'database', '数据库管理', '4', '4', 'icon-news', 'menu', null, '2019-09-01 15:04:09', '2019-09-01 15:11:25');
INSERT INTO `t_sys_menu` VALUES ('56', '55', '/code/database/tableList', 'table', '是否显示数据库表', '3', '4', null, 'button', null, '2019-09-01 15:10:34', '2019-09-13 03:27:56');
INSERT INTO `t_sys_menu` VALUES ('57', '55', '/code/database/columnList', 'column', '是否显示数据表字段信息', '3', '5', null, 'button', null, '2019-09-01 15:11:12', '2019-09-13 03:38:31');
INSERT INTO `t_sys_menu` VALUES ('59', '15', null, 'code:project:add', '新建一个项目', '3', '1', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('60', '15', null, 'code:project:edit', '编辑项目', '3', '2', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('61', '15', null, 'code:projectPackage:showTree', '是否显示项目树形包', '3', '3', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('62', '15', null, 'code:project:delete', '删除项目', '3', '4', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('63', '15', null, 'code:projectPackage:add', '添加项目包', '2', '5', null, 'button', null, '2019-09-12 11:17:54', '2019-09-12 11:17:54');
INSERT INTO `t_sys_menu` VALUES ('64', '15', null, 'code:projectPackage:edit', '编辑项目包', '2', '6', null, 'button', null, '2019-09-12 11:19:49', '2019-09-12 11:19:49');
INSERT INTO `t_sys_menu` VALUES ('65', '15', null, 'code:projectPackage:delete', '删除项目包', '2', '7', null, 'button', null, '2019-09-12 11:22:18', '2019-09-12 11:22:18');
INSERT INTO `t_sys_menu` VALUES ('66', '54', null, 'code:projectTemplate:add', '添加项目模板', '4', '1', null, 'button', null, '2019-09-12 22:24:14', '2019-09-12 22:24:14');
INSERT INTO `t_sys_menu` VALUES ('67', '54', null, 'code:projectTemplate:delete', '删除项目模板', '4', '2', null, 'button', null, '2019-09-12 22:25:26', '2019-09-12 22:25:26');
INSERT INTO `t_sys_menu` VALUES ('68', '54', null, 'code:projectTemplate:edit', '编辑项目模板', '4', '3', null, 'button', null, '2019-09-12 22:27:15', '2019-09-12 22:27:15');
INSERT INTO `t_sys_menu` VALUES ('69', '53', null, 'code:bsTemplate:add', '添加初始模板', '3', '1', null, 'button', null, '2019-09-12 22:53:00', '2019-09-12 22:53:00');
INSERT INTO `t_sys_menu` VALUES ('70', '53', null, 'code:bsTemplate:edit', '编辑初始模板', '3', '2', null, 'button', null, '2019-09-12 22:53:49', '2019-09-12 22:53:49');
INSERT INTO `t_sys_menu` VALUES ('71', '53', null, 'code:bsTemplate:delete', '删除初始模板', '3', '3', null, 'button', null, '2019-09-12 22:54:34', '2019-09-12 22:54:34');
INSERT INTO `t_sys_menu` VALUES ('72', '55', null, 'code:database:add', '添加数据库信息', '5', '1', null, 'button', null, '2019-09-13 03:20:45', '2019-09-13 03:21:17');
INSERT INTO `t_sys_menu` VALUES ('73', '55', null, 'code:database:edit', '编辑数据库信息', '5', '2', null, 'button', null, '2019-09-13 03:28:25', '2019-09-13 03:28:25');
INSERT INTO `t_sys_menu` VALUES ('74', '55', null, 'code:database:delete', '删除数据库', '5', '3', null, 'button', null, '2019-09-13 03:28:53', '2019-09-13 03:28:53');
INSERT INTO `t_sys_menu` VALUES ('75', '55', null, 'code:column:update', '修改表字段信息', '5', '6', null, 'button', null, '2019-09-13 03:41:46', '2019-09-13 03:41:46');
INSERT INTO `t_sys_menu` VALUES ('76', '55', null, 'generateCode', '生成代码', '5', '7', null, 'button', null, '2019-09-13 03:45:12', '2019-09-13 03:45:12');
INSERT INTO `t_sys_menu` VALUES ('77', '54', null, 'code:projectTemplate:showVelocityContext', '是否显示参考模板数据源配置信息', '4', '4', null, 'button', '是否显示参考模板数据源配置信息', '2019-09-17 17:45:09', '2019-09-17 17:45:09');
INSERT INTO `t_sys_menu` VALUES ('78', '54', null, 'code:projectTemplate:generateTemplate', '生成项目模板', '4', '5', null, 'button', '生成项目模板', '2019-09-17 17:46:12', '2019-09-17 17:46:12');
INSERT INTO `t_sys_menu` VALUES ('79', '1', '/system/log', 'log', 'systemLog', '2', '4', 'my-sysmenu', 'menu', '', '2019-03-30 14:00:53', '2019-09-18 14:21:38');
INSERT INTO `t_sys_menu` VALUES ('80', '2', '/system/user/updatePersonalInfo', 'sys:user:editPersonalInfo', '修改个人信息', '3', '4', null, 'button', null, '2019-09-18 21:05:51', '2019-09-18 22:40:45');
INSERT INTO `t_sys_menu` VALUES ('81', '0', null, 'contentManage', 'contentManage', '1', '1', 'form', 'menu', null, '2020-02-23 21:55:10', '2020-02-23 21:55:10');
INSERT INTO `t_sys_menu` VALUES ('82', '81', '/content/category/listPage', 'categoryManage', 'categoryManage', '2', '1', 'excel', 'menu', null, '2020-02-23 21:58:56', '2020-02-23 21:58:56');
INSERT INTO `t_sys_menu` VALUES ('83', '81', '/content/file/listPage', 'fileManage', 'fileManage', '2', '2', 'my-file', 'menu', null, '2020-02-23 21:59:26', '2020-02-23 21:59:26');

-- ----------------------------
-- Table structure for t_sys_role
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_role`;
CREATE TABLE `t_sys_role` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` varchar(50) DEFAULT NULL COMMENT '角色编码',
  `name` varchar(50) DEFAULT NULL COMMENT '角色名称',
  `remarks` varchar(500) DEFAULT NULL COMMENT '角色描述',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理-角色表 ';

-- ----------------------------
-- Records of t_sys_role
-- ----------------------------
INSERT INTO `t_sys_role` VALUES ('1', 'admin', '系统管理员', '系统管理员', '2019-03-28 15:51:56', '2020-02-23 16:35:38');
INSERT INTO `t_sys_role` VALUES ('2', 'visitor', '访客', '访客', '2019-03-28 20:17:04', '2019-09-09 16:32:15');

-- ----------------------------
-- Table structure for t_sys_role_file
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_role_file`;
CREATE TABLE `t_sys_role_file` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int(10) DEFAULT NULL COMMENT '角色ID',
  `user_id` int(11) DEFAULT NULL COMMENT '用户ID',
  `file_id` int(10) DEFAULT NULL COMMENT '菜单ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1583 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理 - 角色-权限资源关联表 ';

-- ----------------------------
-- Records of t_sys_role_file
-- ----------------------------
INSERT INTO `t_sys_role_file` VALUES ('1578', '1', null, '1', '2020-02-25 09:22:16', '2020-02-25 09:22:18');
INSERT INTO `t_sys_role_file` VALUES ('1579', '1', null, '2', '2020-02-25 09:22:26', '2020-02-25 09:22:28');
INSERT INTO `t_sys_role_file` VALUES ('1580', '1', null, '3', '2020-02-25 09:22:37', '2020-02-25 09:22:38');
INSERT INTO `t_sys_role_file` VALUES ('1581', '1', null, '4', '2020-02-25 09:22:48', '2020-02-25 09:22:50');
INSERT INTO `t_sys_role_file` VALUES ('1582', null, '1', '4', '2020-02-25 09:23:01', '2020-02-25 09:23:03');

-- ----------------------------
-- Table structure for t_sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_role_menu`;
CREATE TABLE `t_sys_role_menu` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int(10) DEFAULT NULL COMMENT '角色ID',
  `menu_id` int(10) DEFAULT NULL COMMENT '菜单ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1625 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理 - 角色-权限资源关联表 ';

-- ----------------------------
-- Records of t_sys_role_menu
-- ----------------------------
INSERT INTO `t_sys_role_menu` VALUES ('1551', '2', '13', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1552', '2', '15', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1553', '2', '59', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1554', '2', '60', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1555', '2', '61', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1556', '2', '62', '2019-09-18 21:26:42', '2019-09-18 21:26:42');
INSERT INTO `t_sys_role_menu` VALUES ('1557', '2', '63', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1558', '2', '64', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1559', '2', '65', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1560', '2', '53', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1561', '2', '69', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1562', '2', '70', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1563', '2', '71', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1564', '2', '54', '2019-09-18 21:26:43', '2019-09-18 21:26:43');
INSERT INTO `t_sys_role_menu` VALUES ('1565', '2', '66', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1566', '2', '67', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1567', '2', '68', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1568', '2', '77', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1569', '2', '78', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1570', '2', '55', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1571', '2', '72', '2019-09-18 21:26:44', '2019-09-18 21:26:44');
INSERT INTO `t_sys_role_menu` VALUES ('1572', '2', '73', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1573', '2', '56', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1574', '2', '57', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1575', '2', '75', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1576', '2', '76', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1577', '2', '80', '2019-09-18 21:26:45', '2019-09-18 21:26:45');
INSERT INTO `t_sys_role_menu` VALUES ('1578', '1', '81', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1579', '1', '82', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1580', '1', '83', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1581', '1', '13', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1582', '1', '15', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1583', '1', '59', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1584', '1', '60', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1585', '1', '61', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1586', '1', '62', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1587', '1', '63', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1588', '1', '64', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1589', '1', '65', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1590', '1', '53', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1591', '1', '69', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1592', '1', '70', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1593', '1', '71', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1594', '1', '54', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1595', '1', '66', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1596', '1', '67', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1597', '1', '68', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1598', '1', '77', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1599', '1', '78', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1600', '1', '55', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1601', '1', '72', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1602', '1', '73', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1603', '1', '74', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1604', '1', '56', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1605', '1', '57', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1606', '1', '75', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1607', '1', '76', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1608', '1', '1', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1609', '1', '2', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1610', '1', '3', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1611', '1', '4', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1612', '1', '5', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1613', '1', '80', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1614', '1', '16', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1615', '1', '43', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1616', '1', '44', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1617', '1', '45', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1618', '1', '46', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1619', '1', '17', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1620', '1', '47', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1621', '1', '48', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1622', '1', '49', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1623', '1', '50', '2020-02-23 22:00:12', '2020-02-23 22:00:12');
INSERT INTO `t_sys_role_menu` VALUES ('1624', '1', '79', '2020-02-23 22:00:12', '2020-02-23 22:00:12');

-- ----------------------------
-- Table structure for t_sys_user
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_user`;
CREATE TABLE `t_sys_user` (
  `id` int(64) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(100) DEFAULT NULL COMMENT '账号',
  `password` varchar(100) DEFAULT NULL COMMENT '登录密码',
  `nick_name` varchar(50) DEFAULT NULL COMMENT '昵称',
  `sex` varchar(1) DEFAULT NULL COMMENT '性别 0:男 1:女',
  `phone` varchar(11) DEFAULT NULL COMMENT '手机号码',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `flag` varchar(1) DEFAULT NULL COMMENT '状态',
  `salt` varchar(50) DEFAULT NULL COMMENT '盐值',
  `token` varchar(100) DEFAULT NULL COMMENT 'token',
  `qq_oppen_id` varchar(100) DEFAULT NULL COMMENT 'QQ 第三方登录Oppen_ID唯一标识',
  `mobile_user_id` varchar(100) DEFAULT NULL COMMENT '移动办公云UserID',
  `pwd` varchar(100) DEFAULT NULL COMMENT '明文密码',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理-用户基础信息表';

-- ----------------------------
-- Records of t_sys_user
-- ----------------------------
INSERT INTO `t_sys_user` VALUES ('1', 'admin', '099c95b68140d17b965fcec782ad4bdf3a9c945b5271b4aa3421dda86f5ea70e', '周武云', '0', '18900709868', '10086@qq.com', 'http://qzapp.qlogo.cn/qzapp/101536330/86F96F92387D69BD7659C4EC3CD6BD69/100', '1', 'codingcat', 'Study-Api_token_bdde290e-d1b5-4715-b487-dae920083967', '', null, '123456', '2019-05-05 16:09:06', '2020-02-25 16:11:49');
INSERT INTO `t_sys_user` VALUES ('2', 'test', '099c95b68140d17b965fcec782ad4bdf3a9c945b5271b4aa3421dda86f5ea70e', '测试号', '0', '10000', '10000@qq.com', 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif', '1', 'codingcat', 'Study-Api_token_701779fd-5655-4bf6-9784-e766a65539fe', null, null, '123456', '2019-05-05 16:15:06', '2020-02-23 19:15:23');

-- ----------------------------
-- Table structure for t_sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_user_role`;
CREATE TABLE `t_sys_user_role` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int(10) DEFAULT NULL COMMENT '角色ID',
  `user_id` int(10) DEFAULT NULL COMMENT '用户ID',
  `gmt_create` datetime DEFAULT NULL COMMENT '创建时间',
  `gmt_modified` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='系统管理 - 用户角色关联表 ';

-- ----------------------------
-- Records of t_sys_user_role
-- ----------------------------
INSERT INTO `t_sys_user_role` VALUES ('12', '1', '1', '2019-08-21 10:49:41', '2019-08-21 10:49:41');
INSERT INTO `t_sys_user_role` VALUES ('33', '2', '2', '2019-09-18 21:26:32', '2019-09-18 21:26:32');
