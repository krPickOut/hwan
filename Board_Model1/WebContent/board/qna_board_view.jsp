<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%
Connection con=null;
PreparedStatement pstmt=null;
ResultSet rs=null;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<style type="text/css">
#articleForm{
	width : 500px;
	height : 500px;
	border : 1px solid red;
	margin : auto;
}
h2{
	text-align : center;
}
#baseInfoArea{
	height : 40px;
	text-align : center;
}
#articleContentArea{
	background : orange;
	margin-top : 20px;
	height : 350px;
	text-align : center;
	overflow : auto;
}
#commandList{
	margin : auto;
	width : 500px;
	text-align : center;
}
</style>
</head>
<body>
<%
int board_num = Integer.parseInt(request.getParameter("board_num"));
String nowPage = request.getParameter("page");

try{
	Context initContext = new  InitialContext();
	DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/mySQLDB");
	con=ds.getConnection();
	con.setAutoCommit(false);
	
	int updateCount = 0;
	String sql = "update board set BOARD_READCOUNT = " + "BOARD_READCOUNT+1 where BOARD_NUM=" + board_num;
	pstmt=con.prepareStatement(sql);
	updateCount = pstmt.executeUpdate();
	
	if (updateCount > 0) {
		con.commit();
	
	pstmt = con.prepareStatement("select * from board where board_num=?");
	pstmt.setInt(1, board_num);
	rs = pstmt.executeQuery();
	if(rs.next()){
%>
	<section id="articleForm">
		<h2>글 내용 상세보기</h2>
		<section id="basicInfoArea">
			제 목 : 
			<%=rs.getString("BOARD_SUBJECT") %>
			첨부파일 : 
			<%if(!(rs.getString("BOARD_FILE")==null)) {%>
				<a href="file_down?downFile=<%=rs.getString("BOARD_FILE") %>"><%=rs.getString("BOARD_FILE") %></a>
			<%} %>
		</section>
		<section id="articleContentArea">
			<%=rs.getString("BOARD_CONTENT") %>
		</section>
	</section>
	<section id="commandList">
	<a href="qna_board_reply.jsp?board_num=<%=rs.getInt("board_num") %>&page=<%=nowPage %>">[답변]</a>
	<a href="qna_board_modify.jsp?board_num=<%=rs.getInt("board_num")%>">[수정]</a>
	<a href="qna_board_delete.jsp?board_num=<%=rs.getInt("board_num") %>&page=<%=nowPage %>">[삭제]</a>
	<a href="qna_board_list.jsp?page=<%=nowPage %>">[목록]</a>&nbsp;&nbsp;
	</section>
<%}	
}else{
	con.rollback();
	out.println("<script>");
	out.println("alert('글보기 실패!')");
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
</body>
</html>