<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	//1. 요청 분석 (Controller)
	request.setCharacterEncoding("UTF-8");
	
	//안전 장치 코드
	if(request.getParameter("memberId")==null 
			|| request.getParameter("memberPw")==null
			|| request.getParameter("memberId").equals("") 
			|| request.getParameter("memberPw").equals("")){
		String msg = URLEncoder.encode("정보를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	/*
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	*/
	Member member	= new Member();
	member.memberId	= request.getParameter("memberId");
	member.memberPw	= request.getParameter("memberPw");
	System.out.print(member.memberId + " <--- ID");
	System.out.print(member.memberPw + " <--- PW");
	
	// 2
	// db연결
	String driver	= "org.mariadb.jdbc.Driver";
	String dbUrl	= "jdbc:mariadb://localhost:3306/gdj58";
	String dbUser	= "root";
	String dbPw		= "java1234";
	
	Class.forName(driver); // 외부 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw); // db 연결
	/*
		SELECT member_id memberId
		FROM MEMBER
		WHERE member_id=? AND member_pw=PASSWORD(?);
	*/
	
	// 쿼리
	String sql = "SELECT member_id memberId FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, member.memberId);
	stmt.setString(2, member.memberPw);
	ResultSet rs = stmt.executeQuery();
	
	String targetPage = "/loginForm.jsp";
	
	if(rs.next()) {
		// 로그인 성공
		System.out.println("success");
		targetPage = "/memberIndex.jsp";
		// 로그인 성공했다는 값을 저장 -> session 
		session.setAttribute("loginMemberId", rs.getString("memberId")); 
		// Object loginMemberId = rs.getString("memberId"); // 다형성 + 연산자 오버로딩
		// Object 타입을 대입할 떄는 상관 없지만 가져올 때는 형변환 필수, 다형성 -> 상속이 되야 한다 -> 참조타입을 만드려면 추상화 / 캡슐
		// String loginMemberId = (String)(session.getAttribute("loginMemberId"));
	}	
	rs.close();
	stmt.close();
	conn.close();
	response.sendRedirect(request.getContextPath()+targetPage);
%>