<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�Ի�����</title>
</head>
<script type="text/javascript">

	$j(document).ready(function(){
		
		
	});

</script>
<body>
<h1>�Ի� ������</h1>
<form class="loginForm" method="post">
	<table border="" align="center">
		<tr>
			<th>�̸�</th>
			<td>
				<input id="name" name="name" type="text">
			</td>
		</tr>
		<tr>
			<th>�޴�����ȣ</th>
			<td>
				<input id="phone" name="phone" type="text" maxlength="11">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input id="login" name="login" type="submit" value="�Ի�����">
			</td>
		</tr>
	</table>
</form>	
</body>
</html>