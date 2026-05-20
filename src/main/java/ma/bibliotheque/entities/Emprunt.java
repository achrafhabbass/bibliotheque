package ma.bibliotheque.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "emprunts")
public class Emprunt {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "emprunt_seq")
    @SequenceGenerator(name = "emprunt_seq", sequenceName = "EMPRUNT_SEQ", allocationSize = 1)
    private Long id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "livre_id", nullable = false)
    private Livre livre;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id", nullable = false)
    private Client client;

    @Column(name = "date_debut", nullable = false)
    private LocalDate dateDebut;

    @Column(name = "date_fin_prevue", nullable = false)
    private LocalDate dateFinPrevue;

    @Column(name = "date_fin_reelle")
    private LocalDate dateFinReelle;

    @Min(1)
    @Column(name = "duree_jours", nullable = false)
    private int dureeJours;

    @NotNull
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal frais;

    @Column(precision = 10, scale = 2)
    private BigDecimal penalite = BigDecimal.ZERO;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Statut statut = Statut.EN_COURS;

    @OneToMany(mappedBy = "emprunt", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Operation> operations = new ArrayList<>();

    public enum Statut { EN_COURS, RETOURNE }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Livre getLivre() { return livre; }
    public void setLivre(Livre livre) { this.livre = livre; }
    public Client getClient() { return client; }
    public void setClient(Client client) { this.client = client; }
    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }
    public LocalDate getDateFinPrevue() { return dateFinPrevue; }
    public void setDateFinPrevue(LocalDate dateFinPrevue) { this.dateFinPrevue = dateFinPrevue; }
    public LocalDate getDateFinReelle() { return dateFinReelle; }
    public void setDateFinReelle(LocalDate dateFinReelle) { this.dateFinReelle = dateFinReelle; }
    public int getDureeJours() { return dureeJours; }
    public void setDureeJours(int dureeJours) { this.dureeJours = dureeJours; }
    public BigDecimal getFrais() { return frais; }
    public void setFrais(BigDecimal frais) { this.frais = frais; }
    public BigDecimal getPenalite() { return penalite; }
    public void setPenalite(BigDecimal penalite) { this.penalite = penalite; }
    public Statut getStatut() { return statut; }
    public void setStatut(Statut statut) { this.statut = statut; }
    public List<Operation> getOperations() { return operations; }
    public void setOperations(List<Operation> operations) { this.operations = operations; }

    public BigDecimal getTotalDu() {
        return frais.add(penalite == null ? BigDecimal.ZERO : penalite);
    }
}
