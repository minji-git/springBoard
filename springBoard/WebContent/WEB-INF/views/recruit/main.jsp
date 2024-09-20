<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>입사지원</title>
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
<h2 style="text-align: center;">입사 지원서</h2>
<form class="resumeForm" method="post">
	<table id="resume" border="">
		<tbody>
		<tr>
		<td>
		<br>
		
		<table id="recruitVo" border="" align="center">
			<tr>
				<th>이름</th>
				<td>
					${sessionScope.recruit.name}
				</td>
				<th>생년월일</th>
				<td>
					<input id="birth" name="birth" type="text">
				</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>
					<select id="field3" name="field3" >
						<option>남자</option>
						<option>여자</option>
					</select>
				</td>
				<th>연락처</th>
				<td>
					${sessionScope.recruit.phone}
				</td>
			</tr>
			<tr>
				<th>email</th>
				<td>
					<input id="email" name="email" type="text">
				</td>
				<th>주소</th>
				<td>
					<input id="addr" name="addr" type="text">
				</td>
			</tr>
			<tr>
				<th>희망근무지</th>
				<td>
					<select id="location" name="location" >
						<option>서울</option>
						<option>인천</option>
						<option>경기</option>
						<option>광주</option>
					</select>
				</td>
				<th>근무형태</th>
				<td>
					<select id="workType" name="workType" >
						<option>계약직</option>
						<option>정규직</option>
					</select>
				</td>
			</tr>
		</table>
		
		<h2>학력</h2>
		<table id="educationVo" border="">
			<div class="btn right">
				<button name="recruitWrite">추가</button>
				<button name="recruitDelete">삭제</button>
			</div>
			<tr>
				<th></th>
				<th>재학기간</th>
				<th>구분</th>
				<th>학교명(소재지)</th>
				<th>전공</th>
				<th>학점</th>
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
						<option>재학</option>
						<option>중퇴</option>
						<option>졸업</option>
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
		
		<h2>경력</h2>
		<table id="careerVo" border="">
			<div class="btn right">
				<button name="careerWrite">추가</button>
				<button name="careerDelete">삭제</button>
			</div>
			<tr>
				<th></th>
				<th>근무기간</th>
				<th>회사명</th>
				<th>부서/직급/직책</th>
				<th>지역</th>
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
		
		<h2>자격증</h2>
		<table id="certificateVo" border="">
			<div class="btn right">
				<button name="certificateWrite">추가</button>
				<button name="certificateDelete">삭제</button>
			</div>
			<tr>
				<th></th>
				<th>자격증명</th>
				<th>취득일</th>
				<th>발행처</th>
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
		<button name="recruitVoWrite">저장</button>
		<button name="recruitVoDelete">제출</button>
	</div>
</form>	
</body>
</html>