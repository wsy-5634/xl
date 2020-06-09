package com.fugu.config;


import lombok.extern.slf4j.Slf4j;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 跨域访问过滤器
 */
@Slf4j
public class DifferentDomainFilter implements Filter  {

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		String method = req.getMethod();
		boolean differentDomain = true;
		if(differentDomain){
			 res.setHeader("Access-Control-Allow-Origin","*");
			 res.setHeader("Access-Control-Allow-Methods","*");
		}
		res.setHeader("Access-Control-Allow-Headers","x_requested_with,x-requested-with,content-type,token,x-token,accessToken,appId,appSecret");
		if ("OPTIONS".equals(method)) {
			if (differentDomain) {//允许访问
				return;
			} else {
				res.sendError(400, "禁止跨越访问");
			}
		}else{
			chain.doFilter(request, response);
		}
	}
}
