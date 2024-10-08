<%@page import="com.spring.board.vo.EducationVo"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>입사지원</title>
<link rel="stylesheet" href="/css/resumeStyle.css"></link>
</head>
<script type="text/javascript">
	

	$j(document).ready(function(){
		
		$j('#save').on('click', function(event){
			event.preventDefault();
			
			const input = $j('#recruit :input, #education :input, #career :input, #certificate :input');
			console.log(input);
			let isValid = true; // 유효성 검사
			
			input.each(function(){
				let htmlObj = this;
				
				if (!htmlObj.value 
						&& htmlObj.name !== 'eduChk' 
						&& htmlObj.name !== 'carChk' 
						&& htmlObj.name !== 'certChk') {
	                alert("\"" + htmlObj.name + htmlObj.title + "\" 입력하세요");
	                htmlObj.focus();
	                isValid = false;
	                
	                return false;
				}
			});
			
		    if (!isValid) {
	        	return; // 유효성 검사 실패 시 AJAX 요청 중단
	        }
			
			// 전체 폼 데이터를 직렬화
		    const param = $j('#resumeForm').not('[name="eduChk, carChk, certChk"]').serialize();
		    console.log("param : " + param);
			
			//ajax 처리
			$j.ajax({
				url : "/recruit/recruitSave.do",
				type : "POST",
				data : param,
				dataType : "json",
				success : function(resp, textStatus, jqXHR){
					if(resp.recruit == "Y") {
						alert("recruit 수정 및 저장 완료");
						//education 저장 여부
						if(resp.eduInsert && resp.eduUpdate) {
							alert("education 수정 및 저장");
						} else if(resp.eduInsert) {
							alert("education 입력 건수 :" + resp.eduInsert);
						} else if(resp.eduUpdate) {
							alert("education 수정 건수 :" + resp.eduUpdate);
						} else {
							alert("추가된 education 없음");
						}
						//career 저장 여부
						if(resp.career == "Y") {
							alert("career 저장!");
						} else if(resp.career == 0) {
							alert("추가된 career 없음");
						}
						//certificate 저장 여부
						if(resp.certificate == "Y") {
							alert("certificate 저장!");
						} else if(resp.career == 0) {
							alert("추가된 certificate 없음");
						}
						// recruit/main.do 화면으로 리다이렉트 처리
						if(resp.redirectUrl) {
							window.location.href = resp.redirectUrl;
						}
					} else if(resp.error) {
						alert(resp.error);
					}
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert("오류 발생 : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
				
			});
			
		});	
		
		//학력, 경력, 자격증 행 추가
		$j('#eduAddRow, #careerAddRow, #certifiAddRow').on('click', function(event){
			event.preventDefault();
			
			var isEdu = $j(this).is('#eduAddRow');
			var isCareer = $j(this).is('#careerAddRow');
			var isCertifi = $j(this).is('#certifiAddRow');
			
			// 학력 행을 위한 HTML 템플릿
		    if (isEdu) {
		    	var newEduRow = `
		            <tr>
		                <td>
		                	<input class="eduChk" name="eduChk" type="checkbox">
	                	</td>
		                <td>
		                	<input title="시작기간" name="startPeriod" type="text">
		                	 ~ <br>
		         			<input title="종료기간" name="endPeriod" type="text">
		                </td>
		                <td>
		                    <select title="구분" name="division">
		                        <option value="재학">재학</option>
		                        <option value="중퇴">중퇴</option>
		                        <option value="졸업">졸업</option>
		                    </select>
		                </td>
		                <td>
		                    <input title="학교명" name="schoolName" type="text">
		                    <br>
		                    <select title="소재지" name="eduLocation">
			                    <c:forEach var="local" items="${localList}">
	                            	<option value="${local}">${local}</option>
	                       		</c:forEach>
		                	</select>
		                </td>
		                <td><input title="전공" name="major" type="text"></td>
		                <td><input title="학점" name="grade" type="text"></td>
		            </tr>`;
		        $j('#education tr:last-child').after(newEduRow); // 마지막 행 뒤에 추가
		    }
			
		 	// 경력 행을 위한 HTML 템플릿
		    if(isCareer) {
		    	var newCarRow = `
		            <tr>
						<td>
							<input class="carChk" name="carChk" type="checkbox">
						</td>
						<td>
							<input title="시작기간" name="carStartPeriod" type="text">
							 ~ <br>
							<input title="종료기간" name="carEndPeriod" type="text">
						</td>
						<td><input title="회사명" name="compName" type="text"></td>
						<td><input title="부서/직급/직책" name="task" type="text"></td>
						<td><input title="지역" name="carLocation" type="text"></td>
		            </tr>`;
		        $j('#career tr:last-child').after(newCarRow); // 마지막 행 뒤에 추가
		    }
		    
		 	// 자격증 행을 위한 HTML 템플릿
		 	if(isCertifi) {
		 		var newCertRow = `
		 			<tr>
				 		<td>
							<input class="certChk" name="certChk" type="checkbox">
						</td>
						<td><input title="자격증명" name="qualifiName" type="text"></td>
						<td><input title="취득일" name="acquDate" type="text"></td>
						<td><input title="발행처" name="organizeName" type="text"></td>
		 			</tr>`;
	 			$j('#certificate tr:last-child').after(newCertRow);
		 	}
			
			$j.ajax({
				url : "/recruit/addRow.do",
				type: "POST",
				success : function(resp, textStatus, jqXHR){
					alert("행 추가 완료");
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("오류 발생 : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
				
			});
			
		});
		
		//학력 행 삭제
		$j('#eduDeleteRow').on('click', function(event){
			event.preventDefault();
			
		 	// 체크된 eduSeq 수집
		    var eduSeqs = [];
		    $j('.eduChk:checked').each(function(){
		        var eduSeq = $j(this).siblings('input[name="eduSeq"]').val();
		        eduSeqs.push(eduSeq);
		    });
		    console.log("학력 Seq[] : \"" + eduSeqs + "\"");
		    
		 	// 경력과 자격증 Seq 배열도 수집 (선택적으로)
		    var carSeqs = []; // 경력 Seq 수집
		    var certSeqs = []; // 자격증 Seq 수집
		    
			// 현재 남아있는 행 수 확인
		    var eduRowCount = $j('#education tr').length; //하나는 체크박스 행, 하나는 데이터 행
		    // 최소 1개의 행이 있어야 삭제 가능
		    if(eduRowCount - eduSeqs.length <= 1) {
		        alert('최소 1개의 학력 입력은 필수입니다.');
		        return;
		    }
			
			// 각 체크박스의 선택 여부 확인
		    var eduChecked = $j('.eduChk:checked').length > 0;
		    // 선택된 체크박스가 없는 경우 경고 메시지 출력
		    if (!eduChecked) {
		        alert('삭제할 행을 선택하세요.');
		        return;
		    }
		    
		    $j.ajax({
				url : "/recruit/deleteRow.do",
				type: "POST",
				contentType: "application/json", // JSON 형식으로 전송
				data : JSON.stringify({ 
					eduSeqs: eduSeqs, // 학력 Seq 전송
		            carSeqs: carSeqs, // 경력 Seq 전송 (빈 배열로 전송)
		            certSeqs: certSeqs // 자격증 Seq 전송 (빈 배열로 전송) 
	            }),
				dataType : "json",
				success : function(resp, textStatus, jqXHR){
					// 1.체크된 eduSeqs DB 데이터 삭제 및 행 삭제
					if(resp.education && resp.eduDel) {
						alert(resp.education);
			        // 1-1. 행만 삭제
					} else if(resp.eduDel) {
						alert(resp.eduDel);
					// 1-2. 데이터 및 행 삭제
					} else if(resp.education) {
						alert(resp.education);
					}
					$j('.eduChk:checked').each(function(){
						$j(this).closest('tr').remove();
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("오류 발생 : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
			});
		    
		});
		
		//경력 행 삭제
		$j('#careerDeleteRow').on('click', function(event){
			event.preventDefault();
			
			// 각 체크박스의 선택 여부 확인
		    var carChecked = $j('.carChk:checked').length > 0;

		    // 선택된 체크박스가 없는 경우 경고 메시지 출력
		    if(!carChecked) {
		        alert('삭제할 행을 선택하세요.');
		        return;
		    }
		    
		    // 체크했지만, 저장하지 않은 행으로 carSeq = ""
		 	// 체크된 carSeqs 수집
		    var carSeqs = [];
		    $j('.carChk:checked').each(function(){
		        var carSeq = $j(this).siblings('input[name="carSeq"]').val();
		        carSeqs.push(carSeq);
		    });
		    console.log("경력 Seq[]: \"" + carSeqs + "\"");
		    
		 	// 경력과 자격증 Seq 배열도 수집 (선택적으로)
		    var eduSeqs = []; // 학력 Seq 수집
		    var certSeqs = []; // 자격증 Seq 수집
		    
		    $j.ajax({
				url : "/recruit/deleteRow.do",
				type: "POST",
				contentType: "application/json", // JSON 형식으로 전송
				data : JSON.stringify({
					carSeqs: carSeqs, // 경력 Seq 전송
		            eduSeqs: eduSeqs, // 학력 Seq 전송(빈 배열로 전송)
		            certSeqs: certSeqs // 자격증 Seq 전송 (빈 배열로 전송) 
				}),
				dataType : "json",
				success : function(resp, textStatus, jqXHR){
			        // 1.체크된 carSeqs DB 데이터 삭제 및 행 삭제
					if(resp.career && resp.carDel) {
						alert(resp.career);
			        // 1-1. 행만 삭제
					} else if(resp.carDel) {
						alert(resp.carDel);
					// 1-2. 데이터 및 행 삭제
					} else if(resp.career) {
						alert(resp.career);
					}
					$j('.carChk:checked').each(function(){
						$j(this).closest('tr').remove();
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("오류 발생 : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
			});
		});
		
		//자격증 행 삭제
		$j('#certifiDeleteRow').on('click', function(event){
			event.preventDefault();
			
			// 각 체크박스의 선택 여부 확인
		    var certChecked = $j('.certChk:checked').length > 0;

		    // 선택된 체크박스가 없는 경우 경고 메시지 출력
		    if(!certChecked) {
		        alert('삭제할 행을 선택하세요.');
		        return;
		    }
		 	
		    // 체크된 certSeq 수집
		    var certSeqs = [];
		    $j('.certChk:checked').each(function(){
		    	var certSeq = $j(this).siblings('input[name="certSeq"]').val();
		    	certSeqs.push(certSeq);
		    });
		    console.log("자격증 Seq[]: \"" + certSeqs + "\"");
		    
		 	// 학력과 경력 Seq 배열도 수집 (선택적으로)
		    var eduSeqs = [];
		    var carSeqs = [];
		    
		    $j.ajax({
				url : "/recruit/deleteRow.do",
				contentType : "application/json",
				data : JSON.stringify({
					certSeqs : certSeqs,
					eduSeqs : eduSeqs,
					carSeqs : carSeqs
				}),
				type: "POST",
				dataType : "json",
				success : function(resp, textStatus, jqXHR){
					// 1.체크된 certSeqs DB 데이터 삭제 및 행 삭제
					if(resp.certificate && resp.certDel) {
						alert(resp.certificate);
			        // 1-1. 행만 삭제
					} else if(resp.certDel) {
						alert(resp.certDel);
					// 1-2. 데이터 및 행 삭제
					} else if(resp.certificate) {
						alert(resp.certificate);
					}
					$j('.certChk:checked').each(function(){
						$j(this).closest('tr').remove();
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("오류 발생 : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
				
			});
		    
		});
		
	});

</script>
<body>
<h2 style="text-align: center;">입사 지원서</h2>
<form id="resumeForm" name="resumeForm" method="post">
	<table id="resume" border="">
		<tbody>
		<tr>
		<td>
		<br>
		
		<table id="recruit" border="" align="center">
			<input name="seq" type="hidden" value="${sessionScope.recruit.seq}">
			<input name="name" type="hidden" value="${sessionScope.recruit.name}">
			<input name="phone" type="hidden" value="${sessionScope.recruit.phone}">
			<tr>
				<th>이름</th>
				<td>
					${recruit.name}
				</td>
				<th>생년월일</th>
				<td>
					<c:choose>
						<c:when test="${!empty recruit.birth}">
							<input title="생년월일" name="birth" type="text" value="${recruit.birth}">
						</c:when>
						<c:otherwise>
							<input title="생년월일" name="birth" type="text">
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th>성별</th>
				<td>
					<select title="성별" name="field3">
						<option value="남자"
							<c:if test="${recruit.field3 == '남자' || recruit.field3 == ''}">selected</c:if>
						>남자</option>
						<option value="여자"
							<c:if test="${recruit.field3 == '여자'}">selected</c:if>
						>여자</option>
					</select>
				</td>
				<th>연락처</th>
				<td>
					${recruit.phone}
				</td>
			</tr>
			<tr>
				<th>email</th>
				<td>
					<c:choose>
						<c:when test="${!empty recruit.email}">
							<input title="email" name="email" type="text" value="${recruit.email}">
						</c:when>
						<c:otherwise>
							<input title="email" name="email" type="text">
						</c:otherwise>
					</c:choose>
				</td>
				<th>주소</th>
				<td>
					<c:choose>
						<c:when test="${!empty recruit.addr}">
							<input title="주소" name="addr" type="text" value="${recruit.addr}">
						</c:when>
						<c:otherwise>
							<input title="주소" name="addr" type="text">
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th>희망근무지</th>
				<td>
					<select title="희망근무지" name="location" >
						<c:forEach var="local" items="${localList}">
							<option value="${local}"
								<c:if test="${local == recruit.location}">selected</c:if>
							>${local}</option>
						</c:forEach>
					</select>
				</td>
				<th>근무형태</th>
				<td>
					<select title="근무형태" name="workType">
						<option value="계약직" 
				        	<c:if test="${recruit.workType == '계약직' || recruit.workType == null || recruit.workType == ''}">selected</c:if>
				    	>계약직</option>
				    	<option value="정규직" 
				        	<c:if test="${recruit.workType == '정규직'}">selected</c:if>
					    >정규직</option>
						</select>
				</td>
			</tr>
		</table>
		<c:if test="${!empty educationList}">
			<table id="summary" border="" align="center" style="width: 840px;">
				<tr>
					<th>학력사항</th>
					<th>경력사항</th>
					<th>희망연봉</th>
					<th>희망근무지/근무형태</th>
				</tr>
				<tr>
					<td>
						<c:forEach var="education" items="${educationList}">
							<c:choose>
								<c:when test="${fn:contains(education.schoolName,'초등학교')}">초등학교(${education.endPeriod} - ${education.startPeriod}년) ${education.division}<br></c:when>
								<c:when test="${fn:contains(education.schoolName,'중학교')}">중학교(${education.endPeriod} - ${education.startPeriod}년) ${education.division}</c:when>
								<c:when test="${fn:contains(education.schoolName,'고등학교')}">고등학교(${education.endPeriod} - ${education.startPeriod}년) ${education.division}</c:when>
								<c:when test="${fn:contains(education.schoolName,'대학교')}">대학교(${education.endPeriod} - ${education.startPeriod}년) ${education.division}</c:when>
								<c:when test="${fn:contains(education.schoolName,'대학원')}">대학원(${education.endPeriod} - ${education.startPeriod}년) ${education.division}</c:when>
								<c:when test="${education.schoolName == null}"></c:when>
							</c:choose>
						</c:forEach>
					</td>
					<td>경력 년 개월 ${career.endPeriod} ~ ${career.startPeriod}</td>
					<td>회사내규에 따름</td>
					<td>${recruit.location}전체<br>${recruit.workType}</td>
				</tr>
			</table>
		</c:if>
		
		
		<h2>학력</h2>
		<table id="education" border="">
			<div class="btn right">
				<button id="eduAddRow" name="eduAddRow">추가</button>
				<button id="eduDeleteRow" name="eduDeleteRow">삭제</button>
			</div>
			<tr>
				<th></th>
				<th>재학기간</th>
				<th>구분</th>
				<th>학교명(소재지)</th>
				<th>전공</th>
				<th>학점</th>
			</tr>
			<c:forEach var="education" items="${educationList}">
				<tr>
					<td>
						<input type="hidden" name="eduSeq" value="${education.eduSeq}"> 
						<input class="eduChk" name="eduChk" type="checkbox">
					</td>
					<td>
						<input title="시작기간" name="startPeriod" type="text" value="${education.startPeriod}"><br>
						 ~ <br>
						<input title="종료기간" name="endPeriod" type="text" value="${education.endPeriod}">
					</td>
					<td>
						<select title="구분" name="division">
							<option value="재학"
								<c:if test="${education.division eq '재학' || empty education.division || education.division eq ''}">selected</c:if>
							>재학</option>
							<option value="중퇴"
								<c:if test="${education.division eq '중퇴'}">selected</c:if>
							>중퇴</option>
							<option value="졸업"
								<c:if test="${education.division eq '졸업'}">selected</c:if>
							>졸업</option>
						</select>
					</td>
					<td>
						<input title="학교명" name="schoolName" type="text" value="${education.schoolName}">
						<br>
						<select title="소재지" name="eduLocation">
							<c:forEach var="local" items="${localList}">
								<option value="${local}"
									<c:if test="${local == education.location}">selected</c:if>
								>${local}</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<input title="전공" name="major" type="text" value="${education.major}">
					</td>
					<td>
						<input title="학점" name="grade" type="text" value="${education.grade}">
					</td>
				</tr>
			</c:forEach>
			
			<!-- educationList가 비어있을 때 기본 입력 폼 추가 -->
		    <c:if test="${empty educationList}">
		        <tr>
		            <td>
		            	<input type="hidden" name="eduSeq" value="${education.eduSeq}">
		                <input class="eduChk" name="eduChk" type="checkbox">
		            </td>
		            <td>
		                <input title="시작기간" name="startPeriod" type="text"><br>
		                ~ <br>
		                <input title="종료기간" name="endPeriod" type="text">
		            </td>
		            <td>
		                <select title="구분" name="division">
		                    <option value="재학">재학</option>
		                    <option value="중퇴">중퇴</option>
		                    <option value="졸업">졸업</option>
		                </select>
		            </td>
		            <td>
		                <input title="학교명" name="schoolName" type="text">
		                <br>
		                <select title="소재지" name="eduLocation">
		                    <c:forEach var="local" items="${localList}">
		                        <option value="${local}">${local}</option>
		                    </c:forEach>
		                </select>
		            </td>
		            <td>
		                <input title="전공" name="major" type="text">
		            </td>
		            <td>
		                <input title="학점" name="grade" type="text">
		            </td>
		        </tr>
		    </c:if>
		</table>
		
		<h2>경력</h2>
		<table id="career" border="">
			<div class="btn right">
				<button id="careerAddRow" name="careerAddRow">추가</button>
				<button id="careerDeleteRow" name="careerDeleteRow">삭제</button>
			</div>
			<tr>
				<th></th>
				<th>근무기간</th>
				<th>회사명</th>
				<th>부서/직급/직책</th>
				<th>지역</th>
			</tr>
			<c:forEach var="career" items="${careerList}">
				<tr>
					<td>
						<input type="hidden" name="carSeq" value="${career.carSeq}"> 
						<input class="carChk" name="carChk" type="checkbox">
					</td>
					<td>
						<input title="시작기간" name="carStartPeriod" type="text" value="${career.startPeriod}">
						 ~ <br>
						<input title="종료기간" name="carEndPeriod" type="text" value="${career.endPeriod}">
					</td>
					<td>
						<input title="회사명" name="compName" type="text" value="${career.compName}">
					</td>
					<td>
						<input title="부서/직급/직책" name="task" type="text" value="${career.task}">
					</td>
					<td>
						<input title="지역" name="carLocation" type="text" value="${career.location}">
					</td>
				</tr>
			</c:forEach>	
		</table>
		
		<h2>자격증</h2>
		<table id="certificate" border="">
			<div class="btn right">
				<button id="certifiAddRow" name="certifiAddRow">추가</button>
				<button id="certifiDeleteRow" name="certifiDeleteRow">삭제</button>
			</div>
			<tr>
				<th></th>
				<th>자격증명</th>
				<th>취득일</th>
				<th>발행처</th>
			</tr>
			<c:forEach var="certificate" items="${certiList}">
				<tr>
					<td>
						<input type="hidden" name="certSeq" value="${certificate.certSeq}"> 
						<input class="certChk" name="certChk" type="checkbox">
					</td>
					<td>
						<input title="자격증명" name="qualifiName" type="text" value="${certificate.qualifiName}">
					</td>
					<td>
						<input title="취득일" name="acquDate" type="text" value="${certificate.acquDate}">
					</td>
					<td>
						<input title="발행처" name="organizeName" type="text" value="${certificate.organizeName}">
					</td>
				</tr>	
			</c:forEach>
		</table>
		
		</td>
		</tr>
		</tbody>
	</table>
	<br>
	<div class="btn center">
		<button id="save" name="resumeSave">저장</button>
		<button id="submit" name="resumeSubmit">제출</button>
	</div>
</form>	
</body>
</html>