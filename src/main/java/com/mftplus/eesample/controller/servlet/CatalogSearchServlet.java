package com.mftplus.eesample.controller.servlet;

import com.mftplus.eesample.model.entity.IrcCatalogItem;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = "/admin/catalog/search")
public class CatalogSearchServlet extends HttpServlet {

    @PersistenceContext(unitName = "mft")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        List<IrcCatalogItem> results = List.of();
        if (q != null && !q.isBlank()) {
            results = em.createQuery(
                            "select i from IrcCatalogItem i " +
                                    "where lower(i.ircCode) like :q or lower(i.itemName) like :q",
                            IrcCatalogItem.class)
                    .setParameter("q", "%" + q.toLowerCase() + "%")
                    .setMaxResults(200)
                    .getResultList();
        }
        req.setAttribute("results", results);
        req.getRequestDispatcher("/WEB-INF/jsp/admin.jsp#search").forward(req, resp);
    }
}
