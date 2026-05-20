package ma.bibliotheque.integration;

import jakarta.ws.rs.core.Response;
import ma.bibliotheque.dao.LivreDao;
import ma.bibliotheque.entities.Livre;
import ma.bibliotheque.rest.LivreResource;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LivreResourceIT {

    @Mock
    private LivreDao dao;

    private LivreResource resource;

    @BeforeEach
    void setUp() {
        resource = new LivreResource(dao);
    }

    @Test
    void getAllSansParametresRetourne200() {
        when(dao.findAllWithRelations()).thenReturn(List.of());
        Response resp = resource.getAll(null, null);
        assertEquals(200, resp.getStatus());
    }

    @Test
    void getAllAvecQueryDelegueAuDao() {
        Livre l = livreFactice(1L, "L'Etranger", true);
        when(dao.search("etranger")).thenReturn(List.of(l));
        Response resp = resource.getAll("etranger", null);
        assertEquals(200, resp.getStatus());
        verify(dao, times(1)).search("etranger");
    }

    @Test
    void getAllFiltreDisponibleExclutIndisponibles() {
        Livre dispo    = livreFactice(1L, "Germinal",  true);
        Livre emprunt  = livreFactice(2L, "Candide",   false);
        when(dao.findAllWithRelations()).thenReturn(List.of(dispo, emprunt));
        Response resp = resource.getAll(null, true);
        assertEquals(200, resp.getStatus());
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> body = (List<Map<String, Object>>) resp.getEntity();
        assertEquals(1, body.size());
        assertEquals("Germinal", body.get(0).get("titre"));
    }

    @Test
    void getByIdInexistantRetourne404() {
        when(dao.findByIdWithRelations(99L)).thenReturn(null);
        Response resp = resource.getById(99L);
        assertEquals(404, resp.getStatus());
    }

    @Test
    void getByIdExistantRetourne200AvecBonTitre() {
        Livre l = livreFactice(1L, "Fondation", true);
        when(dao.findByIdWithRelations(1L)).thenReturn(l);
        Response resp = resource.getById(1L);
        assertEquals(200, resp.getStatus());
        @SuppressWarnings("unchecked")
        Map<String, Object> body = (Map<String, Object>) resp.getEntity();
        assertEquals("Fondation", body.get("titre"));
        assertEquals(true, body.get("disponible"));
    }

    @Test
    void getByIdRetourneIsbnEtTarif() {
        Livre l = livreFactice(2L, "1984", false);
        l.setIsbn("9782070368228");
        l.setTarifJournalier(new BigDecimal("4.50"));
        when(dao.findByIdWithRelations(2L)).thenReturn(l);
        @SuppressWarnings("unchecked")
        Map<String, Object> body = (Map<String, Object>) resource.getById(2L).getEntity();
        assertEquals("9782070368228", body.get("isbn"));
        assertEquals(new BigDecimal("4.50"), body.get("tarifJournalier"));
    }

    private Livre livreFactice(Long id, String titre, boolean disponible) {
        Livre l = new Livre();
        l.setTitre(titre);
        l.setTarifJournalier(new BigDecimal("5.00"));
        l.setDisponible(disponible);
        l.setAuteurs(new HashSet<>());
        l.setCategories(new HashSet<>());
        return l;
    }
}
