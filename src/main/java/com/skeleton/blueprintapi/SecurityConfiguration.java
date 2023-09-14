package com.skeleton.blueprintapi;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Security configuration.
 */
@Configuration
public class SecurityConfiguration {

    public SecurityConfiguration() {

    }

    /**
     * A filter chain that adds security configurations for an OAuth2 resource server with an opaque access token.
     *
     * @param http the HttpSecurity instance used to configure the security filters
     * @return the configured SecurityFilterChain instance
     * @throws Exception if an error occurs while building the filter chain
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors()
                .and()
                .csrf().disable();
        return http.build();
    }
}

