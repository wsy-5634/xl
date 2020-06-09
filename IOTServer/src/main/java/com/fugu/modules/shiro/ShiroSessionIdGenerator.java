package com.fugu.modules.shiro;

import com.fugu.modules.shiro.constant.RedisConstant;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.eis.JavaUuidSessionIdGenerator;
import org.apache.shiro.session.mgt.eis.SessionIdGenerator;

import java.io.Serializable;

/**
 *  <p> 自定义SessionId生成器 </p>
 *
 * @description :
 * @author : fugu
 * @date : 2019/8/23 15:47
 */
@Slf4j
public class ShiroSessionIdGenerator implements SessionIdGenerator {
    /**
     * 实现SessionId生成
     */
    @Override
    public Serializable generateId(Session session) {
        Serializable sessionId = new JavaUuidSessionIdGenerator().generateId(session);
        Serializable sessionString =  String.format(RedisConstant.REDIS_PREFIX_LOGIN, sessionId);
        log.info("生成sessionID：" + sessionString);
        return sessionString;
    }
}
