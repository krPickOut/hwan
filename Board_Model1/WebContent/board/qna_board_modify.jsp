<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%
String nowPage=request.getParameter("page");
int board_num = Integer.parseInt(request.getParameter("board_num"));

Connection con=null;
PreparedStatement pstmt=null;
ResultSet rs=null;
try{
	Context initContext = new  InitialContext();
	DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/mySQLDB");
	con=ds.getConnection();
	con.setAutoCommit(false);
	
	pstmt = con.prepareStatement("select * from board where board_num=?");
	pstmt.setInt(1, board_num);
	rs = pstmt.executeQuery();
	if(rs.next()){
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<script type="text/javascript">
function modifyboard(){
	modifyform.submit();
}
</script>
<style type="text/css">
	#registForm{
	width : 500px;
	height : 600px;
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
<section id="writeForm">
<h2>게시판 글 수정</h2>
<form action="qna_board_modify_process.jsp" method="post" name="modifyform">
<input type="hidden" name="BOARD_NUM" value="<%=rs.getInt("BOARD_NUM") %>"/>
<table>
	<tr>
		<td class="td_left">
			<label for="BOARD_NAME">글쓴이</label>
		</td>
		<td class="td_right">
			<input type="text" name="BOARD_NAME" id="BOARD_NAME" value="<%=rs.getString("BOARD_NAME") %>"/>
		</td>
	</tr>
	<tr>
		<td class="td_left">
			<label for="BOARD_PASS">비밀번호</label>
		</td>
		<td class="td_right">
			<input type="password" name="BOARD_PASS" id="BOARD_PASS"/>
		</td>
	</tr>
	<tr>
		<td class="td_left">
			<label for="BOARD_SUBJECT">제목</label>
		</td>
		<td class="td_right">
			<input type="text" name="BOARD_SUBJECT" id="BOARD_SUBJECT" value="<%=rs.getString("BOARD_SUBJECT")%>"/>
		</td>
	</tr>
	<tr>
		<td class="td_left">
			<label for="BOARD_CONTENT">내용</label>
		</td>
		<td>
			<textarea id="BOARD_CONTENT" name="BOARD_CONTENT" cols="40" rows="15"><%=rs.getString("BOARD_CONTENT") %></textarea>
		</td>
	</tr>
</table>
	<section id="commandCell">
		<a href="javascript:modifyboard()">[수정]</a>&nbsp;&nbsp;
		<a href="javascript:history.go(-1)">[뒤로]</a>
	</section>
	<input type="hidden" name="page" value="<%=nowPage %>"/>
</form>
</section>
</body>
</html>
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