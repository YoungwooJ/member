<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 1
	// 로그인이 되어 있을 때는 접근 불가
	if(session.getAttribute("loginMemberId") != null){
		// 로그인이 되지 않은 상태
		response.sendRedirect(request.getContextPath()+"/memberIndex.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>loginForm</title>
	<!-- 부트스트랩5 CDN -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<Style>
		body {
				padding:1.5em;
				background: #f5f5f5
			}
		table {
			border: 1px #BDBDBD solid;
			font-size: .9em;
			box-shadow: 0 2px 5px #BDBDBD;
			width: 100%;
			border-collapse: collapse;
			border-radius: 20px;
			overflow: hidden;
		}
		a {
			text-decoration: none;
		}
		input:hover {
		outline: none !important;
		border-color: rgb(60, 179, 113);
		box-shadow: 0 0 10px rgb(60, 179, 113);
		}
		#verticalMiddle{
			    position: absolute;
			    top: 40%;
			    left: 50%;
			    transform: translate(-50%, -50%);
			}
	</style>
</head>
<body class="container text-center">
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(msg != null) {
	%>
			<div class="text-danger"><%=msg%></div>
	<%		
		}
	%>
	<form action="<%=request.getContextPath()%>/loginAction.jsp" method="post">
		<div class="container w-50" id="verticalMiddle">
			<h2 class="p-3 bg-success text-white rounded">로그인</h2>
			<table class="table">
				<tr>
					<td>회원아이디</td>
					<td><input type="text" name="memberId" value=""></td>
				</tr>
				<tr>
					<td>회원패스워드</td>
					<td><input type="password" name="memberPw" value=""></td>
				</tr>
			</table>
			<button style="float: right;" class="btn btn-outline-warning" type="submit">로그인</button>
			<div>
			<!-- id가 없는 경우 회원가입 부터 -->
			<a style="float: left;" type="button" class="btn btn-white btn-outline-info" href="<%=request.getContextPath()%>/insertMemberForm.jsp">회원가입</a>
			<!--  insertMemberForm.jsp, insertMemberAction.jsp, redirect loginForm.jsp -->
			</div>
		</div>
	</form>
</body>
</html>