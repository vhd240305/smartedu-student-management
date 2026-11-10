package util;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {

    private static DataSource dataSource;

    static {
        PoolProperties p = new PoolProperties();
        p.setUrl("jdbc:mysql://localhost:3306/quanlysinhvien?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8");
        p.setDriverClassName("com.mysql.cj.jdbc.Driver");
        p.setUsername("root");
        p.setPassword("123456");

        p.setInitialSize(5);
        p.setMaxActive(20);
        p.setMinIdle(5);
        p.setMaxIdle(10);
        p.setMaxWait(10000);

        p.setValidationQuery("SELECT 1");
        p.setTestOnBorrow(true);
        p.setTestOnReturn(false);
        p.setTestWhileIdle(true);
        p.setTimeBetweenEvictionRunsMillis(30000);
        p.setMinEvictableIdleTimeMillis(60000);

        p.setRemoveAbandoned(true);
        p.setRemoveAbandonedTimeout(60);
        p.setLogAbandoned(true);

        dataSource = new DataSource();
        dataSource.setPoolProperties(p);
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}