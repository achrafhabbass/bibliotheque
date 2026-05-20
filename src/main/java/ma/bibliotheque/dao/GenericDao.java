package ma.bibliotheque.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import ma.bibliotheque.util.JpaUtil;
import java.util.List;

public abstract class GenericDao<T> {

    protected final Class<T> clazz;

    protected GenericDao(Class<T> clazz) {
        this.clazz = clazz;
    }

    public T findById(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.find(clazz, id);
        } finally {
            em.close();
        }
    }

    public List<T> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery("FROM " + clazz.getSimpleName(), clazz).getResultList();
        } finally {
            em.close();
        }
    }

    public void save(T entity) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(entity);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public T update(T entity) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            T merged = em.merge(entity);
            tx.commit();
            return merged;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            T entity = em.find(clazz, id);
            if (entity != null) em.remove(entity);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
