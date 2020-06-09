package com.fugu.config;

import com.baomidou.mybatisplus.mapper.MetaObjectHandler;
import com.fugu.utils.DateTimeUtils;
import org.apache.ibatis.reflection.MetaObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.util.Date;

/**
 *  <p> MyBatisPlus自定义字段自动填充处理类 - 实体类中使用 @TableField注解 </p>
 *
 * @description: 注意前端传值时要为null
 * @author: fugu
 * @date: 2019/8/18 0018 1:46
 */
@Component
public class MyMetaObjectHandler extends MetaObjectHandler {

    private static final Logger LOG = LoggerFactory.getLogger(MyMetaObjectHandler.class);

    /**
     * 创建时间
     */
    @Override
    public void insertFill(MetaObject metaObject) {
       LOG.info(" -------------------- start insert fill ...  --------------------");
       if (metaObject.hasGetter("gmtCreate") && metaObject.hasGetter("gmtModified")) {
          setFieldValByName("gmtCreate", new Date(), metaObject);
          setFieldValByName("gmtModified", new Date(), metaObject);
       } else if (metaObject.hasGetter("createTime") || metaObject.hasGetter("updateTime")) {
            setFieldValByName("createTime", new Date(), metaObject);
            setFieldValByName("updateTime", new Date(), metaObject);
        }
    }

    /**
     * 最后一次更新时间
     */
    @Override
    public void updateFill(MetaObject metaObject) {
       LOG.info(" -------------------- start update fill ...  --------------------");
       if (metaObject.hasGetter("et.gmtModified")) {
          setFieldValByName("gmtModified", new Date(), metaObject);
       } else if (metaObject.hasGetter("updateTime")) {
           setFieldValByName("updateTime", new Date(), metaObject);
       }
    }
}
