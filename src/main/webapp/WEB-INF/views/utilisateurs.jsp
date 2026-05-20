<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="_nav.jsp"/>

<div class="flex items-center justify-between mb-6">
    <h2 class="text-2xl font-bold text-blue-900">Utilisateurs</h2>
    <a href="?action=new" class="bg-blue-800 text-white px-4 py-2 rounded-lg hover:bg-blue-900 text-sm">+ Nouveau</a>
</div>

<c:choose>
<c:when test="${not empty utilisateurEdit or param.action == 'new'}">
<div class="bg-white rounded-xl shadow p-6 mb-6 max-w-lg">
    <h3 class="text-lg font-semibold mb-4">${empty utilisateurEdit ? 'Nouvel utilisateur' : 'Modifier utilisateur'}</h3>
    <form method="post" action="${pageContext.request.contextPath}/utilisateurs">
        <input type="hidden" name="id" value="${utilisateurEdit.id}"/>
        <div class="grid grid-cols-2 gap-4 mb-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nom</label>
                <input type="text" name="nom" value="${utilisateurEdit.nom}" required minlength="2" maxlength="50"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Prénom</label>
                <input type="text" name="prenom" value="${utilisateurEdit.prenom}" required minlength="2" maxlength="50"
                       class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
            </div>
        </div>
        <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input type="email" name="email" value="${utilisateurEdit.email}" required
                   class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
        </div>
        <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Mot de passe${not empty utilisateurEdit ? ' (laisser vide pour ne pas changer)' : ''}</label>
            <input type="password" name="motDePasse" ${empty utilisateurEdit ? 'required' : ''}
                   class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none"/>
        </div>
        <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-1">Rôle</label>
            <select name="role" class="w-full border rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-400 outline-none">
                <option value="MANAGER" ${utilisateurEdit.role == 'MANAGER' ? 'selected' : ''}>Manager</option>
                <option value="ADMIN"   ${utilisateurEdit.role == 'ADMIN'   ? 'selected' : ''}>Admin</option>
            </select>
        </div>
        <div class="flex gap-3">
            <button type="submit" class="bg-blue-800 text-white px-5 py-2 rounded-lg hover:bg-blue-900 text-sm">Enregistrer</button>
            <a href="${pageContext.request.contextPath}/utilisateurs" class="px-5 py-2 rounded-lg border text-sm hover:bg-gray-100">Annuler</a>
        </div>
    </form>
</div>
</c:when>
<c:otherwise>
<form method="get" class="mb-4 flex gap-2">
    <input type="text" name="q" value="${q}" placeholder="Rechercher…"
           class="border rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-blue-400 outline-none w-64"/>
    <button type="submit" class="bg-gray-200 px-4 py-2 rounded-lg text-sm hover:bg-gray-300">Chercher</button>
</form>
<div class="bg-white rounded-xl shadow overflow-hidden">
    <table class="w-full text-sm">
        <thead class="bg-blue-900 text-white">
            <tr>
                <th class="px-4 py-3 text-left">Nom</th>
                <th class="px-4 py-3 text-left">Email</th>
                <th class="px-4 py-3 text-left">Rôle</th>
                <th class="px-4 py-3 text-center">Actions</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${utilisateurs}">
            <tr class="border-b hover:bg-gray-50">
                <td class="px-4 py-3">${u.nomComplet}</td>
                <td class="px-4 py-3">${u.email}</td>
                <td class="px-4 py-3">
                    <span class="px-2 py-1 rounded-full text-xs font-medium ${u.role == 'ADMIN' ? 'bg-purple-100 text-purple-800' : 'bg-blue-100 text-blue-800'}">${u.role}</span>
                </td>
                <td class="px-4 py-3 text-center flex gap-2 justify-center">
                    <a href="?action=edit&id=${u.id}" class="text-blue-600 hover:underline">Modifier</a>
                    <form method="post" onsubmit="return confirm('Supprimer cet utilisateur ?')">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="${u.id}"/>
                        <button type="submit" class="text-red-600 hover:underline">Supprimer</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty utilisateurs}">
            <tr><td colspan="4" class="px-4 py-6 text-center text-gray-400">Aucun utilisateur trouvé.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
</c:otherwise>
</c:choose>

</div></body></html>
