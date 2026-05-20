<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="_nav.jsp"/>

<div class="flex items-center justify-between mb-6">
    <h2 class="text-2xl font-bold text-blue-900">Livres</h2>
    <a href="?action=new" class="bg-blue-800 text-white px-4 py-2 rounded-lg hover:bg-blue-900 text-sm">+ Nouveau</a>
</div>

<c:choose>
<c:when test="${not empty livreEdit or param.action == 'new'}">
<div class="bg-white rounded-xl shadow p-6 mb-6">
    <h3 class="text-lg font-semibold mb-4">${empty livreEdit ? 'Nouveau livre' : 'Modifier livre'}</h3>
    <form method="post" action="${pageContext.request.contextPath}/livres">
        <input type="hidden" name="id" value="${livreEdit.id}"/>
        <div class="grid grid-cols-2 gap-4 mb-4">
            <div class="col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-1">Titre</label>
                <input type="text" name="titre" value="${livreEdit.titre}" required maxlength="200"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">ISBN</label>
                <input type="text" name="isbn" value="${livreEdit.isbn}" maxlength="20"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tarif journalier (MAD)</label>
                <input type="number" name="tarifJournalier" value="${livreEdit.tarifJournalier}" required min="0.01" step="0.01"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
        </div>
        <div class="grid grid-cols-2 gap-4 mb-6">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Auteurs</label>
                <select name="auteurIds" multiple size="5"
                        class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none">
                    <c:forEach var="a" items="${auteurs}">
                        <option value="${a.id}"
                            <c:forEach var="la" items="${livreEdit.auteurs}">
                                <c:if test="${la.id == a.id}">selected</c:if>
                            </c:forEach>
                        >${a.nomComplet}</option>
                    </c:forEach>
                </select>
                <p class="text-xs text-gray-400 mt-1">Ctrl+clic pour sélectionner plusieurs</p>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Catégories</label>
                <select name="categorieIds" multiple size="5"
                        class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none">
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}"
                            <c:forEach var="lc" items="${livreEdit.categories}">
                                <c:if test="${lc.id == c.id}">selected</c:if>
                            </c:forEach>
                        >${c.nom}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="flex gap-3">
            <button type="submit" class="bg-blue-800 text-white px-5 py-2 rounded-lg hover:bg-blue-900 text-sm">Enregistrer</button>
            <a href="${pageContext.request.contextPath}/livres" class="px-5 py-2 rounded-lg border text-sm hover:bg-gray-100">Annuler</a>
        </div>
    </form>
</div>
</c:when>
<c:otherwise>
<form method="get" class="mb-4 flex gap-2">
    <input type="text" name="q" value="${q}" placeholder="Titre, ISBN, auteur, catégorie…"
           class="border rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-400 outline-none w-72"/>
    <button type="submit" class="bg-gray-200 px-4 py-2 rounded-lg text-sm hover:bg-gray-300">Chercher</button>
</form>
<div class="bg-white rounded-xl shadow overflow-hidden">
    <table class="w-full text-sm">
        <thead class="bg-blue-900 text-white">
            <tr>
                <th class="px-4 py-3 text-left">Titre</th>
                <th class="px-4 py-3 text-left">ISBN</th>
                <th class="px-4 py-3 text-left">Auteurs</th>
                <th class="px-4 py-3 text-left">Catégories</th>
                <th class="px-4 py-3 text-right">Tarif/j</th>
                <th class="px-4 py-3 text-center">Dispo</th>
                <th class="px-4 py-3 text-center">Actions</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="l" items="${livres}">
            <tr class="border-b hover:bg-gray-50">
                <td class="px-4 py-3 font-medium">${l.titre}</td>
                <td class="px-4 py-3 text-gray-500">${l.isbn}</td>
                <td class="px-4 py-3">
                    <c:forEach var="a" items="${l.auteurs}" varStatus="s">${a.nomComplet}<c:if test="${!s.last}">, </c:if></c:forEach>
                </td>
                <td class="px-4 py-3">
                    <c:forEach var="c" items="${l.categories}" varStatus="s">
                        <span class="bg-gray-100 px-2 py-0.5 rounded text-xs">${c.nom}</span>
                    </c:forEach>
                </td>
                <td class="px-4 py-3 text-right">${l.tarifJournalier} MAD</td>
                <td class="px-4 py-3 text-center">
                    <span class="px-2 py-1 rounded-full text-xs font-medium ${l.disponible ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                        ${l.disponible ? 'Oui' : 'Non'}
                    </span>
                </td>
                <td class="px-4 py-3 text-center flex gap-2 justify-center">
                    <a href="?action=edit&id=${l.id}" class="text-blue-600 hover:underline">Modifier</a>
                    <form method="post" onsubmit="return confirm('Supprimer ce livre ?')">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="${l.id}"/>
                        <button type="submit" class="text-red-600 hover:underline">Supprimer</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty livres}">
            <tr><td colspan="7" class="px-4 py-6 text-center text-gray-400">Aucun livre trouvé.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
</c:otherwise>
</c:choose>

</div></body></html>
