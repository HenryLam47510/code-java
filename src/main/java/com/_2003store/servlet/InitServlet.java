package com._2003store.servlet;

import com._2003store.dao.DatabaseInitializer;
import com._2003store.service.PaymentConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import java.io.IOException;

@WebServlet(value = "/startup", loadOnStartup = 1)
public class InitServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        DatabaseInitializer initializer = new DatabaseInitializer();
        initializer.init();
        PaymentConfig.refreshFromDatabase();
    }
}
