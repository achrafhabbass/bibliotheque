package ma.bibliotheque.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.io.Serial;
import java.io.Serializable;

@Entity
@Table(name = "utilisateurs")
public class Utilisateur implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "util_seq")
    @SequenceGenerator(name = "util_seq", sequenceName = "UTIL_SEQ", allocationSize = 1)
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

    @NotNull
    @Column(name = "mot_de_passe", nullable = false, length = 255)
    private String motDePasse;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Role role = Role.MANAGER;

    public enum Role { ADMIN, MANAGER }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }
    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public String getNomComplet() { return prenom + " " + nom; }
}
