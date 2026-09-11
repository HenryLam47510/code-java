package com._2003store.service;

import com._2003store.model.User;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AuthServiceTest {

    @Test
    void shouldLoginAdminWithRoleAccess() {
        AuthService service = new AuthService();
        User user = service.login("admin", "123456");

        assertNotNull(user);
        assertEquals("admin", user.getUsername());
        assertEquals("ADMIN", user.getRole());
        assertTrue(service.hasAccess(user, "dashboard"));
        assertTrue(service.hasAccess(user, "products"));
        assertTrue(service.hasAccess(user, "orders"));
        assertTrue(service.hasAccess(user, "stock"));
    }

    @Test
    void shouldRejectUnknownUser() {
        AuthService service = new AuthService();
        assertNull(service.login("unknown", "123456"));
    }
}
