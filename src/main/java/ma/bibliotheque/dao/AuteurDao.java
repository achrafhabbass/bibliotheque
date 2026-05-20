package ma.bibliotheque.dao;

import jakarta.persistence.EntityManager;
import ma.bibliotheque.entities.Auteur;
import ma.bibliotheque.entities.Categorie;
import ma.bibliotheque.util.JpaUtil;
import java.util.List;

public class AuteurDao extends GenericDao<Auteur> {
    public AuteurDao() { super(Auteur.class); }

    public List<Auteur> search(String q) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String p = "%" + q.toLowerCase() + "%";
            return em.createQuery(
                    "FROM Auteur a WHERE LOWER(a.nom) LIKE :q OR LOWER(a.prenom) LIKE :q",
                    Auteur.class).setParameter("q", p).getResultList();
        } finally { em.close(); }
    }
}
