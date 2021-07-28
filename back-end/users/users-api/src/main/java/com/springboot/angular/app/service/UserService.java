package com.springboot.angular.app.service;

import com.springboot.angular.app.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {

    private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    private List<User> users = new ArrayList<>();

    public List<User> getUsers() {
        LOGGER.debug("calling method : getUsers");
        users = List.of(
                buildUser(1L, "John", "Doe", "john@email.com"),
                buildUser(2L, "Jon", "Smith", "smith@email.com"),
                buildUser(3L, "Will", "Craig", "will@email.com"),
                buildUser(4L, "Sam", "Lernorad", "sam@email.com"),
                buildUser(5L, "Ross", "Doe", "ross@email.com")
        );
        return users;
    }

    public User getUser(final Long id) {
        LOGGER.debug("calling method : getUser");
        return users.stream().filter(user -> user.getId() == id).findFirst().orElse(null);
    }

    public User saveUser(final User user) {
        LOGGER.debug("calling method : saveUser");
        Long nextId = 0L;
        if (this.users.size() != 0) {
            final User lastUser = this.users.stream().skip(this.users.size() - 1).findFirst().orElse(null);
            nextId = lastUser.getId() + 1;
        }

        user.setId(nextId);
        this.users.add(user);
        return user;
    }

    public User updateUser(final User user) {
        LOGGER.debug("calling method : updateUser");
        final User modifiedUser = this.users.stream().filter(u -> u.getId() == user.getId()).findFirst().orElse(null);
        modifiedUser.setFirstName(user.getFirstName());
        modifiedUser.setLastName(user.getLastName());
        modifiedUser.setEmail(user.getEmail());
        return modifiedUser;
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

    public boolean deleteUser(final Long id) {
        LOGGER.debug("calling method : deleteUser");
        final User deleteUser = this.users.stream().filter(user -> user.getId() == id).findFirst().orElse(null);
        if (deleteUser != null) {
            this.users.remove(deleteUser);
            return true;
        } else {
            return false;
        }
    }

}