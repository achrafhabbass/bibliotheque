package ma.bibliotheque.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import ma.bibliotheque.entities.*;
import ma.bibliotheque.util.BiblioUtils;
import ma.bibliotheque.util.JpaUtil;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class EmpruntDao extends GenericDao<Emprunt> {

    public EmpruntDao() {
        super(Emprunt.class);
    }

    public boolean hasActiveEmprunt(Long clientId, Long livreId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            Long n = em.createQuery(
                    "SELECT COUNT(e) FROM Emprunt e WHERE e.client.id=:c AND e.livre.id=:l AND e.statut=:s",
                    Long.class)
                    .setParameter("c", clientId).setParameter("l", livreId)
                    .setParameter("s", Emprunt.Statut.EN_COURS).getSingleResult();
            return n > 0;
        } finally {
            em.close();
        }
    }

    public Emprunt creerEmprunt(Long clientId, Long livreId, int dureeJours) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Livre livre = em.find(Livre.class, livreId);
            if (livre == null || !livre.isDisponible())
                throw new IllegalStateException("Livre non disponible.");
            Client client = em.find(Client.class, clientId);

            LocalDate debut = LocalDate.now();
            BigDecimal frais = BiblioUtils.calculerFrais(dureeJours, livre.getTarifJournalier());

            Emprunt emprunt = new Emprunt();
            emprunt.setLivre(livre);
            emprunt.setClient(client);
            emprunt.setDateDebut(debut);
            emprunt.setDateFinPrevue(debut.plusDays(dureeJours));
            emprunt.setDureeJours(dureeJours);
            emprunt.setFrais(frais);
            emprunt.setStatut(Emprunt.Statut.EN_COURS);

            livre.setDisponible(false);

            em.persist(emprunt);

            Operation op = new Operation();
            op.setEmprunt(emprunt);
            op.setTypeOp(Operation.TypeOperation.EMPRUNT);
            op.setMontant(frais);
            op.setDateOperation(debut);
            em.persist(op);

            tx.commit();
            return emprunt;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public Emprunt retournerLivre(Long empruntId) {
        EntityManager em = JpaUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Emprunt emprunt = em.find(Emprunt.class, empruntId);
            if (emprunt == null || emprunt.getStatut() == Emprunt.Statut.RETOURNE)
                throw new IllegalStateException("Emprunt invalide ou déjà retourné.");

            LocalDate today = LocalDate.now();
            emprunt.setDateFinReelle(today);
            emprunt.setStatut(Emprunt.Statut.RETOURNE);
            emprunt.getLivre().setDisponible(true);

            long excess = ChronoUnit.DAYS.between(emprunt.getDateFinPrevue(), today);
            if (excess > 0) {
                BigDecimal penalite = BiblioUtils.calculerPenalite(
                        emprunt.getDateFinPrevue(), today,
                        emprunt.getLivre().getTarifJournalier());
                emprunt.setPenalite(penalite);

                Operation opPen = new Operation();
                opPen.setEmprunt(emprunt);
                opPen.setTypeOp(Operation.TypeOperation.PENALITE);
                opPen.setMontant(penalite);
                opPen.setDateOperation(today);
                em.persist(opPen);
            }

            Operation opRet = new Operation();
            opRet.setEmprunt(emprunt);
            opRet.setTypeOp(Operation.TypeOperation.RETOUR);
            opRet.setMontant(BigDecimal.ZERO);
            opRet.setDateOperation(today);
            em.persist(opRet);

            tx.commit();
            return emprunt;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public List<Emprunt> search(String q, String statut) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            String p = "%" + (q == null ? "" : q.toLowerCase()) + "%";
            String jpql = "SELECT DISTINCT e FROM Emprunt e JOIN FETCH e.livre JOIN FETCH e.client " +
                    "WHERE (LOWER(e.client.nom) LIKE :q OR LOWER(e.client.prenom) LIKE :q OR LOWER(e.livre.titre) LIKE :q)";
            if (statut != null && !statut.isEmpty())
                jpql += " AND e.statut = :s";
            var query = em.createQuery(jpql, Emprunt.class).setParameter("q", p);
            if (statut != null && !statut.isEmpty())
                query.setParameter("s", Emprunt.Statut.valueOf(statut));
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public List<Emprunt> findAllWithRelations() {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT e FROM Emprunt e JOIN FETCH e.livre JOIN FETCH e.client",
                    Emprunt.class).getResultList();
        } finally {
            em.close();
        }
    }

    public Emprunt findByIdWithRelations(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            List<Emprunt> res = em.createQuery(
                    "SELECT e FROM Emprunt e JOIN FETCH e.livre JOIN FETCH e.client WHERE e.id=:id",
                    Emprunt.class).setParameter("id", id).getResultList();
            return res.isEmpty() ? null : res.get(0);
        } finally {
            em.close();
        }
    }
}
