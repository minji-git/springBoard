<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�Ի�����</title>
<link rel="stylesheet" href="/css/resumeStyle.css"></link>
</head>
<script type="text/javascript">

	$j(document).ready(function(){
// 		if((RecruitVo)session.getAttribute("recruit") == null) {
// 			alert("�α��� ������ �����ϴ�. �ٽ� �α��� ���ּ���!");
// 			location.href="/recruit/login.do";
// 		}
		
		$j('#save').on('click', function(event){
			event.preventDefault();
			
			const input = $j('#recruit :input, #education :input');
			console.log(input);
			let isValidEdu = true; // ��ȿ�� �˻�
			
			input.each(function(){
				let htmlObj = this;
				
				if (!htmlObj.value && htmlObj.name !== 'educationChk') {
	                alert("\"" + htmlObj.title + "\" �Է��ϼ���");
	                htmlObj.focus();
	                isValidEdu = false;
	                
	                return false;
				}
			});
			
		    if (!isValidEdu) {
	        	return; // ��ȿ�� �˻� ���� �� AJAX ��û �ߴ�
	        }
			
			const param = input.serialize();
			console.log(param);
			
			//ajax ó��
			$j.ajax({
				url : "/recruit/recruitSave.do",
				type : "POST",
				data : param,
				dataType : "json",
				success : function(resp, textStatus, jqXHR){
					if(resp.recruit == "Y") {
						alert("recruit ����!");
						
						if(resp.education == "Y") {
							alert("education ����!");
						} else {
							alert("education ���� ���� ����");
						}
					}
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert("���� �߻� : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
				
			});
			
		});		
		
	});

</script>
<body>
<h2 style="text-align: center;">�Ի� ������</h2>
<form id="resumeForm" name="resumeForm" method="post">
	<table id="resume" border="">
		<tbody>
		<tr>
		<td>
		<br>
		
		<table id="recruit" border="" align="center">
			<tr>
				<th>�̸�</th>
				<td>
					${sessionScope.recruit.name}
				</td>
				<th>�������</th>
				<td>
					<input title="�������" name="birth" type="text">
				</td>
			</tr>
			<tr>
				<th>����</th>
				<td>
					<select title="����" name="field3" >
						<option>����</option>
						<option>����</option>
					</select>
				</td>
				<th>����ó</th>
				<td>
					${sessionScope.recruit.phone}
				</td>
			</tr>
			<tr>
				<th>email</th>
				<td>
					<input title="email" name="email" type="text">
				</td>
				<th>�ּ�</th>
				<td>
					<input title="�ּ�" name="addr" type="text">
				</td>
			</tr>
			<tr>
				<th>����ٹ���</th>
				<td>
					<select title="����ٹ���" name="location" >
						<option>����</option>
						<option>��õ</option>
						<option>���</option>
						<option>����</option>
					</select>
				</td>
				<th>�ٹ�����</th>
				<td>
					<select title="�ٹ�����" name="workType" >
						<option>�����</option>
						<option>������</option>
					</select>
				</td>
			</tr>
		</table>
		
		<h2>�з�</h2>
		<table id="education" border="">
			<div class="btn right">
				<button name="recruitWrite">�߰�</button>
				<button name="recruitDelete">����</button>
			</div>
			<tr>
				<th></th>
				<th>���бⰣ</th>
				<th>����</th>
				<th>�б���(������)</th>
				<th>����</th>
				<th>����</th>
			</tr>
			<tr>
				<td>
					<input id="educationChk" name="educationChk" type="checkbox">
				</td>
				<td>
					<input title="���۱Ⱓ" name="startPeriod" type="text"><br>
					 ~ <br>
					 <input title="����Ⱓ" name="endPeriod" type="text">
				</td>
				<td>
					<select title="����" name="division">
						<option>����</option>
						<option>����</option>
						<option>����</option>
					</select>
				</td>
				<td>
					<input title="�б���" name="schoolName" type="text">
					<br>
					<select title="������" name="location">
						<option>����</option>
						<option>��õ</option>
						<option>���</option>
					</select>
				</td>
				<td>
					<input title="����" name="major" type="text">
				</td><td>
					<input title="����" name="grade" type="text">
				</td>
			</tr>	
		</table>
		
		<h2>���</h2>
		<table id="career" border="">
			<div class="btn right">
				<button name="careerWrite">�߰�</button>
				<button name="careerDelete">����</button>
			</div>
			<tr>
				<th></th>
				<th>�ٹ��Ⱓ</th>
				<th>ȸ���</th>
				<th>�μ�/����/��å</th>
				<th>����</th>
			</tr>
			<tr>
				<td>
					<input id="careerChk" name="careerChk" type="checkbox">
				</td>
				<td>
					<input id="startPeriod" name="startPeriod" type="text"> ~ <br>
					<input id="endPeriod" name="endPeriod" type="text">
				</td>
				<td>
					<input id="compName" name="compName" type="text">
				</td>
				<td>
					<input id="task" name="task" type="text">
				</td>
				<td>
					<input id="location" name="location" type="text">
				</td>
			</tr>	
		</table>
		
		<h2>�ڰ���</h2>
		<table id="certificate" border="">
			<div class="btn right">
				<button name="certificateWrite">�߰�</button>
				<button name="certificateDelete">����</button>
			</div>
			<tr>
				<th></th>
				<th>�ڰ�����</th>
				<th>�����</th>
				<th>����ó</th>
			</tr>
			<tr>
				<td>
					<input id="certificateChk" name="certificateChk" type="checkbox">
				</td>
				<td>
					<input id="qualifiName" name="qualifiName" type="text">
				</td>
				<td>
					<input id="acquDate" name="acquDate" type="text">
				</td>
				<td>
					<input id="organizeName" name="organizeName" type="text">
				</td>
			</tr>	
		</table>
		
		</td>
		</tr>
		</tbody>
	</table>
	<br>
	<div class="btn center">
		<button id="save" name="resumeSave">����</button>
		<button id="submit" name="resumeSubmit">����</button>
	</div>
</form>	
</body>
</html>