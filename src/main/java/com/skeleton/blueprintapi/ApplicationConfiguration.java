package com.skeleton.blueprintapi;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Slf4j
@Configuration
public class ApplicationConfiguration {

    /**
     * Configuration of CORS filter.
     *
     * @param allowedOrigins allowed origin
     * @return {@link CorsConfigurationSource}
     */
    @Bean
    @Primary
    public CorsConfigurationSource corsConfigurationSource(
            @Value("${app.cors.allowed-origin}") List<String> allowedOrigins
    ) {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.setAllowedOriginPatterns(allowedOrigins);
        config.addAllowedHeader("Authorization");
        config.addAllowedHeader("Content-Type");
        config.addAllowedHeader("Access-Control-Allow-Origin");
        config.setAllowedMethods(List.of("GET", "PUT"));

        var configSource = new UrlBasedCorsConfigurationSource();
        configSource.registerCorsConfiguration("/**", config);
        return configSource;
    }
}