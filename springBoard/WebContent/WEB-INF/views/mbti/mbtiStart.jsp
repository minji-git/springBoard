<%@page import="com.spring.board.vo.UserVo"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>mbti ����</title>
<link rel="stylesheet" href="/css/mbtiStyle.css"></link>
</head>
<script type="text/javascript">
	
	$j(document).ready(function(){
		localStorage.removeItem('formData'); // Ư�� �׸� ����
	});
	
</script>
<body>
	<h1>MBTI �׽�Ʈ</h1>
	<button type="button" onclick="location.href='/mbti/mbtiTest.do'">�����ϱ�</button>
</body>
</html>