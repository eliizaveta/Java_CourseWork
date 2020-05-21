<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<!DOCTYPE HTML>
<html>
<head>
    <title>HOME</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/style.css">
</head>
<body>

<div><h1>Lisa's Auto Park</h1></div>
<div>
    <h3>${pageContext.request.userPrincipal.name}
        <sec:authorize access="isAuthenticated()">
        <a href="/logout" class="button gray">Log Out</a>
        </sec:authorize>
    </h3>

    <sec:authorize access="!isAuthenticated()">
        <a href="/login" class="button gray">Log In</a>
    </sec:authorize>
</div>

<div>
    <sec:authorize access="hasAuthority('USER')">
        <a href="/start" class="button green">Start driving</a>
        <button id="end_button" class="button red">Stop trip</button>
    </sec:authorize>
</div>

<div>
    <sec:authorize access="!isAuthenticated()">
        <a href="/registration" class="button gray">Registration</a>
    </sec:authorize>
</div>

<div>
    <sec:authorize access="hasAuthority('ADMIN')">
        <a href="/journal" class="button gray">Journal</a>
    </sec:authorize>
</div>
<div>
    <sec:authorize access="hasAuthority('ADMIN')">
        <a href="/cars" class="button gray">Cars</a>
    </sec:authorize>
</div>
<div>
    <sec:authorize access="hasAuthority('ADMIN')">
        <a href="/routes" class="button gray">Routes</a>
    </sec:authorize>
</div>
<div>
    <sec:authorize access="hasAuthority('ADMIN')">
        <a href="/users" class="button gray">Users</a>
    </sec:authorize>
</div>

<script>
    document.getElementById('hider').onclick = function deleteAll() {
        fetch('/users/get/user', {
            method: 'get'
        })
            .then(res => res.json())
            .then(function (data) {
                console.log('Add car request succeeded with JSON response', data);
                document.getElementById('text').hidden = true;
                document.location.reload()
            })
            .catch(function (error) {
                console.error('Request FAILED ', error);
                document.getElementById('text').hidden = false;
                document.location.reload()
            });
    }
</script>

<script>
    document.getElementById('end_button').onclick = function endJournal() {

        let tmp = {
            id: 0
        }
                     fetch('/journal/end', {
                    method: 'post',
                    headers: {
                        'Content-Type': 'application/json;charset=utf-8'
                    },
                    body: JSON.stringify(tmp)
                })
                    .then(res => res.json())
                    .then(function (data) {
                        console.log('Add sale request succeeded with JSON response', data);
                        if (data.success === false) {
                            alert(data.error)
                        } else {
                            document.location.reload()
                        }
                    })
                    .catch(function (error) {
                        console.error('Request FAILED ', error);
                    });
    }
</script>

</body>
</html>