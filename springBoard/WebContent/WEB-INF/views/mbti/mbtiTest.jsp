<%@page import="com.spring.board.vo.UserVo"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>MBTI �׽�Ʈ</title>
<link rel="stylesheet" href="/css/mbtiStyle.css"></link>
</head>
<script type="text/javascript">

	document.addEventListener("DOMContentLoaded", function() {

		const mbtiForm = document.getElementById("mbtiForm");
	    const nextButton = mbtiForm.querySelector("button[type='button'][onclick*='mbtiTest.do?pageNo=${currentPage + 1}']");
	    const submitButton = document.getElementById("submit");
	    
	    //form radio ������ ����
	    const formData = {};
	    
	 	// localStorage���� ���� ���������� ����� ������ �ҷ�����
	    const savedData = localStorage.getItem('formData');
	    if (savedData) {
	        const storedData = JSON.parse(savedData);
	        Object.assign(formData, storedData); // ���� formData�� ����� ������ �߰�
	        
	        // ����� �����ͷ� ���� ��ư �̸� ����
	        for (const [name, value] of Object.entries(storedData)) {
	            const radio = mbtiForm.querySelector(`input[name="${name}"][value="${value}"]`);
	            if (radio) {
	                radio.checked = true;
	            }
	        }
	    }
	    
	    // ��� ���� ��ư�� üũ�ϴ� �Լ�
	    function checkAllSelected() {
	        const questions = mbtiForm.querySelectorAll(".question-page .radio");
	        let allSelected = true;
	        
	        for (let question of questions) {
	            const radios = question.querySelectorAll("input[type='radio']");
		        const selectRadio = question.querySelector('input[type="radio"]:checked');
		        
	            // ���� ��ư �� �ϳ��� ���õ��� ���� ���
	            if (!Array.from(radios).some(radio => radio.checked)) {
	            	allSelected = false; // ��Ȱ��ȭ
	                break;
	            } else {
	            // ���õ� ���� ��ư ������ ����
					const radioName = selectRadio.name;
	            	formData[radioName] = selectRadio.value;
	            	localStorage.setItem('formData', JSON.stringify(formData)); // JSON �������� ���ý��丮���� ����
// 	            	console.log(formData);
	            }
	            
	        }
	        //��ư Ȱ��ȭ
	        if(nextButton) {
		        nextButton.disabled = !allSelected; // ���� ��ư Ȱ��ȭ
	        }
	        if(submitButton) {
		        submitButton.disabled = !allSelected; // ������� ��ư Ȱ��ȭ
	        }
	    }
	
	    // �� ����(���� ��ư ����) �̺�Ʈ ������ �߰�
	    mbtiForm.addEventListener("change", checkAllSelected);
	    
	    // �ʱ� ���� üũ : false
	    checkAllSelected();
	    
	    
	 	// �� ���� �Լ�
        mbtiForm.addEventListener("submit", function(event) {
        	event.preventDefault();
	   		
        	//formData ����
        	const savedData = localStorage.getItem('formData'); //json ����
            console.log("saveData : " + savedData); // ��� input radio name�� value�� ���
        	
        	$j.ajax({
        		url : '/mbti/mbtiCalculation.do',
        		dataType: 'json',
        		type: 'POST',
        		data : savedData,
        		contentType: 'application/json',
        		success: function(resp, textStatus, jqXHER){
        			alert("mbti �׽�Ʈ ��� : " + resp.mbti + "(" + resp.msg + ")");
        			
        			location.href = "/mbti/mbtiResult.do?mbti=" + resp.mbti;
        		},
        		error : function(textStatus, jqXHR, errorThrown){
        			alert("mbti ��� ���� �߻� : " + textStatus + ", " + jqXHR + ', ' + errorThrown)
        		}
        		
        	});
        });
	});
	
</script>
<body>
	<h1>MBTI �׽�Ʈ (${currentPage}/4)</h1>
	<form id="mbtiForm">
		<div id="questions" class="question-page">
			<c:forEach var="mbti" items="${mbtiList}">
				<div class="question">${mbti.boardComment}</div>
				<div class="radio">���� 
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="1">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="2">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="3">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="4">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="5">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="6">
					<input type="radio" name="${mbti.boardType}${mbti.boardNum}" value="7">
					 ����
				</div>
				<hr>
			</c:forEach>
			<div class="button">
				<c:if test="${currentPage == 1}">
					<button type="button" onclick="location.href='/mbti/mbtiStart.do'">����</button>
					<button type="button" onclick="location.href='/mbti/mbtiTest.do?pageNo=${currentPage + 1}'" disabled>����</button>
				</c:if>
				<c:if test="${currentPage > 1 && currentPage < 4}">
					<button type="button" onclick="location.href='/mbti/mbtiTest.do?pageNo=${currentPage - 1}'">����</button>
					<button type="button" onclick="location.href='/mbti/mbtiTest.do?pageNo=${currentPage + 1}'" disabled>����</button>
		        </c:if>
		        <c:if test="${currentPage == 4}">
					<button type="button" onclick="location.href='/mbti/mbtiTest.do?pageNo=${currentPage - 1}'">����</button>
		        	<input id="submit" type="submit" value="�������" disabled>
		        </c:if>
			</div>
		</div>
	</form>
</body>
</html>
