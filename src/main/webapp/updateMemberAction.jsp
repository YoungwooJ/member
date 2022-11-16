<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1. 요청 분석(Controller)
	request.setCharacterEncoding("UTF-8");

	String msg = null;
	// 안전장치 코드
	if(request.getParameter("memberId")==null 
			|| request.getParameter("memberPw")==null
			|| request.getParameter("memberName")==null
			|| request.getParameter("newMemberName")==null 
			|| request.getParameter("memberId").equals("") 
			|| request.getParameter("memberPw").equals("")
			|| request.getParameter("memberName").equals("")
			|| request.getParameter("newMemberName").equals("")){
		msg = URLEncoder.encode("회원 정보수정에 실패하였습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/updateMemberForm.jsp?msg="+msg);
		return;
	}
	
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberName = request.getParameter("memberName");
	String newMemberName = request.getParameter("newMemberName");
	
	/* 
	// vo로 묶고 싶다면
	Member member = new Member();
	member.memberId = memberId;
	member.memberName = memberName;
	*/
	
	// 디버깅 코드
	System.out.println(memberId);
	System.out.println(memberPw);
	System.out.println(memberName);
	System.out.println(newMemberName);
	
	// 2. 요청 처리 (Model)
	// db 연결
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://localhost:3306/gdj58";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	// 쿼리
	String sql = null;
	PreparedStatement stmt = null;
	sql = "UPDATE member SET member_name = ? WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, newMemberName);
	stmt.setString(2, memberId);
	stmt.setString(3, memberPw);
	
	int row = stmt.executeUpdate();
	
	if(row==1){
		System.out.println("수정 성공");
		msg = URLEncoder.encode("회원정보가 수정되었습니다.", "utf-8");
		response.sendRedirect(request.getContextPath()+"/memberOne.jsp?msg="+msg);
	} else {
		System.out.println("수정 실패");
		msg = URLEncoder.encode("회원정보수정에 실패하였습니다.", "utf-8");
		System.out.println(memberId+" "+memberPw+" "+ newMemberName);
		response.sendRedirect(request.getContextPath()+"/updateMemberForm.jsp?msg="+msg);
		return;
	}
	
	stmt.close();
	conn.close();
	
	// 3. 출력 (View)
%>