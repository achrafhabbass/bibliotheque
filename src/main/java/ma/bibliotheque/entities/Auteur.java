package ma.bibliotheque.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "auteurs")
public class Auteur {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "auteur_seq")
    @SequenceGenerator(name = "auteur_seq", sequenceName = "AUTEUR_SEQ", allocationSize = 1)
    private Long id;

    @NotNull @Size(min = 2, max = 50)
    @Column(nullable = false, length = 50)
    private String nom;

    @NotNull @Size(min = 2, max = 50)
    @Column(nullable = false, length = 50)
    private String prenom;

    @ManyToMany(mappedBy = "auteurs", fetch = FetchType.LAZY)
    private List<Livre> livres = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public List<Livre> getLivres() { return livres; }
    public void setLivres(List<Livre> livres) { this.livres = livres; }

    public String getNomComplet() { return prenom + " " + nom; }
}
