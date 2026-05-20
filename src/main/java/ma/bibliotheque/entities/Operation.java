package ma.bibliotheque.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "operations")
public class Operation {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "op_seq")
    @SequenceGenerator(name = "op_seq", sequenceName = "OP_SEQ", allocationSize = 1)
    private Long id;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "emprunt_id", nullable = false)
    private Emprunt emprunt;

    @Enumerated(EnumType.STRING)
    @Column(name = "type_op", nullable = false, length = 10)
    private TypeOperation typeOp;

    @NotNull @DecimalMin("0.00")
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal montant;

    @Column(name = "date_operation", nullable = false)
    private LocalDate dateOperation;

    public enum TypeOperation { EMPRUNT, RETOUR, PENALITE }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Emprunt getEmprunt() { return emprunt; }
    public void setEmprunt(Emprunt emprunt) { this.emprunt = emprunt; }
    public TypeOperation getTypeOp() { return typeOp; }
    public void setTypeOp(TypeOperation typeOp) { this.typeOp = typeOp; }
    public BigDecimal getMontant() { return montant; }
    public void setMontant(BigDecimal montant) { this.montant = montant; }
    public LocalDate getDateOperation() { return dateOperation; }
    public void setDateOperation(LocalDate dateOperation) { this.dateOperation = dateOperation; }
}
