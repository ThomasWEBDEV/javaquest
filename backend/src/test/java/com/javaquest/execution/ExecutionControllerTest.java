package com.javaquest.execution;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests d'integration pour ExecutionController.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class ExecutionControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void executeCode_validCode_returnsSuccess() throws Exception {
        ExecuteRequest request = new ExecuteRequest("1 + 1");

        mockMvc.perform(post("/api/execute")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.status").value("SUCCESS"));
    }

    @Test
    void executeCode_printStatement_returnsOutput() throws Exception {
        ExecuteRequest request = new ExecuteRequest("System.out.println(\"Test\");");

        mockMvc.perform(post("/api/execute")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.output").exists());
    }

    @Test
    void executeCode_syntaxError_returnsError() throws Exception {
        ExecuteRequest request = new ExecuteRequest("int x = ");

        mockMvc.perform(post("/api/execute")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.status").value("ERROR"));
    }

    @Test
    void executeCode_forbiddenCode_returnsBadRequest() throws Exception {
        ExecuteRequest request = new ExecuteRequest("Runtime.getRuntime().exec(\"ls\");");

        mockMvc.perform(post("/api/execute")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.error").exists());
    }

    @Test
    void executeCode_emptyCode_returnsBadRequest() throws Exception {
        ExecuteRequest request = new ExecuteRequest("");

        mockMvc.perform(post("/api/execute")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isBadRequest());
    }

    @Test
    void executeCode_nullCode_returnsBadRequest() throws Exception {
        String jsonRequest = "{\"code\": null}";

        mockMvc.perform(post("/api/execute")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
            .andExpect(status().isBadRequest());
    }

    @Test
    void executeCode_fileAccess_returnsBadRequest() throws Exception {
        ExecuteRequest request = new ExecuteRequest("new java.io.File(\"test.txt\");");

        mockMvc.perform(post("/api/execute")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false));
    }
}
