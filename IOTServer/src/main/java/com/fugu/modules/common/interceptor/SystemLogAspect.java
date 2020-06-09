package com.fugu.modules.common.interceptor;

import com.fugu.config.Constants;
import com.fugu.modules.system.entity.User;
import com.fugu.modules.common.dto.output.ApiResult;
import com.fugu.modules.shiro.utils.ShiroUtils;
import com.fugu.modules.system.entity.SysLog;
import com.fugu.modules.system.mapper.UserMapper;
import com.fugu.utils.DateTimeUtils;
import com.fugu.utils.IpUtils;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.util.Date;

/**
 *  <p> 系统日志处理 </p>
 *
 * @description :
 * @author : fugu
 * @date : 2019/9/18 15:25
 */
@Aspect
@Configuration
@Slf4j
public class SystemLogAspect {

    @Autowired
    UserMapper userMapper;

    @Pointcut("execution(* com.fugu.modules.*.api.*Controller.*(..)))")
    public void systemLog() {}

    @Around(value = "systemLog()")
    public Object doAround(ProceedingJoinPoint joinPoint) throws Throwable {
       ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
       HttpServletRequest request = attributes.getRequest();
       HttpServletResponse response = attributes.getResponse();

       // 拿到ip地址、请求路径、token
       String url = request.getRequestURL().toString();
       String ip = IpUtils.getIpAdrress(request);
       String token = request.getHeader(Constants.REQUEST_HEADER);

       // 从切面织入点处通过反射机制获取织入点处的方法
       MethodSignature signature = (MethodSignature) joinPoint.getSignature();
       // 获取切入点所在的方法
       Method method = signature.getMethod();
       ApiOperation apiOperation = method.getAnnotation(ApiOperation.class);
       String methodName = "";
       if(apiOperation != null){
          methodName = apiOperation.value();
       }

       // 记录执行时间
       long startTime = System.currentTimeMillis();
       ApiResult result = (ApiResult)joinPoint.proceed(joinPoint.getArgs());
       log.info("**********   Url: {}, Start: {}, Code: {}   **********", url, DateTimeUtils.dateFormat( new Date( startTime ), "yyyy-MM-dd HH:mm:ss:SSS" ), result.getCode() );

       // 插入系统日志表
       SysLog sysLog = new SysLog();
       sysLog.setName(methodName);
       sysLog.setUrl(url);
       sysLog.setIp(ip);
       // 获取用户信息
       if (token == null){
          User userInfo = ShiroUtils.getUserInfo();
          if (userInfo!=null){
              sysLog.setUserId( userInfo.getId() );
          } else {
              sysLog.setName(result.getMessage());
          }
       } else {
          if (userMapper.getUserInfoByToken(token)!=null){
              sysLog.setUserId( userMapper.getUserInfoByToken(token).getId() );
          }
       }
       sysLog.setStatus( result.getCode() );
       sysLog.insert();
       return result;
    }

}
