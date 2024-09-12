<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>login</title>
</head>
<script type="text/javascript">

	$j(document).ready(function(){
		
		$j('#login').on("click", function(event){
			event.preventDefault();
			
			let $frm = $j('.loginForm :input');
			let param = $frm.serialize();
			console.log(param);
			
			$j.ajax({
				url: "/board/loginAction.do",
				dataType: "json",
				data : param,
				type: "POST",
				success: function(data, textStatus, jqXHR) {
					if (data.success) {
	                    alert("로그인 성공하셨습니다.");
	                    location.href = "/board/boardList.do";
	                } else {
	                    alert(data.message); // 로그인 실패 시 메시지 출력
	                    $j('#userPw').val("");
	                }
				}, 
				error : function(jqXHR, textStatus, errorThrown) {
					alert("오류 발생 : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
			});
			
		});
	});
	

</script>
<body>
<form class="loginForm">
	<table border="" align="center">
		<tr>
			<td align="center">id</td>
			<td>
				<input id="userId" name="userId" type="text">
			</td>
		</tr>
		<tr>
			<td align="center">pw</td>
			<td>
				<input id="userPw" name="userPw" type="password">
			</td>
		</tr>
		<tr>
			<td align="right" colspan="2">
				<input id="login" name="loginUser" type="submit" value="login">
<!-- 				<a href="/board/loginAction.do">login</a> -->
			</td>
		</tr>
	</table>
</form>	
</body>
</html>