package com.skeleton.blueprintapi;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController()
public class ApiController {

    @GetMapping(value = "/api")
    public ResponseEntity<String> get() {
        return ResponseEntity.ok("Working!");
    }

}
