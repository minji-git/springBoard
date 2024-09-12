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
				url: "/recruit/loginAction.do",
				dataType: "json",
				data : param,
				type: "POST",
				success: function(data, textStatus, jqXHR) {
					if (data.success) {
	                    alert("회원가입/로그인 성공하셨습니다.");
	                    location.href = "/recruit/main.do";
	                } else {
	                    alert(data.message); // 로그인 실패 시 메시지 출력
	                    location.href = "/recruit/main.do";
// 	                    $j('#userPw').val("");
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
			<th>이름</th>
			<td>
				<input id="name" type="text" name="name">
			</td>
		</tr>
		<tr>
			<th>휴대폰번호</th>
			<td>
				<input id="phone" type="text"  name="phone" maxlength="11">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input id="login" type="submit" name="login" value="입사지원">
			</td>
		</tr>
	</table>
</form>	
</body>
</html>