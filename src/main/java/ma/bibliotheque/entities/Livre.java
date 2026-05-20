package ma.bibliotheque.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "livres")
public class Livre {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "livre_seq")
    @SequenceGenerator(name = "livre_seq", sequenceName = "LIVRE_SEQ", allocationSize = 1)
    private Long id;

    @NotNull @Size(min = 1, max = 200)
    @Column(nullable = false, length = 200)
    private String titre;

    @Size(max = 20)
    @Column(unique = true, length = 20)
    private String isbn;

    @NotNull @DecimalMin("0.01")
    @Column(name = "tarif_journalier", nullable = false, precision = 10, scale = 2)
    private BigDecimal tarifJournalier;

    @Column(nullable = false)
    private boolean disponible = true;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "livre_auteur",
            joinColumns = @JoinColumn(name = "livre_id"),
            inverseJoinColumns = @JoinColumn(name = "auteur_id"))
    private Set<Auteur> auteurs = new HashSet<>();

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "livre_categorie",
            joinColumns = @JoinColumn(name = "livre_id"),
            inverseJoinColumns = @JoinColumn(name = "categorie_id"))
    private Set<Categorie> categories = new HashSet<>();

    @OneToMany(mappedBy = "livre", fetch = FetchType.LAZY)
    private List<Emprunt> emprunts = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public BigDecimal getTarifJournalier() { return tarifJournalier; }
    public void setTarifJournalier(BigDecimal tarifJournalier) { this.tarifJournalier = tarifJournalier; }
    public boolean isDisponible() { return disponible; }
    public void setDisponible(boolean disponible) { this.disponible = disponible; }
    public Set<Auteur> getAuteurs() { return auteurs; }
    public void setAuteurs(Set<Auteur> auteurs) { this.auteurs = auteurs; }
    public Set<Categorie> getCategories() { return categories; }
    public void setCategories(Set<Categorie> categories) { this.categories = categories; }
    public List<Emprunt> getEmprunts() { return emprunts; }
    public void setEmprunts(List<Emprunt> emprunts) { this.emprunts = emprunts; }
}
