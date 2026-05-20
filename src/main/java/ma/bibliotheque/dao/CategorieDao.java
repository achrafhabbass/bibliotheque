package ma.bibliotheque.dao;

import jakarta.persistence.EntityManager;
import ma.bibliotheque.entities.Categorie;
import ma.bibliotheque.util.JpaUtil;
import java.util.List;

public class CategorieDao extends GenericDao<Categorie> {
    public CategorieDao() { super(Categorie.class); }

    public List<Categorie> search(String q) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("FROM Categorie c WHERE LOWER(c.nom) LIKE :q", Categorie.class)
                    .setParameter("q", "%" + q.toLowerCase() + "%").getResultList();
        } finally { em.close(); }
    }
}
