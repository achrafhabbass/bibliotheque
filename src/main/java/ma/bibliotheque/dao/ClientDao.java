package ma.bibliotheque.dao;

import jakarta.persistence.EntityManager;
import ma.bibliotheque.entities.Client;
import ma.bibliotheque.util.JpaUtil;
import java.util.List;

public class ClientDao extends GenericDao<Client> {

    public ClientDao() {
        super(Client.class);
    }

    public List<Client> search(String q) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String p = "%" + q.toLowerCase() + "%";
            return em.createQuery(
                    "FROM Client c WHERE LOWER(c.nom) LIKE :q OR LOWER(c.prenom) LIKE :q OR LOWER(c.email) LIKE :q OR c.telephone LIKE :q",
                    Client.class).setParameter("q", p).getResultList();
        } finally {
            em.close();
        }
    }
}
