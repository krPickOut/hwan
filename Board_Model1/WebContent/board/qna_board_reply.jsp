<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%
	int board_num = Integer.parseInt(request.getParameter("board_num"));
	String nowPage = request.getParameter("page");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC게시판</title>
<script language="javascript">
</script>
<style type="text/css">
#registForm{
	width : 500px;
	height : 610px;
	border : 1px solid red;
	margin : auto;
}
h2{
	text-align : center;
}
table{
	margin : auto;
	width : 450px;
}
.td_left{
	width : 150px;
	background : orange;
}
.td_right{
	width : 300px;
	background : skyblue;
}
#commandCell{
	text-align : center;
}
</style>
</head>
<body>

<%
Connection con=null;
PreparedStatement pstmt=null;
ResultSet rs=null;

try{
	Context initContext = new  InitialContext();
	DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/mySQLDB");
	con=ds.getConnection();
	con.setAutoCommit(false);
	pstmt=con.prepareStatement("select * from board where board_num=?");
	pstmt.setInt(1, board_num);
	rs=pstmt.executeQuery();
	
	if(rs.next()){
%>
	<section id="writeForm">
		<h2>게시판글등록</h2>
		<form action="qna_board_reply_process.jsp" method="post" name="boardform">
		<input type="hidden" name="page" value="<%=nowPage %>"/>
		<input type="hidden" name="BOARD_NUM" value="<%=rs.getInt("board_num")%>"/>
		<input type="hidden" name="BOARD_RE_REF" value="<%=rs.getInt("board_re_ref")%>"/>
		<input type="hidden" name="BOARD_RE_LEV" value="<%=rs.getInt("board_re_lev")%>"/>
		<input type="hidden" name="BOARD_RE_SEQ" value="<%=rs.getInt("board_re_seq")%>"/>
		<table>
			<tr>
				<td class="td_left"><label for="BOARD_NAME">글쓴이</label></td>
				<td class="td_right"><input type="text" name="BOARD_NAME" id="BOARD_NAME"/></td>
			</tr>
			<tr>
				<td class="td_left"><label for="BOARD_PASS">비밀번호</label></td>
				<td class="td_right"><input type="password" name="BOARD_PASS" id="BOARD_PASS"/></td>
			</tr>
			<tr>
				<td class="td_left"><label for="BOARD_SUBJECT">제목</label></td>
				<td class="td_right"><input type="text" name="BOARD_SUBJECT" id="BOARD_SUBJECT"/></td>
			</tr>
			<tr>
				<td class="td_left"><label for="BOARD_CONTENT">내용</label></td>
				<td><textarea id="BOARD_CONTENT" name="BOARD_CONTENT" cols="40" rows="15"></textarea></td>
			</tr>
		</table>
			<section id="commandCell">
				<input type="submit" value="답변글등록"/>&nbsp;&nbsp;
				<input type="reset" value="다시작성"/>	
			</section>
		</form>
	</section>
<%}
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