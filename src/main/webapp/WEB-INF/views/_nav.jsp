<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Bibliothèques</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">

<nav class="bg-blue-900 text-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 flex items-center justify-between h-16">
        <a href="${pageContext.request.contextPath}/livres" class="text-xl font-bold tracking-wide">📚 BiblioGest</a>
        <div class="flex items-center gap-6 text-sm">
            <a href="${pageContext.request.contextPath}/livres"      class="hover:text-blue-300 transition">Livres</a>
            <a href="${pageContext.request.contextPath}/auteurs"     class="hover:text-blue-300 transition">Auteurs</a>
            <a href="${pageContext.request.contextPath}/categories"  class="hover:text-blue-300 transition">Catégories</a>
            <a href="${pageContext.request.contextPath}/clients"     class="hover:text-blue-300 transition">Clients</a>
            <a href="${pageContext.request.contextPath}/emprunts"    class="hover:text-blue-300 transition">Emprunts</a>
            <c:if test="${sessionScope.utilisateur.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/utilisateurs" class="hover:text-blue-300 transition">Utilisateurs</a>
            </c:if>
            <span class="text-blue-300">|</span>
            <span class="text-blue-200 text-xs">${sessionScope.utilisateur.nomComplet}</span>
            <a href="${pageContext.request.contextPath}/logout" class="bg-red-600 hover:bg-red-700 px-3 py-1 rounded text-xs transition">Déconnexion</a>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 py-6">

<c:if test="${not empty sessionScope.succes}">
    <div class="mb-4 p-4 bg-green-100 border border-green-400 text-green-800 rounded-lg flex justify-between">
        <span>${sessionScope.succes}</span>
        <button onclick="this.parentElement.remove()" class="font-bold">✕</button>
    </div>
    <c:remove var="succes" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.erreur}">
    <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-800 rounded-lg flex justify-between">
        <span>${sessionScope.erreur}</span>
        <button onclick="this.parentElement.remove()" class="font-bold">✕</button>
    </div>
    <c:remove var="erreur" scope="session"/>
</c:if>
