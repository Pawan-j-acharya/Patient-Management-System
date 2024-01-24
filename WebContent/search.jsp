<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Patients Management</title>
    <link rel="stylesheet" href="Views/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css">
    <!-- Material Design Bootstrap -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.8.0/css/mdb.min.css" rel="stylesheet">
    <script src="Components/jquery-3.5.0.min.js"></script>
    <script src="Components/patients.js"></script>

    <style>
        .search-form {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-form input[type="text"] {
            flex-grow: 1;
            margin-right: 10px;
        }

        .table-bordered {
            border: 1px solid #dee2e6;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar fixed-top navbar-expand-lg navbar-dark special-color-dark">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#basicExampleNav" aria-controls="basicExampleNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="basicExampleNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="patients.jsp">Home</a></li>
                <li class="nav-item active"><a class="nav-link" href="managePatients.jsp">Patients Records<span class="sr-only">(current)</span></a></li>
                <li class="nav-item"><a class="nav-link" href="search.jsp">Search</a></li>
            </ul>
        </div>
    </nav><br>

    <div class="container-fluid">
        <!-- Jumbotron -->
        <div class="row">
            <div class="col">
                <div class="jumbotron card card-image mt-5" style="background-image: url(https://mdbootstrap.com/img/Photos/Others/gradient1.jpg);">
                    <div class="text-white text-center py-5 px-4">
                        <div>
                            <h2 class="card-title h1-responsive pt-3 mb-5 font-bold">
                                <strong>Patients Management</strong>
                            </h2>
                        </div>
                    </div>
                </div>
            </div>
        </div>

      <%
    if (request.getParameter("searchQuery") != null) {
        String searchQuery = request.getParameter("searchQuery");
        if (!searchQuery.isEmpty()) {
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                // Database connection
                Class.forName("com.mysql.jdbc.Driver");
                String url = "jdbc:mysql://localhost:3306/patient_management?useSSL=false";
                String username = "root";
                String password = "root";
                con = DriverManager.getConnection(url, username, password);

                ps = con.prepareStatement("SELECT * FROM patients WHERE pNic = ?;");
                ps.setString(1, searchQuery);

                rs = ps.executeQuery();

                if (rs.next()) {
                    rs.beforeFirst();
%>
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th>Patient NIC</th>
                                    <th>Patient Name</th>
                                    <th>Patient Address</th>
                                    <th>Patient Email</th>
                                    <th>Patient Telephone</th>
                                    <th>Patient Age</th>
                                    <th>Patient Status</th>
                                    <th>Patient Allergic</th>
                                    <th>Patient Ward</th>
                                    <th>Patient Bed</th>
                                    <th>Update</th>
                                    <th>Remove</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                while (rs.next()) {
                                %>
                                <tr>
                                    <td><%= rs.getString("pNic") %></td>
                                    <td><%= rs.getString("pName") %></td>
                                    <td><%= rs.getString("pAddress") %></td>
                                    <td><%= rs.getString("pEmail") %></td>
                                    <td><%= rs.getString("pTele") %></td>
                                    <td><%= rs.getString("pAge") %></td>
                                    <td><%= rs.getString("pStatus") %></td>
                                    <td><%= rs.getString("pAllergic") %></td>
                                    <td><%= rs.getString("pWard") %></td>
                                    <td><%= rs.getString("pBed") %></td>
                                    <td><a href="update.jsp"><input name="btnUpdate" type="button" value="Update" class="btnUpdate btn btn-warning btn-sm"></a></td>
                                    <td><input name="btnRemove" type="button" value="Remove" class="btnRemove btn btn-danger btn-sm" data-pid="<%= rs.getString("pID") %>" data-toggle="modal" data-target="#deleteModal"></td>
                                </tr>
                                <%
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
<%
                } else {
                    out.println("<script>alert('Patient not found');</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (ps != null) {
                        ps.close();
                    }
                    if (con != null) {
                        con.close();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    } else {
%>
    <div class="container">
        <form class="form-inline my-2 my-lg-0 search-form" action="search.jsp" method="GET">
            <div class="form-group">
                <label for="inputPassword" class="col-form-label">NIC</label>
                <input type="text" class="form-control" id="inputPassword" name="searchQuery" required>
            </div>
            <button type="submit" class="btn btns">SUBMIT</button>
        </form>
    </div>
<%
    }
%>

<!-- Delete Success Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Delete Success</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>The patient has been successfully deleted.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $(".btnRemove").on("click", function() {
            var pid = $(this).data("pid");
            if (confirm("Are you sure you want to delete this patient?")) {
                $.ajax({
                    url: "delete.jsp",
                    method: "POST",
                    data: { pid: pid },
                    success: function(response) {
                        $("#deleteModal").modal("show");
                    }
                });
            }
        });
    });
</script>

</body>
</html>
