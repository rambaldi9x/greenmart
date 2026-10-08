package com.greenmart.util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.service.ServiceRegistry;

import java.io.InputStream;
import java.util.Properties;

import com.greenmart.entity.*;

public class HibernateUtil {
    private static SessionFactory sessionFactory;

    private static synchronized void buildSessionFactory() {
        try {
            Configuration configuration = new Configuration();
            Properties settings = new Properties();

            // Đọc cấu hình từ application.properties
            try (InputStream is = HibernateUtil.class.getClassLoader().getResourceAsStream("application.properties")) {
                if (is != null) {
                    Properties appProps = new Properties();
                    appProps.load(is);

                    settings.put(Environment.DRIVER, appProps.getProperty("db.driver"));
                    settings.put(Environment.URL, appProps.getProperty("db.url"));
                    settings.put(Environment.USER, appProps.getProperty("db.username"));
                    settings.put(Environment.PASS, appProps.getProperty("db.password"));
                    settings.put(Environment.DIALECT, appProps.getProperty("hibernate.dialect"));
                    settings.put(Environment.SHOW_SQL, appProps.getProperty("hibernate.show_sql"));
                    settings.put(Environment.FORMAT_SQL, appProps.getProperty("hibernate.format_sql"));
                    settings.put(Environment.HBM2DDL_AUTO, appProps.getProperty("hibernate.hbm2ddl.auto"));
                    settings.put(Environment.GLOBALLY_QUOTED_IDENTIFIERS, appProps.getProperty("hibernate.globally_quoted_identifiers"));
                }
            }

            configuration.setProperties(settings);

            // Add Entity classes
            configuration.addAnnotatedClass(Product.class);
            configuration.addAnnotatedClass(User.class);
            configuration.addAnnotatedClass(Category.class);
            configuration.addAnnotatedClass(UserRole.class);
            configuration.addAnnotatedClass(Order.class);
            configuration.addAnnotatedClass(OrderItem.class);
            configuration.addAnnotatedClass(Coupon.class);
            configuration.addAnnotatedClass(Vendor.class);
            configuration.addAnnotatedClass(ChatMessage.class);

            ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                    .applySettings(configuration.getProperties()).build();
            sessionFactory = configuration.buildSessionFactory(serviceRegistry);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("Initial SessionFactory creation failed: " + e);
        }
    }

    static {
        buildSessionFactory();
    }

    public static synchronized SessionFactory getSessionFactory() {
        if (sessionFactory == null || sessionFactory.isClosed()) {
            buildSessionFactory();
        }
        return sessionFactory;
    }

    public static synchronized void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
    }
}