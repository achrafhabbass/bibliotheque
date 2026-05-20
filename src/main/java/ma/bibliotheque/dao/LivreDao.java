package ma.bibliotheque.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import ma.bibliotheque.entities.Auteur;
import ma.bibliotheque.entities.Categorie;
import ma.bibliotheque.entities.Livre;
import ma.bibliotheque.util.JpaUtil;
import java.util.List;

public class LivreDao extends GenericDao<Livre> {

    public LivreDao() {
        super(Livre.class);
    }

    public List<Livre> search(String q) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String p = "%" + q.toLowerCase() + "%";
            List<Long> ids = em.createQuery(
                    "SELECT DISTINCT l.id FROM Livre l LEFT JOIN l.auteurs a LEFT JOIN l.categories c " +
                    "WHERE LOWER(l.titre) LIKE :q OR LOWER(l.isbn) LIKE :q " +
                    "OR LOWER(a.nom) LIKE :q OR LOWER(c.nom) LIKE :q", Long.class)
                    .setParameter("q", p)
                    .getResultList();
            if (ids.isEmpty()) return List.of();
            return em.createQuery(
                    "SELECT DISTINCT l FROM Livre l LEFT JOIN FETCH l.auteurs LEFT JOIN FETCH l.categories " +
                    "WHERE l.id IN :ids", Livre.class)
                    .setParameter("ids", ids)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Livre> findDisponibles() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("FROM Livre l WHERE l.disponible = true", Livre.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void saveWithRelations(Livre livre, List<Long> auteurIds, List<Long> categorieIds) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            livre.getAuteurs().clear();
            for (Long aid : auteurIds) livre.getAuteurs().add(em.getReference(Auteur.class, aid));
            livre.getCategories().clear();
            for (Long cid : categorieIds) livre.getCategories().add(em.getReference(Categorie.class, cid));
            if (livre.getId() == null) em.persist(livre);
            else em.merge(livre);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public Livre findByIdWithRelations(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            List<Livre> res = em.createQuery(
                    "SELECT DISTINCT l FROM Livre l LEFT JOIN FETCH l.auteurs LEFT JOIN FETCH l.categories WHERE l.id = :id",
                    Livre.class).setParameter("id", id).getResultList();
            return res.isEmpty() ? null : res.get(0);
        } finally {
            em.close();
        }
    }

    public List<Livre> findAllWithRelations() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT l FROM Livre l LEFT JOIN FETCH l.auteurs LEFT JOIN FETCH l.categories",
                    Livre.class).getResultList();
        } finally {
            em.close();
        }
    }
}
