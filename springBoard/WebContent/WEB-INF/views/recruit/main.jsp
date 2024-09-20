<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�Ի�����</title>
<style type="text/css">
	.resumeForm {
		position: relative;
	}
	#resume {
		margin:auto;
	}
	#educationVo, #careerVo, #certificateVo {
		margin: 20px;
		width: 840px;
	}
	.btn {
		display: flex;
	}
	.center {
		justify-content: center;
	}
	.right {
		justify-content: flex-end;
	}
	button {
		margin: 0 0 0 5px;
}
</style>
</head>
<script type="text/javascript">

	$j(document).ready(function(){
		
		
	});

</script>
<body>
<h2 style="text-align: center;">�Ի� ������</h2>
<form class="resumeForm" method="post">
	<table id="resume" border="">
		<tbody>
		<tr>
		<td>
		<br>
		
		<table id="recruitVo" border="" align="center">
			<tr>
				<th>�̸�</th>
				<td>
					${sessionScope.recruit.name}
				</td>
				<th>�������</th>
				<td>
					<input id="birth" name="birth" type="text">
				</td>
			</tr>
			<tr>
				<th>����</th>
				<td>
					<select id="field3" name="field3" >
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
					<input id="email" name="email" type="text">
				</td>
				<th>�ּ�</th>
				<td>
					<input id="addr" name="addr" type="text">
				</td>
			</tr>
			<tr>
				<th>����ٹ���</th>
				<td>
					<select id="location" name="location" >
						<option>����</option>
						<option>��õ</option>
						<option>���</option>
						<option>����</option>
					</select>
				</td>
				<th>�ٹ�����</th>
				<td>
					<select id="workType" name="workType" >
						<option>�����</option>
						<option>������</option>
					</select>
				</td>
			</tr>
		</table>
		
		<h2>�з�</h2>
		<table id="educationVo" border="">
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
					<input id="startPeriod" name="startPeriod" type="text"><br>
					 ~ <br>
					 <input id="endPeriod" name="endPeriod" type="text">
				</td>
				<td>
					<select id="division" name="division">
						<option>����</option>
						<option>����</option>
						<option>����</option>
					</select>
				</td>
				<td>
					<input id="schoolName" name="schoolName" type="text">
					<br>
					<select id="location" name="location">
						<option>
					</select>
				</td>
				<td>
					<input id="major" name="major" type="text">
				</td><td>
					<input id="grade" name="grade" type="text">
				</td>
			</tr>	
		</table>
		
		<h2>���</h2>
		<table id="careerVo" border="">
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
		<table id="certificateVo" border="">
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
		<button name="recruitVoWrite">����</button>
		<button name="recruitVoDelete">����</button>
	</div>
</form>	
</body>
</html>