<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="_nav.jsp"/>

<div class="flex items-center justify-between mb-6">
    <h2 class="text-2xl font-bold text-blue-900">Emprunts</h2>
    <a href="?action=new" class="bg-blue-800 text-white px-4 py-2 rounded-lg hover:bg-blue-900 text-sm">+ Nouvel emprunt</a>
</div>

<c:choose>
<%-- FORM: Return a book --%>
<c:when test="${not empty empruntRetour}">
<div class="bg-white rounded-xl shadow p-6 mb-6 max-w-lg">
    <h3 class="text-lg font-semibold mb-1">Retourner un livre</h3>
    <p class="text-sm text-gray-500 mb-4">Vérifiez les détails avant de confirmer le retour.</p>
    <div class="bg-gray-50 rounded-lg p-4 mb-4 text-sm space-y-1">
        <p><span class="font-medium">Client :</span> ${empruntRetour.client.nomComplet}</p>
        <p><span class="font-medium">Livre :</span> ${empruntRetour.livre.titre}</p>
        <p><span class="font-medium">Date début :</span> ${empruntRetour.dateDebut}</p>
        <p><span class="font-medium">Date fin prévue :</span> ${empruntRetour.dateFinPrevue}</p>
        <p><span class="font-medium">Frais de base :</span> ${empruntRetour.frais} MAD</p>
        <p class="text-orange-600 font-medium">Date de retour effective : aujourd'hui
        <script>document.write('(' + new Date().toISOString().split('T')[0] + ')')</script>
    </p>
    </div>
    <p class="text-xs text-gray-400 mb-4">Si la date de retour dépasse la date prévue, une pénalité de 1,5× le tarif journalier sera appliquée par jour de retard.</p>
    <form method="post" action="${pageContext.request.contextPath}/emprunts">
        <input type="hidden" name="action"    value="retour"/>
        <input type="hidden" name="empruntId" value="${empruntRetour.id}"/>
        <div class="flex gap-3">
            <button type="submit" class="bg-green-700 text-white px-5 py-2 rounded-lg hover:bg-green-800 text-sm">Confirmer le retour</button>
            <a href="${pageContext.request.contextPath}/emprunts" class="px-5 py-2 rounded-lg border text-sm hover:bg-gray-100">Annuler</a>
        </div>
    </form>
</div>
</c:when>

<%-- FORM: New emprunt --%>
<c:when test="${param.action == 'new'}">
<div class="bg-white rounded-xl shadow p-6 mb-6 max-w-lg">
    <h3 class="text-lg font-semibold mb-4">Nouvel emprunt</h3>
    <form method="post" action="${pageContext.request.contextPath}/emprunts">
        <input type="hidden" name="action" value="emprunt"/>
        <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Client</label>
            <select name="clientId" required class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none">
                <option value="">-- Sélectionner --</option>
                <c:forEach var="c" items="${clients}">
                    <option value="${c.id}">${c.nomComplet} (${c.email})</option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Livre disponible</label>
            <select name="livreId" required class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none">
                <option value="">-- Sélectionner --</option>
                <c:forEach var="l" items="${livres}">
                    <option value="${l.id}">${l.titre} – ${l.tarifJournalier} MAD/j</option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-1">Durée (jours)</label>
            <input type="number" name="dureeJours" required min="1" max="365" value="7"
                   class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
        </div>
        <div class="flex gap-3">
            <button type="submit" class="bg-blue-800 text-white px-5 py-2 rounded-lg hover:bg-blue-900 text-sm">Créer l'emprunt</button>
            <a href="${pageContext.request.contextPath}/emprunts" class="px-5 py-2 rounded-lg border text-sm hover:bg-gray-100">Annuler</a>
        </div>
    </form>
</div>
</c:when>

<%-- LIST --%>
<c:otherwise>
<form method="get" class="mb-4 flex gap-2 flex-wrap">
    <input type="text" name="q" value="${q}" placeholder="Client ou titre du livre…"
           class="border rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-400 outline-none w-64"/>
    <select name="statut" class="border rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-400 outline-none">
        <option value="">Tous les statuts</option>
        <option value="EN_COURS"  ${statut == 'EN_COURS'  ? 'selected' : ''}>En cours</option>
        <option value="RETOURNE"  ${statut == 'RETOURNE'  ? 'selected' : ''}>Retourné</option>
    </select>
    <button type="submit" class="bg-gray-200 px-4 py-2 rounded-lg text-sm hover:bg-gray-300">Filtrer</button>
</form>
<div class="bg-white rounded-xl shadow overflow-x-auto">
    <table class="w-full text-sm">
        <thead class="bg-blue-900 text-white">
            <tr>
                <th class="px-4 py-3 text-left">Client</th>
                <th class="px-4 py-3 text-left">Livre</th>
                <th class="px-4 py-3 text-left">Début</th>
                <th class="px-4 py-3 text-left">Fin prévue</th>
                <th class="px-4 py-3 text-right">Frais</th>
                <th class="px-4 py-3 text-right">Pénalité</th>
                <th class="px-4 py-3 text-center">Statut</th>
                <th class="px-4 py-3 text-center">Actions</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="e" items="${emprunts}">
            <tr class="border-b hover:bg-gray-50">
                <td class="px-4 py-3">${e.client.nomComplet}</td>
                <td class="px-4 py-3 font-medium">${e.livre.titre}</td>
                <td class="px-4 py-3 text-gray-500">${e.dateDebut}</td>
                <td class="px-4 py-3 text-gray-500">${e.dateFinPrevue}</td>
                <td class="px-4 py-3 text-right">${e.frais} MAD</td>
                <td class="px-4 py-3 text-right ${e.penalite.doubleValue() gt 0 ? 'text-red-600 font-medium' : 'text-gray-400'}">
                    <c:choose>
                        <c:when test="${e.penalite.doubleValue() gt 0}">${e.penalite} MAD</c:when>
                        <c:otherwise>–</c:otherwise>
                    </c:choose>
                </td>
                <td class="px-4 py-3 text-center">
                    <span class="px-2 py-1 rounded-full text-xs font-medium ${e.statut == 'EN_COURS' ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-700'}">
                        ${e.statut == 'EN_COURS' ? 'En cours' : 'Retourné'}
                    </span>
                </td>
                <td class="px-4 py-3 text-center">
                    <c:if test="${e.statut == 'EN_COURS'}">
                        <a href="?action=retour&id=${e.id}" class="text-green-700 hover:underline text-xs font-medium">Retourner</a>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty emprunts}">
            <tr><td colspan="8" class="px-4 py-6 text-center text-gray-400">Aucun emprunt trouvé.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
</c:otherwise>
</c:choose>

</div></body></html>
