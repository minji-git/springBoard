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

	//id �ߺ�üũ
    var isChkDup = false;
    
	function checkDuplicate() {
		
	    let userId = $j('#userId').val();
	    
	    if(userId.trim().length == 0) {
			alert("ID�� �Է��ϼ���.");
			$j('#userId').focus();
			return false;
		}
	    //id �ѱ� �ԷºҰ�
		if(!/^[a-zA-Z0-9]+$/.test(userId)) {
			alert("ID�� �ѱ� �Է� �Ұ��Դϴ�.");
			$j('#userId').focus();
			return false;
		}
	    
	    // AJAX ��û���� �ߺ� Ȯ�� ������ ����
	    $j.ajax({
	        url: '/board/joinChkId.do',
	        type: 'POST',
	        data: { userId: userId },
	        success: function(response, textStatus, jqXHR) {
	            alert("�ߺ� Ȯ�� ���: " + response);
	            
	            if (response == 1) {
					alert("�̹� ��� ���� ID�Դϴ�.");
					$j('#userId').focus();
					isChkDup = false;
				} else {
					alert("��� ������ ID�Դϴ�.");
					isChkDup = true;
				}
	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            alert("���� : " + textStatus + ", " + errorThrown);
	        }
	    });
	    
	}
	
	//pw ���� �� ��ġ����
	var isPw = false;
	var isPwChk = false;
	var isConfirmPw = false;
	
	$j(document).ready(function(){
		
		//id �ߺ�Ȯ�� ��, id ����� �ٽ� �ߺ�Ȯ�� �޼���
		$j('#userId').on('change', function(){
			isChkDup = false;
			alert('ID �ߺ�Ȯ�� �ϼ���.');
			$j('#idChk').focus();
			return false;
		});
		
		//id �ߺ�üũ ���� �ٸ� �������� �Է� ����
		$j('#userPw, #userPwChk, #userName, #userPhone2, #userPhone3, #userAddr1, #userAddr2, #userCompany').on('focus', function(){
			if(!isChkDup) {
				if($j('#userId').val().trim().length == 0) {
					alert("ID�� �Է��ϼ���.");
					$j('#userId').focus();
					return false;
				}
				alert("ID �ߺ�Ȯ�� �ϼ���.");
				$j('#userId').focus();
				return false;
			}
		});
		
		//pw ���� �� ��ġ����
		$j('#userPw, #userPwChk').on('input', function(){
			let userPw = $j('#userPw').val();
			let userPwChk = $j('#userPwChk').val();

			if(userPw == '' || (userPw.length < 6 && userPw.length >= 0)) {
				$j('#chkMsg').text('6~12�� �̳��� �Է�').css('color', '#fba082');
				isPw = false;
				$j("#confrimMsg").text('��й�ȣ ����ġ').css('color', '#fba082');
				isConfirmPw = false;
				return false;
				
			} else if(userPw.length >= 6) {
				isPw = true;
				$j('#chkMsg').text('��й�ȣ ����').css('color', '#c5c6d0');
				
				if(userPwChk.length >= 6) {
					isPwChk = true;
					
					//pw ��ġ
					if(userPw == userPwChk) {
						$j("#confrimMsg").text('��й�ȣ ��ġ').css('color', '#c5c6d0');
						isConfirmPw = true;
						return false;
					} 
					//pw ����ġ
					if(userPw != userPwChk) {
						$j("#confrimMsg").text('��й�ȣ ����ġ').css('color', '#fba082');
						isConfirmPw = false;
						return false;
					}
				} else {
					isPwChk = false;
					$j("#confrimMsg").text('��й�ȣ ����ġ').css('color', '#fba082');
					isConfirmPw = false;
					return false;
				}
			} 
// 			else {
// 				isPw = true;
// 				$j("#confrimMsg").text('��й�ȣ ����ġ').css('color', '#fba082');
// 				isPwChk = false;
// 				$j('#userPwChk').focus();
// 				return false;
// 			}
		});	
		
		//id �ѱ� �Է� ����
		$j('#userId').on('input', function(){
		    let inputVal = $j(this).val();
		    let filteredVal = inputVal.replace(/[^a-zA-Z0-9]{1,15}/g, ''); // �����ڿ� ���ڸ� ����
		    if (inputVal !== filteredVal) {
		        $j(this).val(filteredVal); // �ѱ��� ���� �� ���� ����
		    }
		});
		
		//name �Է� �� �ٷ� ���� Ȯ��
		$j('#userName').on('input', function(){
			let name = $j(this).val().replace(/[^\u3131-\u318E\uac00-\ud7a3]/g, ''); //�ѱ۸� ǥ��
			$j(this).val(name);
		});
		
		//phone ���ڸ� �Է�
		$j('#userPhone2, #userPhone3').on('input', function(){
			let userPhone2 = $j('#userPhone2').val().replace(/[^0-9]/g, ''); //���ڸ� ����
			let userPhone3 = $j('#userPhone3').val().replace(/[^0-9]/g, ''); //���ڸ� ����
			
			$j('#userPhone2').val(userPhone2);
			$j('#userPhone3').val(userPhone3);
		});
		
		//postNo '-' �ڵ� �߰�
		$j('#userAddr1').on('input', function(){
			let input = $j(this).val().replace(/[^0-9]/g, ''); //���ڸ� ����
			if(input.length > 3) {
				input = input.slice(0,3) + '-' + input.slice(3);
			}
			$j(this).val(input);
			
			if($j(this).val().length != 7){
				$j("#msg").text('XXX-XXX �������� �Է�').css('color', '#fba082');
				$j('#userAddr1').focus();
				return false;
			} else {
				$j("#msg").text('');
				return false;
			}
		});
		
		//address 150byte �ʰ� ��, byte ǥ�� �� ������ ���ڿ� �ڵ� ���� ó��
		$j('#userAddr2').on('input', function() {
			
		    let userAddr2 = $j(this).val();
		    let addrBytes = new Blob([userAddr2]).size; // byte �� ���
			
		    $j('#addressByte').text(addrBytes + '/150 Byte').css('color', '#c5c6d0');
		    
		    // ����Ʈ �� üũ
		    if (addrBytes > 150) {
		    	
		        $j('#addressByte').text(addrBytes + '/150 Byte').css('color', '#fba082');
		        
		        // �Է� �ʰ� �� ������ �Է��� ����
		        $j(this).val(userAddr2.slice(0, -1)); // ������ ���� ����
		        
		     	// Ŀ���� �Է� �ʵ��� �� �ڷ� �̵�
		        let input = $j(this).get(0);
		        input.setSelectionRange(input.value.length, input.value.length);
		        
		        return false;
		    } else {
			    // Ŀ���� �Է� �ʵ��� �� �ڷ� �̵� (��ȿ�� �Է��� ���)
			    $j('#addressByte').text(addrBytes + '/150 Byte').css('color', '#c5c6d0');
			    let input = $j(this).get(0);
			    input.setSelectionRange(input.value.length, input.value.length);
			    return false;
		    }
		});
		
		//userCompany 60byte �ʰ� ��, ��� �� ������ ���ڿ� �ڵ� ���� ó��
		$j('#userCompany').on('input', function() {
			
			let userCompany = $j(this).val();
		    let comBytes = new Blob([userCompany]).size; // byte �� ���
			
		    $j('#companyByte').text(comBytes + '/60 Byte').css('color', '#c5c6d0');
		    
		    // ����Ʈ �� üũ
		    if (comBytes > 60) {
		    	
		    	$j('#companyByte').text(comBytes + '/60 Byte').css('color', '#fba082');
		    	
		        // �Է� �ʰ� �� ������ �Է��� ����
		        $j(this).val(userCompany.slice(0, -1)); // ������ ���� ����
		        
		     	// Ŀ���� �Է� �ʵ��� �� �ڷ� �̵�
		        let input = $j(this).get(0);
		        input.setSelectionRange(input.value.length, input.value.length);
		        
		        return false;
			} else {
				// Ŀ���� �Է� �ʵ��� �� �ڷ� �̵� (��ȿ�� �Է��� ���)
			    $j('#companyByte').text(comBytes + '/60 Byte').css('color', '#c5c6d0');
			    let input = $j(this).get(0);
			    input.setSelectionRange(input.value.length, input.value.length);
			    return false;
		    }
		    
		});
		
		//ȸ������ ����
		$j('#joinBtn').on("click", function(event){
			event.preventDefault();
			
			//id Ȯ��
			if(!isChkDup) {
				if($j('#userId').val().trim().length == 0) {
					alert("ID�� �Է��ϼ���.");
					$j('#userId').focus();
					return false;
				}
				
				alert("ID �ߺ�Ȯ�� �ϼ���.");
				$j('#userId').focus();
				return false;
			}
			
			//�ʼ� �Է� ������ �����ϰ� submit ó��
			let firstForm = document.forms[0];
			console.log(firstForm.elements);
			
			for(let htmlObj of firstForm.elements) {
				
				if (htmlObj.value.trim() == "") {
					if (["userAddr1", "userAddr2", "userCompany"].includes(htmlObj.getAttribute("id"))) continue;
					
					alert(htmlObj.getAttribute("title") + " �Է��ϼ���.");
					htmlObj.focus();
					return false;
					
				} else {
					if(htmlObj.getAttribute("id") == 'userPw') {
						if($j('#userPw').val().length < 6 && $j('#userPw').val().length > 0) {
							alert("6~12�� �̳��� �Է��ϼ���.");
							htmlObj.focus();
							return false;
						}
					} else if(htmlObj.getAttribute("id") == 'userPwChk') {
						if(!isConfirmPw) {
							alert("��й�ȣ�� ��ġ���� �ʽ��ϴ�. �ٽ� �Է��ϼ���.");
							htmlObj.focus();
							return false;
						}
					} else if(htmlObj.getAttribute("id") == 'userName') {
						if($j('#userName').val().length > 5) {
							alert("�̸��� �ѱ۷� 5���ڱ��� �Է°����մϴ�.");
							$j('#userName').focus();
							return false;
						}
					} else if(htmlObj.getAttribute("id") == 'userPhone2') {
						if($j('#userPhone2').val().length < 4) {
							alert("���� 4�ڸ� �Է��ϼ���.");
							htmlObj.focus();
							return false;
						}
					} else if(htmlObj.getAttribute("id") == 'userPhone3') {
						if($j('#userPhone3').val().length < 4) {
							alert("���� 4�ڸ� �Է��ϼ���.");
							htmlObj.focus();
							return false;
						}
					} 
					
				}
			}
		
			//pw �Է� �� ����
			if($j('#userPw').val().length < 6) {
				alert('pw �Է��ϼ���.');
				$j('#userPw').focus();
				return false;
			}
			//pwChk �Է� �� ����
			if($j('#userPw').val().length < 6) {
				alert('pw check Ȯ���ϼ���.');
				$j('#userPwChk').focus();
				return false;
			}
			//pw ��ġ ����
			if(!isConfirmPw) {
				alert('��й�ȣ�� ��ġ���� �ʽ��ϴ�.');
				$j('#userPwChk').focus();
				return false;
			}
			//name �ѱ۸� �Է�
			if($j('#userName').val().length > 5) {
				alert("�̸��� �ѱ۷� 5���ڱ��� �Է°����մϴ�.");
				$j('#userName').focus();
				return false;
			}
			//phone 4�ڸ� ����
			let userPhone2 = $j('#userPhone2').val();
			let userPhone3 = $j('#userPhone3').val();
			if(!/^[0-9]{4}$/.test(userPhone2)) {
				alert('���� 4�ڸ� �Է��ϼ���.');
				$j('#userPhone2').focus();
				return false;
			} else if(!/^[0-9]{1,4}$/.test(userPhone3)) {
				alert('���� 4�ڸ� �Է��ϼ���.');
				$j('#userPhone3').focus();
				return false;
			}	
			//postNo ���� Ȯ��
			let userAddr1 = $j('#userAddr1').val();
			console.log(userAddr1);
			
			if(userAddr1 != null) {
				if(userAddr1.length < 7 && userAddr1.length > 0) {
					alert('XXX-XXX �������� �Է��ϼ���.');
					$j('#userAddr1').focus();
					return false;
				}
			} else {
				return false;
			}
			// �ּ� byte �� üũ
		    var userAddr2 = $j('#userAddr2').val();
		    var addrBytes = new Blob([userAddr2]).size; // byte �� ���
		
		    // address 150byte �̻��� ���, �ٽ� �Է����� alert
		    if (addrBytes > 150) {
		        alert(addrBytes + '�ּҴ� 150byte�� �ʰ��� �� �����ϴ�.');
		        $j('#userAddr2').focus();
		        return false;
		    }
			// ȸ��� byte �� üũ
		    var userCompany = $j('#userCompany').val();
		    var comBytes = new Blob([userCompany]).size; // byte �� ���
		
		    // address 60byte �̻��� ���, �ٽ� �Է����� alert
		    if (comBytes > 60) {
		        alert(comBytes + 'ȸ����� 60byte�� �ʰ��� �� �����ϴ�.');
		        $j('#userCompany').focus();
		        return false;
		    }
			
			//ȸ������ submit ajax ó�� 
			var $frm = $j('.joinForm :input');
			var param = $frm.serialize();
// 			alert(param);
			
			$j.ajax({
				url : "/board/joinAction.do",
				type : "POST",
				dataType : "json",
				data : param,
				success : function(data, textStatus, jqXHR){
					alert("ȸ������ �Ϸ�ƽ��ϴ�. : " + data.success);
					
					location.href="/board/login.do";
				}, 
				error : function(jqXHR, textStatus, errorThrown) {
					alert("����" + textStatus + ", " + errorThrown);
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
				<input id="idChk" type="button" value="�ߺ�Ȯ��" onclick="checkDuplicate()">
			</td>
		</tr>
		<tr>
			<td align="center">pw</td>
			<td>
				<input title="pw" id="userPw" name="userPw" type="password" title="pw" placeholder="6~12�ڸ� �̳�" maxlength="12" required>
				<span id="chkMsg"></span>
			</td>
		</tr>
		<tr>
			<td align="center">pw check</td>
			<td>
				<input title="pw check" id="userPwChk" name="userPwChk" type="password" title="pw check" placeholder="6~12�ڸ� �̳�" maxlength="12" required>
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