<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%
	String realFolder = "";
	String saveFolder = "/boardUpload";
	int fileSize = 5*1024*1024;
	ServletContext context = request.getServletContext();
	realFolder = context.getRealPath(saveFolder);
	MultipartRequest multi = new MultipartRequest(request,realFolder,fileSize,"UTF-8",new DefaultFileRenamePolicy());
	
	String board_name=multi.getParameter("BOARD_NAME");
	String board_pass=multi.getParameter("BOARD_PASS");
	String board_subject=multi.getParameter("BOARD_SUBJECT");
	String board_content=multi.getParameter("BOARD_CONTENT");
	String board_file=multi.getOriginalFileName((String)multi.getFileNames().nextElement());

	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	try{
		Context initContext = new  InitialContext();
		DataSource ds = (DataSource) initContext.lookup("java:comp/env/jdbc/mySQLDB");
		con=ds.getConnection();
		con.setAutoCommit(false);
		
		int num = 0;
		String sql = "";
		int insertCount=0;
		
		pstmt=con.prepareStatement("select max(board_num) from board");
		rs = pstmt.executeQuery();
		
		if(rs.next()) {
			num = rs.getInt(1)+1;
		}
		else num=1;
		
		sql="insert into board values (?,?,?,?,?,?,?,0,0,0,now())";
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1,num);
		pstmt.setString(2, board_name);
		pstmt.setString(3, board_pass);
		pstmt.setString(4, board_subject);
		pstmt.setString(5, board_content);
		pstmt.setString(6, board_file==null?"":board_file);
		pstmt.setInt(7,num);
		
		insertCount = pstmt.executeUpdate();
		
		if(insertCount > 0){
			con.commit();
			out.println("<script>");
			out.println("alert('등록되었습니다.')");
			out.println("location.href='qna_board_list.jsp'");
			out.println("</script>");
		}else{
			con.rollback();
			out.println("<script>");
			out.println("alert('등록실패')");
			out.println("history.back();");
			out.println("</script>");
		}
	}catch(Exception e){
		con.rollback();
		System.out.println("boardInsert 에러 : "+e);
		e.printStackTrace();
	}finally{
		if(rs!=null)rs.close();
		if(pstmt!=null)pstmt.close();
		if(con!=null)con.close();
	}
%>