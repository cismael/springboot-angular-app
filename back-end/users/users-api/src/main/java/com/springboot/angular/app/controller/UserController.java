package com.springboot.angular.app.controller;

import com.springboot.angular.app.model.User;
import com.springboot.angular.app.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "http://localhost:4200")
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/users")
public class UserController {

	public final UserService userService;

	@GetMapping
	public List<User> getUsers() {
		return userService.getUsers();
	}

	@GetMapping(value = "/{id}")
	public User getUser(@PathVariable("id") final Long id) {
		return userService.getUser(id);
	}

	@PostMapping
	public User saveUser(@RequestBody final User user) {
		return userService.saveUser(user);
	}

	@PutMapping
	public User updateUser(@RequestBody final User user) {
		return userService.updateUser(user);
	}

	@DeleteMapping(value = "/{id}")
	public boolean deleteUser(@PathVariable final Long id) {
		return userService.deleteUser(id);
	}

}