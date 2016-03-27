<%@ page contentType="text/html;charset=UTF-8" language="java" %><html><head>    <title>用户管理</title></head><body><div id="deptList">正在努力加载部门信息...</div><div id="userList"></div><script id="deptListFirstTemplate" type="x-tmpl-mustache"><ul>    {{#deptList}}    <li><a id="dept_{{id}}" href="javascript:void(0)" data-id="{{id}}" class="dept-name">{{name}}</a></li>    {{/deptList}}</ul></script><script id="deptListNextTemplate" type="x-tmpl-mustache"><ul>    {{#deptList}}    <li><a id="dept_{{id}}" href="javascript:void(0)" data-id="{{id}}" class="dept-name">{{name}}</a></li>    {{/deptList}}</ul></script><script id="userListTemplate" type="x-tmpl-mustache"><ul>    {{#userList}}    <li><a href="javascript:void(0)" data-id="{{id}}" class="user-name">{{username}}</a></li>    {{/userList}}</ul></script><script type="text/javascript" src="/js/jquery-1.7.2.min.js"></script><script type="text/javascript" src="http://cdn.bootcss.com/mustache.js/2.2.1/mustache.js"></script><script type="text/javascript">    $(function(){        // 预编译需要使用的模板        var deptListFirstTemplate = $('#deptListFirstTemplate').html();        Mustache.parse(deptListFirstTemplate);        var deptListNextTemplate = $('#deptListNextTemplate').html();        Mustache.parse(deptListNextTemplate);        // 加载部门列表        loadDeptList();        function loadDeptList() {            $.ajax({                url: "/sys/dept/tree.json",                success: function (result) {                    if (result.ret) {                        var rendered = Mustache.render(deptListFirstTemplate, {deptList: result.data});                        $('#deptList').html(rendered);                        recursiveRenderDept(result.data);                        bindDeptClick();                    } else {                        $('#deptList').html(result.msg);                    }                }            });        }        function recursiveRenderDept(deptList) {            if (deptList && deptList.length > 0) {                $(deptList).each(function (i, dept) {                    if (dept.deptList.length > 0) {                        var rendered = Mustache.render(deptListNextTemplate, {deptList: dept.deptList});                        $('#dept_' + dept.id).append(rendered);                        recursiveRenderDept(dept.deptList);                    }                });            }        }        function bindDeptClick() {            $(".dept-name").click(function (e) {                e.preventDefault();                e.stopPropagation(); // 此处必须要取消冒泡,因为是个递归结构,冒泡的话会让一个点击被响应多个                loadUserList($(this).attr("data-id"));            });        }        function loadUserList(deptId) {            $.ajax({                url: "/sys/user/list.json",                data: {                    deptId: deptId                },                success: function (result) {                    if (result.ret) {                        var template = $('#userListTemplate').html();                        Mustache.parse(template);                        var rendered = Mustache.render(template, {userList: result.data.data});                        $('#userList').html(rendered);                    } else {                        alert(result.msg);                    }                }            });        }    });</script></body></html>