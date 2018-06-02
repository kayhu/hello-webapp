package org.iakuh.hello.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by Kai on 2/5/2018.
 */
@RestController
public class HelloController {

    @RequestMapping("hello")
    public String hello() {
        return "echo hello";
    }

}
