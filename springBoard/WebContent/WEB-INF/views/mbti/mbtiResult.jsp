<%@page import="com.spring.board.vo.UserVo"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>MBTI 테스트 결과</title>
</head>
<script type="text/javascript">
	
</script>
<body>
	<div>
		<h1>MBTI 테스트 결과</h1>
		성격 유형:
		<h4>${mbti}</h4>
		
	</div>
</body>
</html>