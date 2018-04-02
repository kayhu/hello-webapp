package org.iakuh.hello.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

/**
 * Created by Kai on 2/5/2018.
 */
@RestController
public class HomeController {

    @RequestMapping(value = {"/", "homepage"}, method = GET)
    public String home() {
        return "homepage";
    }

}
