package com.springboot.angular.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ImportResource;

@ImportResource("classpath:/aop-config.xml")
@SpringBootApplication
public class SpringBootAngularAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootAngularAppApplication.class, args);
	}
}
