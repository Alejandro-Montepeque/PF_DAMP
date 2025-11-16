<%-- 
    Document   : footer
    Created on : 7 nov 2025, 5:04:01 p. m.
    Author     : LuisElias
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
</div> <!-- row -->
</div> <!-- container-fluid -->

<footer class="mt-auto py-3">
    <div class="text-center text-muted small">
        © <%= java.time.Year.now()%> - Sistema de Biblioteca | Proyecto Universitario
    </div>
</footer>

<!-- ✅ Bootstrap JS -->
<script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
<script src="${pageContext.request.contextPath}/js/sweetAlerts.js"></script>
</body>
</html>


