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

	$j(document).ready(function(event){
		
		//main.jsp에서 세션 종료 시, 재로그인
		var urlParams = new URLSearchParams(window.location.search);
		var msg = urlParams.get('msg');
		if(msg) {
			alert(msg);
		}
		
		//입력 조건 확인
		//name 한글만 입력
		$j('#name').on('input', function(){
			let name = $j(this).val().replace(/[^\u3131-\u318E\uac00-\ud7a3]/g, ''); //한글만 표기
			$j(this).val(name);
		});
		//phone 숫자만 입력
		$j('#phone').on('input', function(){
			let phone = $j(this).val().replace(/[^0-9]/g, ''); //숫자만 남김
			$j('#phone').val(phone);
		});
		
		//입사지원 클릭
		$j('#login').on("click", function(event){
			event.preventDefault();
			console.log($j('.loginForm :input').serialize());
			
		    // name 바이트 체크
			let name = $j('#name').val();
		    let comBytes = new Blob([name]).size; // byte 수 계산
			
		    if (comBytes > 85) {
				$j('#name').focus();
				alert("입력 범위를 초과했습니다. 다시 입력하세요.");
		        return false;
		    }
		    
		    //phone 형식(01-)
		    let phone = $j('#phone').val();
		    let start = phone.slice(0,2);
		    if(start != "01") {
		    	$j('#phone').focus();
		    	alert("입력 형식이 올바르지 않습니다. 다시 입력하세요.");
		    	return false;
		    }
		    
		    //name,phone으로 recruit 중복체크
		    //중복이면, 일치한 DB 불러와서 저장된 입사지원서로 이동
		    //없으면, recruitVo 정보 INSERT 후, 입사지원서로 이동
			$j.ajax({
				url: "/recruit/loginAction.do",
				type: "POST",
				data : $j('.loginForm :input').serialize(),
				dataType: "json",
				success: function(resp, textStatus, jqXHR) {
					if (resp.duplication == "Y") {
						alert("저장된 입사 지원서로 이동합니다.");
						location.href="/recruit/main.do?seq="+resp.recruitVo.seq;
					} else {
						if (resp.success == "Y") {
		                    alert("회원가입/로그인 성공했습니다.");
							location.href="/recruit/main.do?seq="+resp.recruitVo.seq;
		                } else {
		                    alert("회원가입/로그인 실패했습니다.");
		                    return false;
		                }
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
				<input id="login" type="button" name="login" value="입사지원">
			</td>
		</tr>
	</table>
</form>	
</body>
</html>