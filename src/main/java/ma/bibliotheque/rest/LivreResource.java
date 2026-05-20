package ma.bibliotheque.rest;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import ma.bibliotheque.dao.LivreDao;
import ma.bibliotheque.entities.Livre;
import java.util.*;

@Path("/livres")
@Produces(MediaType.APPLICATION_JSON)
public class LivreResource {

    private final LivreDao dao;

    public LivreResource() {
        this.dao = new LivreDao();
    }

    public LivreResource(LivreDao dao) {
        this.dao = dao;
    }

    @GET
    public Response getAll(@QueryParam("q") String q, @QueryParam("disponible") Boolean disponible) {
        List<Livre> list = (q != null && !q.isBlank()) ? dao.search(q) : dao.findAllWithRelations();
        if (Boolean.TRUE.equals(disponible))
            list = list.stream().filter(Livre::isDisponible).toList();
        return Response.ok(list.stream().map(this::toMap).toList()).build();
    }

    @GET
    @Path("/{id}")
    public Response getById(@PathParam("id") Long id) {
        Livre l = dao.findByIdWithRelations(id);
        if (l == null) return Response.status(Response.Status.NOT_FOUND)
                .entity(Map.of("erreur", "Livre non trouvé")).build();
        return Response.ok(toMap(l)).build();
    }

    private Map<String, Object> toMap(Livre l) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", l.getId());
        m.put("titre", l.getTitre());
        m.put("isbn", l.getIsbn());
        m.put("tarifJournalier", l.getTarifJournalier());
        m.put("disponible", l.isDisponible());
        m.put("auteurs", l.getAuteurs().stream()
                .map(a -> Map.of("id", a.getId(), "nom", a.getNomComplet())).toList());
        m.put("categories", l.getCategories().stream()
                .map(c -> Map.of("id", c.getId(), "nom", c.getNom())).toList());
        return m;
    }
}
