<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="_nav.jsp"/>

<div class="flex items-center justify-between mb-6">
    <h2 class="text-2xl font-bold text-blue-900">Auteurs</h2>
    <a href="?action=new" class="bg-blue-800 text-white px-4 py-2 rounded-lg hover:bg-blue-900 text-sm">+ Nouveau</a>
</div>

<c:if test="${not empty auteurEdit or param.action == 'new'}">
<div class="bg-white rounded-xl shadow p-6 mb-6 max-w-md">
    <h3 class="text-lg font-semibold mb-4">${empty auteurEdit ? 'Nouvel auteur' : 'Modifier auteur'}</h3>
    <form method="post" action="${pageContext.request.contextPath}/auteurs">
        <input type="hidden" name="id" value="${auteurEdit.id}"/>
        <div class="grid grid-cols-2 gap-4 mb-6">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nom</label>
                <input type="text" name="nom" value="${auteurEdit.nom}" required minlength="2" maxlength="50"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Prénom</label>
                <input type="text" name="prenom" value="${auteurEdit.prenom}" required minlength="2" maxlength="50"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
        </div>
        <div class="flex gap-3">
            <button type="submit" class="bg-blue-800 text-white px-5 py-2 rounded-lg hover:bg-blue-900 text-sm">Enregistrer</button>
            <a href="${pageContext.request.contextPath}/auteurs" class="px-5 py-2 rounded-lg border text-sm hover:bg-gray-100">Annuler</a>
        </div>
    </form>
</div>
</c:if>

<form method="get" class="mb-4 flex gap-2">
    <input type="text" name="q" value="${q}" placeholder="Rechercher par nom…"
           class="border rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-400 outline-none w-64"/>
    <button type="submit" class="bg-gray-200 px-4 py-2 rounded-lg text-sm hover:bg-gray-300">Chercher</button>
</form>
<div class="bg-white rounded-xl shadow overflow-hidden">
    <table class="w-full text-sm">
        <thead class="bg-blue-900 text-white">
            <tr>
                <th class="px-4 py-3 text-left">Nom complet</th>
                <th class="px-4 py-3 text-center">Actions</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${auteurs}">
            <tr class="border-b hover:bg-gray-50">
                <td class="px-4 py-3">${a.nomComplet}</td>
                <td class="px-4 py-3 text-center flex gap-2 justify-center">
                    <a href="?action=edit&id=${a.id}" class="text-blue-600 hover:underline">Modifier</a>
                    <form method="post" onsubmit="return confirm('Supprimer cet auteur ?')">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="${a.id}"/>
                        <button type="submit" class="text-red-600 hover:underline">Supprimer</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty auteurs}">
            <tr><td colspan="2" class="px-4 py-6 text-center text-gray-400">Aucun auteur trouvé.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>

</div></body></html>
