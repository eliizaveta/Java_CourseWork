package course.controller.rest;

import course.controller.response.SimpleResponse;
import course.entity.Auto;
import course.entity.User;
import course.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class UsersRestController {
    @Autowired
    private UserService service;

    @RequestMapping(value = "/users/get/all", method = RequestMethod.GET)
    public List<User> getAll() {
        List<User> tmp = null;
        try {
            tmp = service.getAllUsers();
        } catch (Exception ex) {
            System.out.println("Exception in get all");
        }
        return tmp;
    }

    @RequestMapping(value = "/users/delete/by/id", method = RequestMethod.POST)
    public SimpleResponse delete(@RequestBody User user) {
        try {
            service.deleteUser(user.getId());
        } catch (org.springframework.dao.DataIntegrityViolationException ex) {
            return new SimpleResponse(false, "This is connected with another tables");
        } catch (IllegalArgumentException ex) {
            return new SimpleResponse(false, "The system don't know this login");
        } catch (Exception ex) {
            return new SimpleResponse(false, "Error, we will try to solve your problem");
        }
        return new SimpleResponse(true);
    }

    @RequestMapping(value = "/users/get/user", method = RequestMethod.GET)
    public User getAllSales() {
        User tmp = null;
        try {
            tmp = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        } catch (Exception ex) {
            System.out.println("Exception in get all");
        }
        return tmp;
    }
}
