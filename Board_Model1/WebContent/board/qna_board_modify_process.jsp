<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%
String nowPage=request.getParameter("page");
int board_num = Integer.parseInt(request.getParameter("BOARD_NUM"));
String pass = request.getParameter("BOARD_PASS");
String subject = request.getParameter("BOARD_SUBJECT");
String content = request.getParameter("BOARD_CONTENT");

Connection con=null;
PreparedStatement pstmt=null;
ResultSet rs = null;

try{
	Context initContext = new  InitialContext();
	DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/mySQLDB");
	con=ds.getConnection();
	con.setAutoCommit(false);
	
	pstmt=con.prepareStatement("select * from board where BOARD_NUM=?");
	pstmt.setInt(1, board_num);
	rs=pstmt.executeQuery();
	
	if(rs.next()){
		if(pass.equals(rs.getString("BOARD_PASS"))){
			String sql = "update board set board_subject=?,board_content=? where board_num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, subject);
			pstmt.setString(2, content);
			pstmt.setInt(3, board_num);
			int updateCount = pstmt.executeUpdate();
			if(updateCount>0){
				con.commit();
				out.println("<script>");
				out.println("alert('수정되었습니다.');");
				out.println("location.href='qna_board_view.jsp?board_num="+board_num+"&page="+nowPage+"';");
				out.println("</script>");
			}else{
				con.rollback();
				out.println("<script>");
				out.println("alert('수정 실패.');");
				out.println("history.back();");
				out.println("</script>");
			}
		}else{
			out.println("<script>");
			out.println("alert('수정할권한이 없습니다.');");
			out.println("history.back();");
			out.println("</script>");
		}
	}else{
		out.println("<script>");
		out.println("alert('잘못된 글번호입니다.');");
		out.println("history.back();");
		out.println("</script>");
	}
}catch(Exception e){
	con.rollback();
	e.printStackTrace();
}finally{
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();
	if(con!=null)con.close();
}
%>