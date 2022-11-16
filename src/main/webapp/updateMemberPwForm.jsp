<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%
	//1. 요청 분석(Controller)
	
	if(session.getAttribute("loginMemberId") == null){
		// 로그인이 되지 않은 상태
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	
	String memberId = request.getParameter("memberId");
	
	// 안전 장치 코드
	if(memberId == null || memberId.equals("")){
		response.sendRedirect(request.getContextPath()+"/memberOne.jsp");
		return;
	}
	
	
	// 2. 업무 처리(Model)
	// db 연결
	String driver	= "org.mariadb.jdbc.Driver";
	String dbUrl	= "jdbc:mariadb://localhost:3306/gdj58";
	String dbUser	= "root";
	String dbPw		= "java1234";
	
	Class.forName(driver); // 외부 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 쿼리
	String sql = "SELECT member_id memberId, member_pw memberPw FROM member WHERE member_id = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	ResultSet rs = stmt.executeQuery();
	
	Member member = null;
	if(rs.next()){
		member = new Member();
		member.memberId = rs.getString("memberId");
		member.memberPw = rs.getString("memberPw");
	}
	
	// 3. 출력(View)
	// 디버깅 코드
	System.out.println("수정할 비밀번호 : " + member.memberPw);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>updateMemberPwForm</title>
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
	</style>
</head>
<body class="container text-center">
	<form action="<%=request.getContextPath()%>/updateMemberPwAction.jsp">
		<h2 class="p-3 bg-success text-white rounded">비밀번호 수정</h2>
		<!-- msg 파라메타값이 있으면 출력 -->
		<%
			String msg = request.getParameter("msg");
			if(msg != null) {
		%>
				<div class="text-danger"><%=msg%></div>
		<%		
			}
		%>
		<table class="table">
			<tr>
				<td class="bg-success text-white">아이디</td>
				<td>
					<input type="text" name="memberId" value="<%=member.memberId%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">기존 비밀번호 확인</td>
				<td>
					<input type="password" name="memberPw" value="">
				</td>
			</tr>
			<tr>
				<td class="bg-success text-white">새로운 비밀번호</td>
				<td>
					<input type="password" name="newMemberPw" value="">
				</td>
			</tr>
		</table>
		<button style="float: right;" class="btn btn-white btn-outline-info" type="submit">비밀번호 변경</button>
	</form>
</body>
</html>