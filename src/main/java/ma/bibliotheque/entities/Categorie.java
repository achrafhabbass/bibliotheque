package ma.bibliotheque.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "categories")
public class Categorie {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "cat_seq")
    @SequenceGenerator(name = "cat_seq", sequenceName = "CAT_SEQ", allocationSize = 1)
    private Long id;

    @NotNull @Size(min = 2, max = 50)
    @Column(nullable = false, unique = true, length = 50)
    private String nom;

    @ManyToMany(mappedBy = "categories", fetch = FetchType.LAZY)
    private List<Livre> livres = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public List<Livre> getLivres() { return livres; }
    public void setLivres(List<Livre> livres) { this.livres = livres; }
}
