<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1. 요청 분석 (Controller)
	request.setCharacterEncoding("UTF-8");
	// 안전 장치 코드
	if(request.getParameter("memberName")==null||request.getParameter("memberName").equals("")||request.getParameter("memberId")==null || request.getParameter("memberId").equals("")||request.getParameter("memberPw")==null||request.getParameter("memberPw").equals("")){
		String msg = URLEncoder.encode("정보를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?msg="+msg);
		return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberName = request.getParameter("memberName");
	
	/* 
	// vo로 묶고 싶다면
	Member member = new Member();
	member.memberId = memberId;
	member.memberPw = memberPw;
	member.memberName = memberName;
	*/
	
	// 2. 요청 처리 (Model)
	// db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/gdj58";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// id 중복안되게
	String idSql = "SELECT member_id FROM member WHERE member_id = ?"; 
	PreparedStatement idStmt = conn.prepareStatement(idSql);
	idStmt.setString(1, memberId);
	ResultSet rs = idStmt.executeQuery();
	if(rs.next()){
		System.out.println("아이디 중복");
		String msg = URLEncoder.encode("아이디가 중복되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?msg="+msg);

		rs.close();
		idStmt.close();
		conn.close();
		
		return;
	} 
	
	// 쿼리
	String sql = null;
	PreparedStatement stmt = null;
	sql = "INSERT INTO member(member_id, member_pw, member_name) VALUES(?,PASSWORD(?),?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	stmt.setString(3, memberName);
	int row = stmt.executeUpdate();
	if(row==1){
		System.out.println("회원가입 성공");
		String msg = URLEncoder.encode("회원가입이 완료되었습니다.", "utf-8");
		//디버깅 코드
		System.out.println(memberId+" "+memberPw+" "+ memberName);
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp?msg="+msg);
	} else {
		System.out.println("회원가입 실패");
		String msg = URLEncoder.encode("회원가입에 실패하였습니다.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?msg="+msg);
		return;
	}
	
	stmt.close();
	conn.close();
	
	// 3. 출력 (View)
%>