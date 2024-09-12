<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>join</title>
</head>
<script type="text/javascript">

	//id 중복체크
    var isChkDup = false;
    
	function checkDuplicate() {
		
	    let userId = $j('#userId').val();
	    
	    if(userId.trim().length == 0) {
			alert("ID를 입력하세요.");
			$j('#userId').focus();
			return false;
		}
	    //id 한글 입력불가
		if(!/^[a-zA-Z0-9]+$/.test(userId)) {
			alert("ID는 한글 입력 불가입니다.");
			$j('#userId').focus();
			return false;
		}
	    
	    // AJAX 요청으로 중복 확인 로직을 구현
	    $j.ajax({
	        url: '/board/joinChkId.do',
	        type: 'POST',
	        data: { userId: userId },
	        success: function(response, textStatus, jqXHR) {
	            alert("중복 확인 결과: " + response);
	            
	            if (response == 1) {
					alert("이미 사용 중인 ID입니다.");
					$j('#userId').focus();
					isChkDup = false;
				} else {
					alert("사용 가능한 ID입니다.");
					isChkDup = true;
				}
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            alert("실패 : " + textStatus + ", " + errorThrown);
	        }
	    });
	    
	}
	
	//pw 형식 및 일치여부
	var isPw = false;
	var isPwChk = false;
	var isConfirmPw = false;
	
	$j(document).ready(function(){
		
		//id 중복확인 후, id 변경시 다시 중복확인 메세지
		$j('#userId').on('change', function(){
			isChkDup = false;
			alert('ID 중복확인 하세요.');
			$j('#idChk').focus();
			return false;
		});
		
		//id 중복체크 이후 다른 폼데이터 입력 가능
		$j('#userPw, #userPwChk, #userName, #userPhone2, #userPhone3, #userAddr1, #userAddr2, #userCompany').on('focus', function(){
			if(!isChkDup) {
				if($j('#userId').val().trim().length == 0) {
					alert("ID를 입력하세요.");
					$j('#userId').focus();
					return false;
				}
				alert("ID 중복확인 하세요.");
				$j('#userId').focus();
				return false;
			}
		});
		
		//pw 형식 및 일치여부
		$j('#userPw, #userPwChk').on('input', function(){
			let userPw = $j('#userPw').val();
			let userPwChk = $j('#userPwChk').val();

			if(userPw == '' || (userPw.length < 6 && userPw.length >= 0)) {
				$j('#chkMsg').text('6~12자 이내로 입력').css('color', '#fba082');
				isPw = false;
				$j("#confrimMsg").text('비밀번호 불일치').css('color', '#fba082');
				isConfirmPw = false;
				return false;
				
			} else if(userPw.length >= 6) {
				isPw = true;
				$j('#chkMsg').text('비밀번호 적합').css('color', '#c5c6d0');
				
				if(userPwChk.length >= 6) {
					isPwChk = true;
					
					//pw 일치
					if(userPw == userPwChk) {
						$j("#confrimMsg").text('비밀번호 일치').css('color', '#c5c6d0');
						isConfirmPw = true;
						return false;
					} 
					//pw 불일치
					if(userPw != userPwChk) {
						$j("#confrimMsg").text('비밀번호 불일치').css('color', '#fba082');
						isConfirmPw = false;
						return false;
					}
				} else {
					isPwChk = false;
					$j("#confrimMsg").text('비밀번호 불일치').css('color', '#fba082');
					isConfirmPw = false;
					return false;
				}
			} 
// 			else {
// 				isPw = true;
// 				$j("#confrimMsg").text('비밀번호 불일치').css('color', '#fba082');
// 				isPwChk = false;
// 				$j('#userPwChk').focus();
// 				return false;
// 			}
		});	
		
		//id 한글 입력 방지
		$j('#userId').on('input', function(){
		    let inputVal = $j(this).val();
		    let filteredVal = inputVal.replace(/[^a-zA-Z0-9]{1,15}/g, ''); // 영문자와 숫자만 남김
		    if (inputVal !== filteredVal) {
		        $j(this).val(filteredVal); // 한글이 들어가면 그 값을 수정
		    }
		});
		
		//name 입력 시 바로 조건 확인
		$j('#userName').on('input', function(){
			let name = $j(this).val().replace(/[^\u3131-\u318E\uac00-\ud7a3]/g, ''); //한글만 표기
			$j(this).val(name);
		});
		
		//phone 숫자만 입력
		$j('#userPhone2, #userPhone3').on('input', function(){
			let userPhone2 = $j('#userPhone2').val().replace(/[^0-9]/g, ''); //숫자만 남김
			let userPhone3 = $j('#userPhone3').val().replace(/[^0-9]/g, ''); //숫자만 남김
			
			$j('#userPhone2').val(userPhone2);
			$j('#userPhone3').val(userPhone3);
		});
		
		//postNo '-' 자동 추가
		$j('#userAddr1').on('input', function(){
			let input = $j(this).val().replace(/[^0-9]/g, ''); //숫자만 남김
			if(input.length > 3) {
				input = input.slice(0,3) + '-' + input.slice(3);
			}
			$j(this).val(input);
			
			if($j(this).val().length != 7){
				$j("#msg").text('XXX-XXX 형식으로 입력').css('color', '#fba082');
				$j('#userAddr1').focus();
				return false;
			} else {
				$j("#msg").text('');
				return false;
			}
		});
		
		//address 150byte 초과 시, byte 표시 및 마지막 문자열 자동 삭제 처리
		$j('#userAddr2').on('input', function() {
			
		    let userAddr2 = $j(this).val();
		    let addrBytes = new Blob([userAddr2]).size; // byte 수 계산
			
		    $j('#addressByte').text(addrBytes + '/150 Byte').css('color', '#c5c6d0');
		    
		    // 바이트 수 체크
		    if (addrBytes > 150) {
		    	
		        $j('#addressByte').text(addrBytes + '/150 Byte').css('color', '#fba082');
		        
		        // 입력 초과 시 마지막 입력을 제거
		        $j(this).val(userAddr2.slice(0, -1)); // 마지막 글자 제거
		        
		     	// 커서를 입력 필드의 맨 뒤로 이동
		        let input = $j(this).get(0);
		        input.setSelectionRange(input.value.length, input.value.length);
		        
		        return false;
		    } else {
			    // 커서를 입력 필드의 맨 뒤로 이동 (유효한 입력일 경우)
			    $j('#addressByte').text(addrBytes + '/150 Byte').css('color', '#c5c6d0');
			    let input = $j(this).get(0);
			    input.setSelectionRange(input.value.length, input.value.length);
			    return false;
		    }
		});
		
		//userCompany 60byte 초과 시, 경고 및 마지막 문자열 자동 삭제 처리
		$j('#userCompany').on('input', function() {
			
			let userCompany = $j(this).val();
		    let comBytes = new Blob([userCompany]).size; // byte 수 계산
			
		    $j('#companyByte').text(comBytes + '/60 Byte').css('color', '#c5c6d0');
		    
		    // 바이트 수 체크
		    if (comBytes > 60) {
		    	
		    	$j('#companyByte').text(comBytes + '/60 Byte').css('color', '#fba082');
		    	
		        // 입력 초과 시 마지막 입력을 제거
		        $j(this).val(userCompany.slice(0, -1)); // 마지막 글자 제거
		        
		     	// 커서를 입력 필드의 맨 뒤로 이동
		        let input = $j(this).get(0);
		        input.setSelectionRange(input.value.length, input.value.length);
		        
		        return false;
			} else {
				// 커서를 입력 필드의 맨 뒤로 이동 (유효한 입력일 경우)
			    $j('#companyByte').text(comBytes + '/60 Byte').css('color', '#c5c6d0');
			    let input = $j(this).get(0);
			    input.setSelectionRange(input.value.length, input.value.length);
			    return false;
		    }
		    
		});
		
		//회원가입 제출
		$j('#joinBtn').on("click", function(event){
			event.preventDefault();
			
			//id 확인
			if(!isChkDup) {
				if($j('#userId').val().trim().length == 0) {
					alert("ID를 입력하세요.");
					$j('#userId').focus();
					return false;
				}
				
				alert("ID 중복확인 하세요.");
				$j('#userId').focus();
				return false;
			}
			
			//필수 입력 데이터 제외하고 submit 처리
			let firstForm = document.forms[0];
			console.log(firstForm.elements);
			
			for(let htmlObj of firstForm.elements) {
				
				if (htmlObj.value.trim() == "") {
					if (["userAddr1", "userAddr2", "userCompany"].includes(htmlObj.getAttribute("id"))) continue;
					
					alert(htmlObj.getAttribute("title") + " 입력하세요.");
					htmlObj.focus();
					return false;
					
				} else {
					if(htmlObj.getAttribute("id") == 'userPw') {
						if($j('#userPw').val().length < 6 && $j('#userPw').val().length > 0) {
							alert("6~12자 이내로 입력하세요.");
							htmlObj.focus();
							return false;
						}
					} else if(htmlObj.getAttribute("id") == 'userPwChk') {
						if(!isConfirmPw) {
							alert("비밀번호가 일치하지 않습니다. 다시 입력하세요.");
							htmlObj.focus();
							return false;
						}
					} else if(htmlObj.getAttribute("id") == 'userName') {
						if($j('#userName').val().length > 5) {
							alert("이름은 한글로 5글자까지 입력가능합니다.");
							$j('#userName').focus();
							return false;
						}
					} else if(htmlObj.getAttribute("id") == 'userPhone2') {
						if($j('#userPhone2').val().length < 4) {
							alert("숫자 4자리 입력하세요.");
							htmlObj.focus();
							return false;
						}
					} else if(htmlObj.getAttribute("id") == 'userPhone3') {
						if($j('#userPhone3').val().length < 4) {
							alert("숫자 4자리 입력하세요.");
							htmlObj.focus();
							return false;
						}
					} 
					
				}
			}
		
			//pw 입력 및 형식
			if($j('#userPw').val().length < 6) {
				alert('pw 입력하세요.');
				$j('#userPw').focus();
				return false;
			}
			//pwChk 입력 및 형식
			if($j('#userPw').val().length < 6) {
				alert('pw check 확인하세요.');
				$j('#userPwChk').focus();
				return false;
			}
			//pw 일치 여부
			if(!isConfirmPw) {
				alert('비밀번호가 일치하지 않습니다.');
				$j('#userPwChk').focus();
				return false;
			}
			//name 한글만 입력
			if($j('#userName').val().length > 5) {
				alert("이름은 한글로 5글자까지 입력가능합니다.");
				$j('#userName').focus();
				return false;
			}
			//phone 4자리 조건
			let userPhone2 = $j('#userPhone2').val();
			let userPhone3 = $j('#userPhone3').val();
			if(!/^[0-9]{4}$/.test(userPhone2)) {
				alert('숫자 4자리 입력하세요.');
				$j('#userPhone2').focus();
				return false;
			} else if(!/^[0-9]{1,4}$/.test(userPhone3)) {
				alert('숫자 4자리 입력하세요.');
				$j('#userPhone3').focus();
				return false;
			}	
			//postNo 형식 확인
			let userAddr1 = $j('#userAddr1').val();
			console.log(userAddr1);
			
			if(userAddr1 != null) {
				if(userAddr1.length < 7 && userAddr1.length > 0) {
					alert('XXX-XXX 형식으로 입력하세요.');
					$j('#userAddr1').focus();
					return false;
				}
			} else {
				return false;
			}
			// 주소 byte 수 체크
		    var userAddr2 = $j('#userAddr2').val();
		    var addrBytes = new Blob([userAddr2]).size; // byte 수 계산
		
		    // address 150byte 이상인 경우, 다시 입력으로 alert
		    if (addrBytes > 150) {
		        alert(addrBytes + '주소는 150byte를 초과할 수 없습니다.');
		        $j('#userAddr2').focus();
		        return false;
		    }
			// 회사명 byte 수 체크
		    var userCompany = $j('#userCompany').val();
		    var comBytes = new Blob([userCompany]).size; // byte 수 계산
		
		    // address 60byte 이상인 경우, 다시 입력으로 alert
		    if (comBytes > 60) {
		        alert(comBytes + '회사명은 60byte를 초과할 수 없습니다.');
		        $j('#userCompany').focus();
		        return false;
		    }
			
			//회원가입 submit ajax 처리 
			var $frm = $j('.joinForm :input');
			var param = $frm.serialize();
// 			alert(param);
			
			$j.ajax({
				url : "/board/joinAction.do",
				type : "POST",
				dataType : "json",
				data : param,
				success : function(data, textStatus, jqXHR){
					alert("회원가입 완료됐습니다. : " + data.success);
					
					location.href="/board/login.do";
				}, 
				error : function(jqXHR, textStatus, errorThrown) {
					alert("실패" + textStatus + ", " + errorThrown);
				}
			});
			
		});
		
		
	});

</script>
<body>
<form class="joinForm" method="POST" action="/board/joinAction.do">
	<table border="1" align="center">
		<tr>
			<td colspan="2">
				<a href="/board/boardList.do">List</a>
			</td>
		</tr>
		<tr>
			<td align="center" style="width: 100px;">id</td>
			<td style="width: 350px;">
				<input title="id" id="userId" name="userId" type="text" title="id" maxlength="15" required>
				<input id="idChk" type="button" value="중복확인" onclick="checkDuplicate()">
			</td>
		</tr>
		<tr>
			<td align="center">pw</td>
			<td>
				<input title="pw" id="userPw" name="userPw" type="password" title="pw" placeholder="6~12자리 이내" maxlength="12" required>
				<span id="chkMsg"></span>
			</td>
		</tr>
		<tr>
			<td align="center">pw check</td>
			<td>
				<input title="pw check" id="userPwChk" name="userPwChk" type="password" title="pw check" placeholder="6~12자리 이내" maxlength="12" required>
				<span id="confrimMsg"></span>
			</td>
		</tr>
		<tr>
			<td align="center">name</td>
			<td>
				<input title="name" id="userName" name="userName" type="text" title="name" required>
			</td>
		</tr>
		<tr>
			<td align="center">phone</td>
			<td>
				<select id="userPhone1" name="userPhone1" title="phone1">
					<c:forEach var="phone" items="${phoneList}">
						<option value="${phone.codeName}">${phone.codeName}</option>
					</c:forEach>
				</select> -
				<input title="middle phone" id="userPhone2" name="userPhone2" type="text" title="phone2" maxlength="4" required style="width: 38px;"> -
				<input title="last phone" id="userPhone3" name="userPhone3" type="text" title="phone3" maxlength="4" required style="width: 38px;">
			</td>
		</tr>
		<tr>
			<td align="center">postNo</td>
			<td>
				<input title="postNo" id="userAddr1" name="userAddr1" type="text" title="postNo" maxlength="7">
				<span id="msg"></span>
			</td>
		</tr>
		<tr>
			<td align="center">address</td>
			<td>
				<input title="address" id="userAddr2" name="userAddr2" type="text" title="address">
				<span id="addressByte"></span>
			</td>
		</tr>
		<tr>
			<td align="center">company</td>
			<td>
				<input title="company" id="userCompany" name="userCompany" type="text" title="company">
				<span id="companyByte"></span>
			</td>
		</tr>
		<tr>
			<td align="right" colspan="2">
				<input id="joinBtn" name="join" type="submit" value="join"></input>
			</td>
		</tr>
	</table>
</form>	
</body>
</html>