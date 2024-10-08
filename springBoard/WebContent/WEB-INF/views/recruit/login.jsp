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
		
		//main.jsp���� ���� ���� ��, ��α���
		var urlParams = new URLSearchParams(window.location.search);
		var msg = urlParams.get('msg');
		if(msg) {
			alert(msg);
		}
		
		//�Է� ���� Ȯ��
		//name �ѱ۸� �Է�
		$j('#name').on('input', function(){
			let name = $j(this).val().replace(/[^\u3131-\u318E\uac00-\ud7a3]/g, ''); //�ѱ۸� ǥ��
			$j(this).val(name);
		});
		//phone ���ڸ� �Է�
		$j('#phone').on('input', function(){
			let phone = $j(this).val().replace(/[^0-9]/g, ''); //���ڸ� ����
			$j('#phone').val(phone);
		});
		
		//�Ի����� Ŭ��
		$j('#login').on("click", function(event){
			event.preventDefault();
			console.log($j('.loginForm :input').serialize());
			
		    // name ����Ʈ üũ
			let name = $j('#name').val();
		    let comBytes = new Blob([name]).size; // byte �� ���
			
		    if (comBytes > 85) {
				$j('#name').focus();
				alert("�Է� ������ �ʰ��߽��ϴ�. �ٽ� �Է��ϼ���.");
		        return false;
		    }
		    
		    //phone ����(01-)
		    let phone = $j('#phone').val();
		    let start = phone.slice(0,2);
		    if(start != "01") {
		    	$j('#phone').focus();
		    	alert("�Է� ������ �ùٸ��� �ʽ��ϴ�. �ٽ� �Է��ϼ���.");
		    	return false;
		    }
		    
		    //name,phone���� recruit �ߺ�üũ
		    //�ߺ��̸�, ��ġ�� DB �ҷ��ͼ� ����� �Ի��������� �̵�
		    //������, recruitVo ���� INSERT ��, �Ի��������� �̵�
			$j.ajax({
				url: "/recruit/loginAction.do",
				type: "POST",
				data : $j('.loginForm :input').serialize(),
				dataType: "json",
				success: function(resp, textStatus, jqXHR) {
					if (resp.duplication == "Y") {
						alert("����� �Ի� �������� �̵��մϴ�.");
						location.href="/recruit/main.do?seq="+resp.recruitVo.seq;
					} else {
						if (resp.success == "Y") {
		                    alert("ȸ������/�α��� �����߽��ϴ�.");
							location.href="/recruit/main.do?seq="+resp.recruitVo.seq;
		                } else {
		                    alert("ȸ������/�α��� �����߽��ϴ�.");
		                    return false;
		                }
					}
				}, 
				error : function(jqXHR, textStatus, errorThrown) {
					alert("���� �߻� : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
			});
			
		});
	});
	

</script>
<body>
<form class="loginForm">
	<table border="" align="center">
		<tr>
			<th>�̸�</th>
			<td>
				<input id="name" type="text" name="name">
			</td>
		</tr>
		<tr>
			<th>�޴�����ȣ</th>
			<td>
				<input id="phone" type="text"  name="phone" maxlength="11">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input id="login" type="button" name="login" value="�Ի�����">
			</td>
		</tr>
	</table>
</form>	
</body>
</html>