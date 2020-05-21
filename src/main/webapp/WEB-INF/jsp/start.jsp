<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Start driving</title>
    <link rel="stylesheet" type="text/css" href="../../resources/css/style.css">
    <link rel="stylesheet" type="text/css" href="../../resources/css/table.css">
</head>
<body>
<div>
    <h2>Start driving<a href="/" class="button brown">Home</a></h2>
</div>


<div>
    <div>
        <div>
            <input id="road_id" name="road_id" type="number" placeholder="Road ID" disabled="disabled" visibility="hidden"/>
        </div>
    </div>
</div>

<div>
    <h3>List of all routes</h3>
    <select id="sort_column_select1">
        <option disabled selected value> Sort by </option>
        <option value="1">ID</option>
        <option value="2">Name</option>

    </select>
    <select id="sort_type_select1">
        <option value="1">Ascending</option>
        <option value="2">Descending</option>
    </select>

    <table id='routes'>
        <tbody>
        <th>ID</th>
        <th>Name</th>
        </tbody>
    </table>
</div>

<div>
    <h3>List of all cars</h3>

    <select id="sort_column_select">
        <option disabled selected value> Sort by </option>
        <option value="1">ID</option>
        <option value="2">Number</option>
        <option value="3">Color</option>
        <option value="4">Mark</option>
    </select>
    <select id="sort_type_select">
        <option value="1">Ascending</option>
        <option value="2">Descending</option>
    </select>

    <table id='cars'>
        <tbody>
        <th>ID</th>
        <th>Number</th>
        <th>Color</th>
        <th>Mark</th>
        <th>User</th>
        </tbody>
    </table>
</div>


<script>
    window.onload = function initTable() {
        let table = document.getElementById('cars');

        fetch('/cars/get/all', {
            method: 'get'
        })
            .then(res => res.json())
            .then(function (tableInitData) {
                console.log('Get cars request succeeded with JSON response', tableInitData);

                let tbody = table.getElementsByTagName("TBODY")[0];

                for (let index = 0; index < tableInitData.length; index++) {
                    let row = document.createElement("TR")
                    let td1 = document.createElement("TD")
                    td1.appendChild(document.createTextNode(tableInitData[index].id))
                    let td2 = document.createElement("TD")
                    td2.appendChild(document.createTextNode(tableInitData[index].num))
                    let td3 = document.createElement("TD")
                    td3.appendChild(document.createTextNode(tableInitData[index].color))
                    let td4 = document.createElement("TD")
                    td4.appendChild(document.createTextNode(tableInitData[index].mark))
                    let td5 = document.createElement("TD")
                    let tmp = (tableInitData[index].person == null) ? "FREE" : tableInitData[index].person.username
                    td5.appendChild(document.createTextNode(tmp))

                    row.appendChild(td1);
                    row.appendChild(td2);
                    row.appendChild(td3);
                    row.appendChild(td4);
                    row.appendChild(td5);
                    tbody.appendChild(row);

                    row.onclick = function(element) {

                        if (document.getElementById('road_id').value.trim() === '') {
                            alert("You did not choose the road");
                            return;
                        }

                        if (tableInitData[index].person != null) {
                            alert("BUSY");
                            return;
                        }
                            let car = {
                            id: tableInitData[index].id,
                            num: tableInitData[index].num,
                            color: tableInitData[index].color,
                            mark: tableInitData[index].mark,
                        };

                        fetch('/cars/user', {
                            method: 'post',
                            headers: {
                                'Content-Type': 'application/json;charset=utf-8'
                            },
                            body: JSON.stringify(car)
                        })
                            .then(res => res.json())
                            .then(function (data) {
                                console.log('User request succeeded with JSON response', data);
                                if (data.success === false) {
                                    alert(data.error);

                                } else {

                                    let route = {
                                        id: document.getElementById('road_id').value.trim()
                                    };
                                    let auto = {
                                        id: tableInitData[index].id
                                    };
                                    let journal = {
                                        auto: auto,
                                        route: route
                                    };
                                    fetch('/journal/add', {
                                        method: 'post',
                                        headers: {
                                            'Content-Type': 'application/json;charset=utf-8'
                                        },
                                        body: JSON.stringify(journal)
                                    })
                                        .then(res => res.json())
                                        .then(function (data) {
                                            console.log('Add sale request succeeded with JSON response', data);
                                            if (data.success === false) {
                                                alert(data.error)
                                            } else {
                                                document.location.replace('/');
                                                alert("Have a nice trip!")
                                            }
                                        })
                                        .catch(function (error) {
                                            console.error('Request FAILED ', error);
                                        });

                                }
                            })
                            .catch(function (error) {
                                console.error('Request FAILED ', error);
                            });
                    }
                }
            })
            .catch(function (error) {
                console.error('Request FAILED ', error);
            });


        let table1 = document.getElementById('routes');
        fetch('/routes/get/all', {
            method: 'get'
        })
            .then(res => res.json())
            .then(function (tableInitData) {
                console.log('Get routes request succeeded with JSON response', tableInitData);

                let tbody = table1.getElementsByTagName("TBODY")[0];

                for (let index = 0; index < tableInitData.length; index++) {
                    let row = document.createElement("TR")
                    let td1 = document.createElement("TD")
                    td1.appendChild(document.createTextNode(tableInitData[index].id))
                    let td2 = document.createElement("TD")
                    td2.appendChild(document.createTextNode(tableInitData[index].name))

                    row.appendChild(td1);
                    row.appendChild(td2);
                    tbody.appendChild(row);

                    row.onclick = function(element) {
                        document.getElementById('road_id').value = tableInitData[index].id;
                    }
                }
            })
            .catch(function (error) {
                console.error('Request FAILED ', error);
            });
    }
</script>

</body>
</html>