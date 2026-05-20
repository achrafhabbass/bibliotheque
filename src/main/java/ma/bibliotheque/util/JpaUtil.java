package ma.bibliotheque.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.HashMap;
import java.util.Map;

public class JpaUtil {

    private static final EntityManagerFactory EMF;

    static {
        Map<String, String> overrides = new HashMap<>();
        String url  = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASSWORD");
        if (url  != null) overrides.put("jakarta.persistence.jdbc.url",      url);
        if (user != null) overrides.put("jakarta.persistence.jdbc.user",     user);
        if (pass != null) overrides.put("jakarta.persistence.jdbc.password", pass);
        EMF = Persistence.createEntityManagerFactory("bibliotheque",
                overrides.isEmpty() ? null : overrides);
    }

    private JpaUtil() {}

    public static EntityManager getEntityManager() {
        return EMF.createEntityManager();
    }

    public static void shutdown() {
        if (EMF != null && EMF.isOpen()) EMF.close();
    }
}
