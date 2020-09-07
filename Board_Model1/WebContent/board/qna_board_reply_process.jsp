<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%
request.setCharacterEncoding("UTF-8");
String nowPage = request.getParameter("page");

int board_num = Integer.parseInt(request.getParameter("BOARD_NUM"));
String board_name = request.getParameter("BOARD_NAME");
String board_pass = request.getParameter("BOARD_PASS");
String board_subject = request.getParameter("BOARD_SUBJECT");
String board_content = request.getParameter("BOARD_CONTENT");
int board_re_ref = Integer.parseInt(request.getParameter("BOARD_RE_REF"));
int board_re_lev = Integer.parseInt(request.getParameter("BOARD_RE_LEV"));
int board_re_seq = Integer.parseInt(request.getParameter("BOARD_RE_SEQ"));

Connection con=null;
PreparedStatement pstmt=null;
ResultSet rs=null;

try{
	Context initContext = new  InitialContext();
	DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/mySQLDB");
	con=ds.getConnection();
	con.setAutoCommit(false);
	
	String board_max_sql="select max(board_num) from board";
	pstmt = con.prepareStatement(board_max_sql);
	rs = pstmt.executeQuery();
	int num = 1;
	if(rs.next())num =rs.getInt(1)+1;
	
	String sql="update board set BOARD_RE_SEQ=BOARD_RE_SEQ+1 "
				+ " where BOARD_RE_REF=? and BOARD_RE_SEQ>?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, board_re_ref);
	pstmt.setInt(2, board_re_seq);
	int updateCount = pstmt.executeUpdate();
	if(updateCount>0){
		con.commit();
	}
	board_re_seq=board_re_seq +1;
	board_re_lev=board_re_lev+1;
	sql="insert into board (BOARD_NUM, BOARD_NAME, BOARD_PASS,BOARD_SUBJECT, ";
	sql+="BOARD_CONTENT, BOARD_FILE, BOARD_RE_REF, BOARD_RE_LEV, BOARD_RE_SEQ, ";
	sql+="BOARD_READCOUNT, BOARD_DATE) values(?,?,?,?,?,?,?,?,?,?,now())";
	pstmt = con.prepareStatement(sql);
	
	pstmt.setInt(1,num);
	pstmt.setString(2, board_name);
	pstmt.setString(3, board_pass);
	pstmt.setString(4, board_subject);
	pstmt.setString(5, board_content);
	pstmt.setString(6, "");
	pstmt.setInt(7,board_re_ref);
	pstmt.setInt(8,board_re_lev);
	pstmt.setInt(9,board_re_seq);
	pstmt.setInt(10,0);
	int insertCount = pstmt.executeUpdate();
	
	if(insertCount>0){
		con.commit();
		out.println("<script>");
		out.println("alert('답글이 등록되었습니다.')");
		out.println("location.href='qna_board_list.jsp?page="+nowPage+"';");
		out.println("</script>");
	}else{
		con.rollback();
		out.println("<script>");
		out.println("alert('답글이 등록이 실패했습니다.')");
		out.println("history.back()");
		out.println("</script>");
	}
}catch(Exception e){
	e.printStackTrace();
}finally{
	if(rs!=null)rs.close();
	if(pstmt!=null)pstmt.close();
	if(con!=null)con.close();
} 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>