package ma.bibliotheque.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "clients")
public class Client {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "client_seq")
    @SequenceGenerator(name = "client_seq", sequenceName = "CLIENT_SEQ", allocationSize = 1)
    private Long id;

    @NotNull @Size(min = 2, max = 50)
    @Column(nullable = false, length = 50)
    private String nom;

    @NotNull @Size(min = 2, max = 50)
    @Column(nullable = false, length = 50)
    private String prenom;

    @NotNull @Email
    @Column(nullable = false, unique = true, length = 100)
    private String email;

    @Size(max = 20)
    @Column(length = 20)
    private String telephone;

    @OneToMany(mappedBy = "client", fetch = FetchType.LAZY)
    private List<Emprunt> emprunts = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    public List<Emprunt> getEmprunts() { return emprunts; }
    public void setEmprunts(List<Emprunt> emprunts) { this.emprunts = emprunts; }

    public String getNomComplet() { return prenom + " " + nom; }
}
