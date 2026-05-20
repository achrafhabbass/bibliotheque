<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion – BiblioGest</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-blue-900 min-h-screen flex items-center justify-center">
<div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-10">
    <div class="text-center mb-8">
        <div class="text-5xl mb-3">📚</div>
        <h1 class="text-2xl font-bold text-blue-900">BiblioGest</h1>
        <p class="text-gray-500 text-sm mt-1">Gestion des Bibliothèques</p>
    </div>

    <c:if test="${not empty erreur}">
        <div class="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded-lg text-sm">${erreur}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input type="email" name="email" required
                   class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
        </div>
        <div class="mb-6">
            <label class="block text-sm font-medium text-gray-700 mb-1">Mot de passe</label>
            <input type="password" name="motDePasse" required
                   class="w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"/>
        </div>
        <button type="submit"
                class="w-full bg-blue-800 hover:bg-blue-900 text-white font-semibold py-2 rounded-lg transition">
            Se connecter
        </button>
    </form>
</div>
</body>
</html>
