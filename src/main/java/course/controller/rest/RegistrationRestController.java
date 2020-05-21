package course.controller.rest;

import course.controller.response.SimpleResponse;
import course.entity.Role1;
import course.entity.User;
import course.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import java.util.Collections;
import static course.entity.Role1.ADMIN;

@RestController
public class RegistrationRestController {
    @Autowired
    private UserService service;

    @PostMapping(value = "/register")
    public SimpleResponse register(@RequestBody User user) {
        try {
            service.addUser(user);
        } catch (javax.validation.ConstraintViolationException ex) {
            return new SimpleResponse(false, "Your name is too short. There should be 4 symbols minimum");
        } catch (UnsupportedOperationException ex) {
            return new SimpleResponse(false, "This name is busy");
        }
        return new SimpleResponse(true);
    }
}
