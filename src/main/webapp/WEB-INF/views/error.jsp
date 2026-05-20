<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<%
    Integer code = (Integer) request.getAttribute("erreurCode");
    String  msg  = (String)  request.getAttribute("erreurMsg");
    if (code == null && pageContext.getErrorData() != null
            && pageContext.getErrorData().getStatusCode() != 0)
        code = pageContext.getErrorData().getStatusCode();
    if (msg == null && pageContext.getErrorData() != null
            && pageContext.getErrorData().getThrowable() != null)
        msg = pageContext.getErrorData().getThrowable().getMessage();
    if (code == null) code = 500;
    if (msg  == null || msg.isBlank()) msg = "Une erreur inattendue s'est produite.";
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Erreur <%= code %> – BiblioGest</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
<div class="bg-white rounded-2xl shadow-xl p-12 max-w-lg text-center">
    <div class="text-6xl mb-4">⚠️</div>
    <h1 class="text-5xl font-bold text-gray-800 mb-3"><%= code %></h1>
    <p class="text-gray-500 mb-6"><%= msg.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;") %></p>
    <a href="<%= request.getContextPath() %>/livres"
       class="inline-block bg-blue-800 text-white px-6 py-2 rounded-lg hover:bg-blue-900 transition text-sm">
        Retour à l'accueil
    </a>
</div>
</body>
</html>
