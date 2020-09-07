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
#tr_top{
	background : orange;
	text-align : center;
}
#pageList{
	margin : auto;
	width : 500px;
	text-align : center;
}
</style>
</head>
<body>
	<section id="listForm">
		<h2>
			글 목록<a href="qna_board_write.jsp">게시판 글쓰기</a>
		</h2>
		<%
			try{
				Context initContext = new  InitialContext();
				DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/mySQLDB");
				con=ds.getConnection();
				con.setAutoCommit(false);
				
				pstmt=con.prepareStatement("select count(*) from board");
				rs = pstmt.executeQuery();
				
				
				int listCount=0;
				if (rs.next()) {
					listCount = rs.getInt(1);
				}
				if(listCount>0){
					int nowPage = 1;
					int limit=2;
					int limitPage = 3;

					if(!(request.getParameter("page")==null || request.getParameter("page").equals("null"))) {
						nowPage = Integer.parseInt(request.getParameter("page").trim());
					}
					
					int maxPage = (int)((double)listCount/limit+0.95);
					int startPage = (((int) ((double)nowPage / limitPage + 0.9))-1)*limitPage + 1;
					int endPage = startPage+limitPage-1;
					
					if(endPage>maxPage) endPage = maxPage;
					
					String board_list_sql = "select * from board order by BOARD_RE_REF desc,BOARD_RE_SEQ asc limit ?,?";
					
					int startrow = (nowPage - 1) * limit;
					
					pstmt = con.prepareStatement(board_list_sql);
					pstmt.setInt(1, startrow);
					pstmt.setInt(2, limit);
					rs = pstmt.executeQuery();
		%>
		<table>
			<tr id="tr_top">
				<td>번호</td>
				<td>제목</td>
				<td>작성자</td>
				<td>날짜</td>
				<td>조회수</td>
			</tr>
			<%while(rs.next()){ %>
			<tr>
				<td><%=rs.getInt("board_num")%></td>
				<td>
			<%if(rs.getInt("board_re_lev")!=0){%>
			<%for(int a=0; a<=rs.getInt("board_re_lev")*2; a++) {%>
			&nbsp;
			<%} %> ▶
			<%}else{ %> ▶ <%} %>
				<a href="qna_board_view.jsp?board_num=<%=rs.getInt("board_num")%>&page=<%=nowPage %>">
				<%=rs.getString("board_subject") %></a>
			</td>
			<td><%=rs.getString("board_subject")%></td>
			<td><%=rs.getDate("board_date")%></td>
			<td><%=rs.getInt("board_readcount")%></td>
		</tr>
		<%} %>
		</table>
	</section>
	<section id="pageList">
		<%if(nowPage<=1) {%>
			[이전]&nbsp;
		<%}else{ %>
			<a href="qna_board_list.jsp?page=<%=nowPage-1 %>">[이전]</a>&nbsp;
		<%} %>
		
		<%for(int a=startPage;a<=endPage;a++) {
			if(a==nowPage) {%>
				[<%=a %>]
			<%}else{ %>
				<a href="qna_board_list.jsp?page=<%=a %>">[<%=a %>]</a>&nbsp;
			<%} %>
		<%} %>
		<%if(nowPage>=maxPage) {%>
			[다음]
		<%}else{ %>
			<a href="qna_board_list.jsp?page=<%=nowPage+1 %>">[다음]</a>
		<%} %>
	</section>
	<%
	}else{
	%>
	<section id="emptyArea">등록된 글이 없습니다.</section>
	<%
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