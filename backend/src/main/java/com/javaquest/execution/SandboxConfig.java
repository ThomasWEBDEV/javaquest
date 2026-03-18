package com.javaquest.execution;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration du sandbox d'execution de code.
 * Definit les limites et restrictions pour l'execution securisee.
 */
@Configuration
@ConfigurationProperties(prefix = "javaquest.sandbox")
public class SandboxConfig {

    private int timeoutSeconds = 5;
    private int maxOutputLength = 10000;
    private int maxCodeLength = 50000;
    private boolean allowFileAccess = false;
    private boolean allowNetworkAccess = false;
    private boolean allowSystemExit = false;

    // Getters et Setters
    public int getTimeoutSeconds() {
        return timeoutSeconds;
    }

    public void setTimeoutSeconds(int timeoutSeconds) {
        this.timeoutSeconds = timeoutSeconds;
    }

    public int getMaxOutputLength() {
        return maxOutputLength;
    }

    public void setMaxOutputLength(int maxOutputLength) {
        this.maxOutputLength = maxOutputLength;
    }

    public int getMaxCodeLength() {
        return maxCodeLength;
    }

    public void setMaxCodeLength(int maxCodeLength) {
        this.maxCodeLength = maxCodeLength;
    }

    public boolean isAllowFileAccess() {
        return allowFileAccess;
    }

    public void setAllowFileAccess(boolean allowFileAccess) {
        this.allowFileAccess = allowFileAccess;
    }

    public boolean isAllowNetworkAccess() {
        return allowNetworkAccess;
    }

    public void setAllowNetworkAccess(boolean allowNetworkAccess) {
        this.allowNetworkAccess = allowNetworkAccess;
    }

    public boolean isAllowSystemExit() {
        return allowSystemExit;
    }

    public void setAllowSystemExit(boolean allowSystemExit) {
        this.allowSystemExit = allowSystemExit;
    }
}
