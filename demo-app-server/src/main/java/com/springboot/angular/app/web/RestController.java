package com.springboot.angular.app.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;

@org.springframework.web.bind.annotation.RestController
public class RestController {

	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

	@RequestMapping("/api/hello")
	public String greet() {
		LOGGER.debug("calling method : greet");
		return "Hello from the other side!!!";
	}

}
