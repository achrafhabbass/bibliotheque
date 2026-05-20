package ma.bibliotheque.dao;

import jakarta.persistence.EntityManager;
import ma.bibliotheque.entities.Utilisateur;
import ma.bibliotheque.util.JpaUtil;
import java.util.List;

public class UtilisateurDao extends GenericDao<Utilisateur> {

    public UtilisateurDao() {
        super(Utilisateur.class);
    }

    public Utilisateur findByEmail(String email) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            List<Utilisateur> result = em.createQuery(
                    "FROM Utilisateur u WHERE u.email = :email", Utilisateur.class)
                    .setParameter("email", email)
                    .getResultList();
            return result.isEmpty() ? null : result.get(0);
        } finally {
            em.close();
        }
    }

    public List<Utilisateur> search(String q) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String p = "%" + q.toLowerCase() + "%";
            return em.createQuery(
                    "FROM Utilisateur u WHERE LOWER(u.nom) LIKE :q OR LOWER(u.prenom) LIKE :q OR LOWER(u.email) LIKE :q",
                    Utilisateur.class)
                    .setParameter("q", p)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public long countAdmins() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("SELECT COUNT(u) FROM Utilisateur u WHERE u.role = :r", Long.class)
                    .setParameter("r", Utilisateur.Role.ADMIN)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }
}
