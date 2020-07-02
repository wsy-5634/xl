package com.fugu;

import com.fugu.config.MyProperties;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import tk.mybatis.spring.annotation.MapperScan;


@EnableConfigurationProperties({MyProperties.class})
@EnableTransactionManagement
@SpringBootApplication
public class ServerApplication {

//    /**
//     * 配置跨越访问filter
//     */
//    @Bean
//    public FilterRegistrationBean<DifferentDomainFilter> filterRegistrationBean() {
//        FilterRegistrationBean<DifferentDomainFilter> registrationBean = new FilterRegistrationBean<DifferentDomainFilter>();
//
//        DifferentDomainFilter differentDomainFilter = new DifferentDomainFilter();
//        registrationBean.setFilter(differentDomainFilter);
//        List<String> urlPatterns = new ArrayList<String>();
//        urlPatterns.add("/*");
//        registrationBean.setUrlPatterns(urlPatterns);
//
//        return registrationBean;
//    }

    public static void main(String[] args) {
       SpringApplication.run(ServerApplication.class, args);
    }

}
