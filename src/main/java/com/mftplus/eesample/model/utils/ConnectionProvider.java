package com.mftplus.eesample.model.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionProvider {
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe",
                "javaee",
                "javaee123"
        );
    }
}
