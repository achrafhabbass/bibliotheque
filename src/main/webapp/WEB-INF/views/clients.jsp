<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="_nav.jsp"/>

<div class="flex items-center justify-between mb-6">
    <h2 class="text-2xl font-bold text-blue-900">Clients</h2>
    <a href="?action=new" class="bg-blue-800 text-white px-4 py-2 rounded-lg hover:bg-blue-900 text-sm">+ Nouveau</a>
</div>

<c:choose>
<c:when test="${not empty clientEdit or param.action == 'new'}">
<div class="bg-white rounded-xl shadow p-6 mb-6 max-w-lg">
    <h3 class="text-lg font-semibold mb-4">${empty clientEdit ? 'Nouveau client' : 'Modifier client'}</h3>
    <form method="post" action="${pageContext.request.contextPath}/clients">
        <input type="hidden" name="id" value="${clientEdit.id}"/>
        <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nom</label>
                <input type="text" name="nom" value="${clientEdit.nom}" required minlength="2" maxlength="50"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Prénom</label>
                <input type="text" name="prenom" value="${clientEdit.prenom}" required minlength="2" maxlength="50"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
        </div>
        <div class="grid grid-cols-2 gap-4 mb-6">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                <input type="email" name="email" value="${clientEdit.email}" required
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Téléphone</label>
                <input type="text" name="telephone" value="${clientEdit.telephone}" maxlength="20"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
        </div>
        <div class="flex gap-3">
            <button type="submit" class="bg-blue-800 text-white px-5 py-2 rounded-lg hover:bg-blue-900 text-sm">Enregistrer</button>
            <a href="${pageContext.request.contextPath}/clients" class="px-5 py-2 rounded-lg border text-sm hover:bg-gray-100">Annuler</a>
        </div>
    </form>
</div>
</c:when>
<c:otherwise>
<form method="get" class="mb-4 flex gap-2">
    <input type="text" name="q" value="${q}" placeholder="Nom, email, téléphone…"
           class="border rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-400 outline-none w-64"/>
    <button type="submit" class="bg-gray-200 px-4 py-2 rounded-lg text-sm hover:bg-gray-300">Chercher</button>
</form>
<div class="bg-white rounded-xl shadow overflow-hidden">
    <table class="w-full text-sm">
        <thead class="bg-blue-900 text-white">
            <tr>
                <th class="px-4 py-3 text-left">Nom</th>
                <th class="px-4 py-3 text-left">Email</th>
                <th class="px-4 py-3 text-left">Téléphone</th>
                <th class="px-4 py-3 text-center">Actions</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="c" items="${clients}">
            <tr class="border-b hover:bg-gray-50">
                <td class="px-4 py-3 font-medium">${c.nomComplet}</td>
                <td class="px-4 py-3">${c.email}</td>
                <td class="px-4 py-3 text-gray-500">${c.telephone}</td>
                <td class="px-4 py-3 text-center flex gap-2 justify-center">
                    <a href="?action=edit&id=${c.id}" class="text-blue-600 hover:underline">Modifier</a>
                    <form method="post" onsubmit="return confirm('Supprimer ce client ?')">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="${c.id}"/>
                        <button type="submit" class="text-red-600 hover:underline">Supprimer</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty clients}">
            <tr><td colspan="4" class="px-4 py-6 text-center text-gray-400">Aucun client trouvé.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
</c:otherwise>
</c:choose>

</div></body></html>
