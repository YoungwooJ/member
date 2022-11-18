<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "vo.*"%>
<%
	//1
	
	if(session.getAttribute("loginMemberId") == null){
		// 로그인이 되지 않은 상태
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	String loginMemberId = (String)(session.getAttribute("loginMemberId"));
	System.out.println(loginMemberId);
	
	//2. 요청 처리 (Model)
	// db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/gdj58";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 쿼리
	String sql = "SELECT member_id memberId, member_pw memberPw, member_name memberName FROM member WHERE member_id = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, loginMemberId);
	ResultSet rs = stmt.executeQuery();
	Member member = null;
	if(rs.next()){
		member = new Member();
		member.setMemberId(rs.getString("memberId"));
		member.setMemberPw(rs.getString("memberPw"));
		member.setMemberName(rs.getString("memberName"));
	}
 %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>memberOne</title>
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
	<h2 class="p-3 bg-success text-white rounded">내정보</h2>
	<!-- msg 파라메타값이 있으면 출력 -->
	<%
		String msg = request.getParameter("msg");
		if(msg != null) {
	%>
			<div class="text-info"><%=msg%></div>
	<%		
		}
	%>
	<!-- 비밀번호를 제외한 모든 정보(컬럼) 출력 -->
	<table class="table">
		<tr>
			<td>회원아이디</td>
			<td><%=member.getMemberId()%></td>
		</tr>
		<tr>
			<td>회원이름</td>
			<td><%=member.getMemberName()%></td>
		</tr>
	</table>
	<br><br>
	<div>
		<a style="float: left;" type="button" class="btn btn-white btn-outline-info" href="<%=request.getContextPath()%>/updateMemberPwForm.jsp?memberId=<%=member.getMemberId()%>">비밀번호수정</a>
		<!-- updateMemberPwAction.jsp 수정 전 비밀번호, 변경할 비밀번호를 입력받아야 함-->
	</div>
	<div>
		<a style="float: left;" type="button" class="btn btn-white btn-outline-info" href="<%=request.getContextPath()%>/updateMemberForm.jsp?memberId=<%=member.getMemberId()%>">개인정보수정</a>
		<!-- updateMemberAction.jsp 비밀번호 수정은 안됨-->
	</div>
	<div>
		<a style="float: right;" type="button" class="btn btn-white btn-outline-danger" href="<%=request.getContextPath()%>/deleteMemberForm.jsp?memberId=<%=member.getMemberId()%>">회원탈퇴</a>
		<!-- deleteMemberAction.jsp 비밀번호 확인 후 삭제 session.invalidate()-->
	</div>
</body>
</html>