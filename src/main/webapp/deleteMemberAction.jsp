<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	//1. 요청 분석(Controller)
	request.setCharacterEncoding("utf-8");
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	String msg = null;
	//디버깅 코드
	System.out.println(memberId);
	System.out.println(memberPw);
	
	//안전장치 코드
	if(memberPw == null || memberPw.equals("")) {
		msg = URLEncoder.encode("비밀번호를 입력하세요.", "utf-8"); // get 방식 주소창에 문자열 인코딩 
		response.sendRedirect(request.getContextPath()+"/deleteMemberForm.jsp?memberId="+memberId+"&msg="+msg);
		return;
	}
	
	Member member	= new Member();
	member.setMemberId(memberId);
	member.setMemberPw(memberPw);
	System.out.print(member.getMemberId() + " <--- ID");
	System.out.print(member.getMemberPw() + " <--- PW");
	
	// 2
	String driver	= "org.mariadb.jdbc.Driver";
	String dbUrl	= "jdbc:mariadb://localhost:3306/gdj58";
	String dbUser	= "root";
	String dbPw		= "java1234";
	
	Class.forName(driver); // 외부 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw); // db 연결
	
	String sql = "DELETE FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, member.getMemberId());
	stmt.setString(2, member.getMemberPw());
	int row = stmt.executeUpdate();
	
	
	String targetPage = "/deleteMemberForm.jsp";
	
	if(row == 1) {
		// 로그인 성공
		System.out.println("삭제 성공");
		msg = URLEncoder.encode("회원탈퇴가 완료되었습니다.", "utf-8");
		targetPage = "/loginForm.jsp";
		session.invalidate();
	} else {
		System.out.println("삭제실패");	
		msg = URLEncoder.encode("비밀번호를 확인하세요.", "utf-8");
	}
	
	stmt.close();
	conn.close();
	response.sendRedirect(request.getContextPath()+targetPage+"?memberId="+memberId+"&msg="+msg);
%>