package com.springboot.angular.app.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;

import com.springboot.angular.app.model.User;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Damith Ganegoda on 9/3/17.
 */
@CrossOrigin(origins = "http://localhost:4200")
@RestController
@RequestMapping(value = "/users")
public class UserController {

	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

	private List<User> users = new ArrayList();

	UserController() {
		LOGGER.debug("calling constructor method : UserController");
		this.users = buildUsers();
	}

	@GetMapping
	public List<User> getUsers() {
		LOGGER.debug("calling method : getUsers");
		return this.users;
	}

	@GetMapping(value = "/{id}")
	public User getUser(@PathVariable("id") Long id) {
		LOGGER.debug("calling method : getUser");
		return this.users.stream().filter(user -> user.getId() == id).findFirst().orElse(null);
	}

	@PostMapping
	public User saveUser(@RequestBody User user) {
		LOGGER.debug("calling method : saveUser");
		Long nextId = 0L;
		if (this.users.size() != 0) {
			User lastUser = this.users.stream().skip(this.users.size() - 1).findFirst().orElse(null);
			nextId = lastUser.getId() + 1;
		}

		user.setId(nextId);
		this.users.add(user);
		return user;
	}

	@PutMapping
	public User updateUser(@RequestBody User user) {
		LOGGER.debug("calling method : updateUser");
		final User modifiedUser = this.users.stream().filter(u -> u.getId() == user.getId()).findFirst().orElse(null);
		modifiedUser.setFirstName(user.getFirstName());
		modifiedUser.setLastName(user.getLastName());
		modifiedUser.setEmail(user.getEmail());
		return modifiedUser;
	}

	@DeleteMapping(value = "/{id}")
	public boolean deleteUser(@PathVariable Long id) {
		LOGGER.debug("calling method : deleteUser");
		final User deleteUser = this.users.stream().filter(user -> user.getId() == id).findFirst().orElse(null);
		if (deleteUser != null) {
			this.users.remove(deleteUser);
			return true;
		} else {
			return false;
		}
	}

	private List<User> buildUsers() {
		LOGGER.debug("calling method : buildUsers");
		final List<User> users = new ArrayList<>();
		users.add(buildUser(1L, "John", "Doe", "john@email.com"));
		users.add(buildUser(2L, "Jon", "Smith", "smith@email.com"));
		users.add(buildUser(3L, "Will", "Craig", "will@email.com"));
		users.add(buildUser(4L, "Sam", "Lernorad", "sam@email.com"));
		users.add(buildUser(5L, "Ross", "Doe", "ross@email.com"));

		return users;
	}

	private User buildUser(final Long id, final String fname, final String lname, final String email) {
		LOGGER.debug("calling method : buildUser");
		final User user = new User();
		user.setId(id);
		user.setFirstName(fname);
		user.setLastName(lname);
		user.setEmail(email);
		return user;
	}

}
