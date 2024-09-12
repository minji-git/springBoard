<%@page import="com.spring.board.vo.UserVo"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>MBTI 테스트</title>
<link rel="stylesheet" href="/css/mbtiStyle.css"></link>
</head>
<script type="text/javascript">

	document.addEventListener("DOMContentLoaded", function() {

		const mbtiForm = document.getElementById("mbtiForm");
	    const nextButton = mbtiForm.querySelector("button[type='button'][onclick*='mbtiTest.do?pageNo=${currentPage + 1}']");
	    const submitButton = document.getElementById("submit");
	    
	    //form radio 데이터 저장
	    const formData = {};
	    
	 	// localStorage에서 이전 페이지에서 저장된 데이터 불러오기
	    const savedData = localStorage.getItem('formData');
	    if (savedData) {
	        const storedData = JSON.parse(savedData);
	        Object.assign(formData, storedData); // 기존 formData에 저장된 데이터 추가
	        
	        // 저장된 데이터로 라디오 버튼 미리 선택
	        for (const [name, value] of Object.entries(storedData)) {
	            const radio = mbtiForm.querySelector(`input[name="${name}"][value="${value}"]`);
	            if (radio) {
	                radio.checked = true;
	            }
	        }
	    }
	    
	    // 모든 라디오 버튼을 체크하는 함수
	    function checkAllSelected() {
	        const questions = mbtiForm.querySelectorAll(".question-page .radio");
	        let allSelected = true;
	        
	        for (let question of questions) {
	            const radios = question.querySelectorAll("input[type='radio']");
		        const selectRadio = question.querySelector('input[type="radio"]:checked');
		        
	            // 라디오 버튼 중 하나라도 선택되지 않은 경우
	            if (!Array.from(radios).some(radio => radio.checked)) {
	            	allSelected = false; // 비활성화
	                break;
	            } else {
	            // 선택된 라디오 버튼 데이터 저장
					const radioName = selectRadio.name;
	            	formData[radioName] = selectRadio.value;
	            	localStorage.setItem('formData', JSON.stringify(formData)); // JSON 형식으로 로컬스토리지에 저장
// 	            	console.log(formData);
	            }
	            
	        }
	        //버튼 활성화
	        if(nextButton) {
		        nextButton.disabled = !allSelected; // 다음 버튼 활성화
	        }
	        if(submitButton) {
		        submitButton.disabled = !allSelected; // 결과보기 버튼 활성화
	        }
	    }
	
	    // 폼 변경(라디오 버튼 변경) 이벤트 리스너 추가
	    mbtiForm.addEventListener("change", checkAllSelected);
	    
	    // 초기 상태 체크 : false
	    checkAllSelected();
	    
	    
	 	// 폼 제출 함수
        mbtiForm.addEventListener("submit", function(event) {
        	event.preventDefault();
	   		
        	//formData 복원
        	const savedData = localStorage.getItem('formData'); //json 형식
            console.log("saveData : " + savedData); // 모든 input radio name과 value를 출력
        	
        	$j.ajax({
        		url : '/mbti/mbtiCalculation.do',
        		dataType: 'json',
        		type: 'POST',
        		data : savedData,
        		contentType: 'application/json',
        		success: function(resp, textStatus, jqXHER){
        			alert("mbti 테스트 결과 : " + resp.mbti + "(" + resp.msg + ")");
        			
        			location.href = "/mbti/mbtiResult.do?mbti=" + resp.mbti;
        		},
        		error : function(textStatus, jqXHR, errorThrown){
        			alert("mbti 결과 오류 발생 : " + textStatus + ", " + jqXHR + ', ' + errorThrown)
        		}
        		
        	});
        });
	});
	
</script>
<body>
	<h1>MBTI 테스트 (${currentPage}/4)</h1>
	<form id="mbtiForm">
		<div id="questions" class="question-page">
			<c:forEach var="mbti" items="${mbtiList}">
				<div class="question">${mbti.boardComment}</div>
				<div class="radio">동의 
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="1">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="2">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="3">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="4">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="5">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="6">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="7">
					 비동의
				</div>
				<hr>
			</c:forEach>
			<div class="button">
				<c:if test="${currentPage == 1}">
					<button type="button" onclick="location.href='/mbti/mbtiStart.do'">이전</button>
					<button type="button" onclick="location.href='/mbti/mbtiTest.do?pageNo=${currentPage + 1}'" disabled>다음</button>
				</c:if>
				<c:if test="${currentPage > 1 && currentPage < 4}">
					<button type="button" onclick="location.href='/mbti/mbtiTest.do?pageNo=${currentPage - 1}'">이전</button>
					<button type="button" onclick="location.href='/mbti/mbtiTest.do?pageNo=${currentPage + 1}'" disabled>다음</button>
		        </c:if>
		        <c:if test="${currentPage == 4}">
					<button type="button" onclick="location.href='/mbti/mbtiTest.do?pageNo=${currentPage - 1}'">이전</button>
		        	<input id="submit" type="submit" value="결과보기" disabled>
		        </c:if>
			</div>
		</div>
	</form>
</body>
</html>
