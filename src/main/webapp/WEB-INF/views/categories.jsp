<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="_nav.jsp"/>

<div class="flex items-center justify-between mb-6">
    <h2 class="text-2xl font-bold text-blue-900">Catégories</h2>
    <a href="?action=new" class="bg-blue-800 text-white px-4 py-2 rounded-lg hover:bg-blue-900 text-sm">+ Nouvelle</a>
</div>

<c:if test="${not empty categorieEdit or param.action == 'new'}">
<div class="bg-white rounded-xl shadow p-6 mb-6 max-w-sm">
    <h3 class="text-lg font-semibold mb-4">${empty categorieEdit ? 'Nouvelle catégorie' : 'Modifier catégorie'}</h3>
    <form method="post" action="${pageContext.request.contextPath}/categories">
        <input type="hidden" name="id" value="${categorieEdit.id}"/>
        <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-1">Nom</label>
            <input type="text" name="nom" value="${categorieEdit.nom}" required minlength="2" maxlength="50"
                   class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
        </div>
        <div class="flex gap-3">
            <button type="submit" class="bg-blue-800 text-white px-5 py-2 rounded-lg hover:bg-blue-900 text-sm">Enregistrer</button>
            <a href="${pageContext.request.contextPath}/categories" class="px-5 py-2 rounded-lg border text-sm hover:bg-gray-100">Annuler</a>
        </div>
    </form>
</div>
</c:if>

<form method="get" class="mb-4 flex gap-2">
    <input type="text" name="q" value="${q}" placeholder="Rechercher…"
           class="border rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-400 outline-none w-64"/>
    <button type="submit" class="bg-gray-200 px-4 py-2 rounded-lg text-sm hover:bg-gray-300">Chercher</button>
</form>
<div class="bg-white rounded-xl shadow overflow-hidden max-w-lg">
    <table class="w-full text-sm">
        <thead class="bg-blue-900 text-white">
            <tr>
                <th class="px-4 py-3 text-left">Nom</th>
                <th class="px-4 py-3 text-center">Actions</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="c" items="${categories}">
            <tr class="border-b hover:bg-gray-50">
                <td class="px-4 py-3">${c.nom}</td>
                <td class="px-4 py-3 text-center flex gap-2 justify-center">
                    <a href="?action=edit&id=${c.id}" class="text-blue-600 hover:underline">Modifier</a>
                    <form method="post" onsubmit="return confirm('Supprimer cette catégorie ?')">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="${c.id}"/>
                        <button type="submit" class="text-red-600 hover:underline">Supprimer</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty categories}">
            <tr><td colspan="2" class="px-4 py-6 text-center text-gray-400">Aucune catégorie trouvée.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>

</div></body></html>
