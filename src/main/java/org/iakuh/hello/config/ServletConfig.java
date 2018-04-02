package org.iakuh.hello.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import static org.springframework.context.annotation.FilterType.ANNOTATION;

/**
 * Created by Kai on 2/5/2018.
 */
@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "org.iakuh.hello.controller",
        includeFilters = {@ComponentScan.Filter(type = ANNOTATION, value = Controller.class),
                @ComponentScan.Filter(type = ANNOTATION, value = ControllerAdvice.class)})
public class ServletConfig extends WebMvcConfigurerAdapter {

}
