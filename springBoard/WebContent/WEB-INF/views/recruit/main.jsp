<%@page import="com.spring.board.vo.EducationVo"%>
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
		
		$j('#save').on('click', function(event){
			event.preventDefault();
			
			const input = $j('#recruit :input, #education :input, #career :input, #certificate :input');
			console.log(input);
			let isValid = true; // ��ȿ�� �˻�
			
			input.each(function(){
				let htmlObj = this;
				
				if (!htmlObj.value 
						&& htmlObj.name !== 'eduChk' 
						&& htmlObj.name !== 'carChk' 
						&& htmlObj.name !== 'certChk') {
	                alert("\"" + htmlObj.name + htmlObj.title + "\" �Է��ϼ���");
	                htmlObj.focus();
	                isValid = false;
	                
	                return false;
				}
			});
			
		    if (!isValid) {
	        	return; // ��ȿ�� �˻� ���� �� AJAX ��û �ߴ�
	        }
			
			// ��ü �� �����͸� ����ȭ
		    const param = $j('#resumeForm').not('[name="eduChk, carChk, certChk"]').serialize();
		    console.log("param : " + param);
			
			//ajax ó��
			$j.ajax({
				url : "/recruit/recruitSave.do",
				type : "POST",
				data : param,
				dataType : "json",
				success : function(resp, textStatus, jqXHR){
					if(resp.recruit == "Y") {
						alert("recruit ���� �� ���� �Ϸ�");
						//education ���� ����
						if(resp.eduInsert && resp.eduUpdate) {
							alert("education ���� �� ����");
						} else if(resp.eduInsert) {
							alert("education �Է� �Ǽ� :" + resp.eduInsert);
						} else if(resp.eduUpdate) {
							alert("education ���� �Ǽ� :" + resp.eduUpdate);
						} else {
							alert("�߰��� education ����");
						}
						//career ���� ����
						if(resp.career == "Y") {
							alert("career ����!");
						} else if(resp.career == 0) {
							alert("�߰��� career ����");
						}
						//certificate ���� ����
						if(resp.certificate == "Y") {
							alert("certificate ����!");
						} else if(resp.career == 0) {
							alert("�߰��� certificate ����");
						}
						// recruit/main.do ȭ������ �����̷�Ʈ ó��
						if(resp.redirectUrl) {
							window.location.href = resp.redirectUrl;
						}
					} else if(resp.error) {
						alert(resp.error);
					}
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert("���� �߻� : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
				
			});
			
		});	
		
		//�з�, ���, �ڰ��� �� �߰�
		$j('#eduAddRow, #careerAddRow, #certifiAddRow').on('click', function(event){
			event.preventDefault();
			
			var isEdu = $j(this).is('#eduAddRow');
			var isCareer = $j(this).is('#careerAddRow');
			var isCertifi = $j(this).is('#certifiAddRow');
			
			// �з� ���� ���� HTML ���ø�
		    if (isEdu) {
		    	var newEduRow = `
		            <tr>
		                <td>
		                	<input class="eduChk" name="eduChk" type="checkbox">
	                	</td>
		                <td>
		                	<input title="���۱Ⱓ" name="startPeriod" type="text">
		                	 ~ <br>
		         			<input title="����Ⱓ" name="endPeriod" type="text">
		                </td>
		                <td>
		                    <select title="����" name="division">
		                        <option value="����">����</option>
		                        <option value="����">����</option>
		                        <option value="����">����</option>
		                    </select>
		                </td>
		                <td>
		                    <input title="�б���" name="schoolName" type="text">
		                    <br>
		                    <select title="������" name="eduLocation">
			                    <c:forEach var="local" items="${localList}">
	                            	<option value="${local}">${local}</option>
	                       		</c:forEach>
		                	</select>
		                </td>
		                <td><input title="����" name="major" type="text"></td>
		                <td><input title="����" name="grade" type="text"></td>
		            </tr>`;
		        $j('#education tr:last-child').after(newEduRow); // ������ �� �ڿ� �߰�
		    }
			
		 	// ��� ���� ���� HTML ���ø�
		    if(isCareer) {
		    	var newCarRow = `
		            <tr>
						<td>
							<input class="carChk" name="carChk" type="checkbox">
						</td>
						<td>
							<input title="���۱Ⱓ" name="carStartPeriod" type="text">
							 ~ <br>
							<input title="����Ⱓ" name="carEndPeriod" type="text">
						</td>
						<td><input title="ȸ���" name="compName" type="text"></td>
						<td><input title="�μ�/����/��å" name="task" type="text"></td>
						<td><input title="����" name="carLocation" type="text"></td>
		            </tr>`;
		        $j('#career tr:last-child').after(newCarRow); // ������ �� �ڿ� �߰�
		    }
		    
		 	// �ڰ��� ���� ���� HTML ���ø�
		 	if(isCertifi) {
		 		var newCertRow = `
		 			<tr>
				 		<td>
							<input class="certChk" name="certChk" type="checkbox">
						</td>
						<td><input title="�ڰ�����" name="qualifiName" type="text"></td>
						<td><input title="�����" name="acquDate" type="text"></td>
						<td><input title="����ó" name="organizeName" type="text"></td>
		 			</tr>`;
	 			$j('#certificate tr:last-child').after(newCertRow);
		 	}
			
			$j.ajax({
				url : "/recruit/addRow.do",
				type: "POST",
				success : function(resp, textStatus, jqXHR){
					alert("�� �߰� �Ϸ�");
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("���� �߻� : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
				
			});
			
		});
		
		//�з� �� ����
		$j('#eduDeleteRow').on('click', function(event){
			event.preventDefault();
			
		 	// üũ�� eduSeq ����
		    var eduSeqs = [];
		    $j('.eduChk:checked').each(function(){
		        var eduSeq = $j(this).siblings('input[name="eduSeq"]').val();
		        eduSeqs.push(eduSeq);
		    });
		    console.log("�з� Seq[] : \"" + eduSeqs + "\"");
		    
		 	// ��°� �ڰ��� Seq �迭�� ���� (����������)
		    var carSeqs = []; // ��� Seq ����
		    var certSeqs = []; // �ڰ��� Seq ����
		    
			// ���� �����ִ� �� �� Ȯ��
		    var eduRowCount = $j('#education tr').length; //�ϳ��� üũ�ڽ� ��, �ϳ��� ������ ��
		    // �ּ� 1���� ���� �־�� ���� ����
		    if(eduRowCount - eduSeqs.length <= 1) {
		        alert('�ּ� 1���� �з� �Է��� �ʼ��Դϴ�.');
		        return;
		    }
			
			// �� üũ�ڽ��� ���� ���� Ȯ��
		    var eduChecked = $j('.eduChk:checked').length > 0;
		    // ���õ� üũ�ڽ��� ���� ��� ��� �޽��� ���
		    if (!eduChecked) {
		        alert('������ ���� �����ϼ���.');
		        return;
		    }
		    
		    $j.ajax({
				url : "/recruit/deleteRow.do",
				type: "POST",
				contentType: "application/json", // JSON �������� ����
				data : JSON.stringify({ 
					eduSeqs: eduSeqs, // �з� Seq ����
		            carSeqs: carSeqs, // ��� Seq ���� (�� �迭�� ����)
		            certSeqs: certSeqs // �ڰ��� Seq ���� (�� �迭�� ����) 
	            }),
				dataType : "json",
				success : function(resp, textStatus, jqXHR){
					// 1.üũ�� eduSeqs DB ������ ���� �� �� ����
					if(resp.education && resp.eduDel) {
						alert(resp.education);
			        // 1-1. �ุ ����
					} else if(resp.eduDel) {
						alert(resp.eduDel);
					// 1-2. ������ �� �� ����
					} else if(resp.education) {
						alert(resp.education);
					}
					$j('.eduChk:checked').each(function(){
						$j(this).closest('tr').remove();
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("���� �߻� : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
			});
		    
		});
		
		//��� �� ����
		$j('#careerDeleteRow').on('click', function(event){
			event.preventDefault();
			
			// �� üũ�ڽ��� ���� ���� Ȯ��
		    var carChecked = $j('.carChk:checked').length > 0;

		    // ���õ� üũ�ڽ��� ���� ��� ��� �޽��� ���
		    if(!carChecked) {
		        alert('������ ���� �����ϼ���.');
		        return;
		    }
		    
		    // üũ������, �������� ���� ������ carSeq = ""
		 	// üũ�� carSeqs ����
		    var carSeqs = [];
		    $j('.carChk:checked').each(function(){
		        var carSeq = $j(this).siblings('input[name="carSeq"]').val();
		        carSeqs.push(carSeq);
		    });
		    console.log("��� Seq[]: \"" + carSeqs + "\"");
		    
		 	// ��°� �ڰ��� Seq �迭�� ���� (����������)
		    var eduSeqs = []; // �з� Seq ����
		    var certSeqs = []; // �ڰ��� Seq ����
		    
		    $j.ajax({
				url : "/recruit/deleteRow.do",
				type: "POST",
				contentType: "application/json", // JSON �������� ����
				data : JSON.stringify({
					carSeqs: carSeqs, // ��� Seq ����
		            eduSeqs: eduSeqs, // �з� Seq ����(�� �迭�� ����)
		            certSeqs: certSeqs // �ڰ��� Seq ���� (�� �迭�� ����) 
				}),
				dataType : "json",
				success : function(resp, textStatus, jqXHR){
			        // 1.üũ�� carSeqs DB ������ ���� �� �� ����
					if(resp.career && resp.carDel) {
						alert(resp.career);
			        // 1-1. �ุ ����
					} else if(resp.carDel) {
						alert(resp.carDel);
					// 1-2. ������ �� �� ����
					} else if(resp.career) {
						alert(resp.career);
					}
					$j('.carChk:checked').each(function(){
						$j(this).closest('tr').remove();
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("���� �߻� : " + jqXHR + ", " + textStatus + ", " + errorThrown);
				}
			});
		});
		
		//�ڰ��� �� ����
		$j('#certifiDeleteRow').on('click', function(event){
			event.preventDefault();
			
			// �� üũ�ڽ��� ���� ���� Ȯ��
		    var certChecked = $j('.certChk:checked').length > 0;

		    // ���õ� üũ�ڽ��� ���� ��� ��� �޽��� ���
		    if(!certChecked) {
		        alert('������ ���� �����ϼ���.');
		        return;
		    }
		 	
		    // üũ�� certSeq ����
		    var certSeqs = [];
		    $j('.certChk:checked').each(function(){
		    	var certSeq = $j(this).siblings('input[name="certSeq"]').val();
		    	certSeqs.push(certSeq);
		    });
		    console.log("�ڰ��� Seq[]: \"" + certSeqs + "\"");
		    
		 	// �з°� ��� Seq �迭�� ���� (����������)
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
					// 1.üũ�� certSeqs DB ������ ���� �� �� ����
					if(resp.certificate && resp.certDel) {
						alert(resp.certificate);
			        // 1-1. �ุ ����
					} else if(resp.certDel) {
						alert(resp.certDel);
					// 1-2. ������ �� �� ����
					} else if(resp.certificate) {
						alert(resp.certificate);
					}
					$j('.certChk:checked').each(function(){
						$j(this).closest('tr').remove();
					});
				},
				error : function(jqXHR, textStatus, errorThrown) {
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
			<input name="seq" type="hidden" value="${sessionScope.recruit.seq}">
			<input name="name" type="hidden" value="${sessionScope.recruit.name}">
			<input name="phone" type="hidden" value="${sessionScope.recruit.phone}">
			<tr>
				<th>�̸�</th>
				<td>
					${recruit.name}
				</td>
				<th>�������</th>
				<td>
					<c:choose>
						<c:when test="${!empty recruit.birth}">
							<input title="�������" name="birth" type="text" value="${recruit.birth}">
						</c:when>
						<c:otherwise>
							<input title="�������" name="birth" type="text">
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th>����</th>
				<td>
					<select title="����" name="field3">
						<option value="����"
							<c:if test="${recruit.field3 == '����' || recruit.field3 == ''}">selected</c:if>
						>����</option>
						<option value="����"
							<c:if test="${recruit.field3 == '����'}">selected</c:if>
						>����</option>
					</select>
				</td>
				<th>����ó</th>
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
				<th>�ּ�</th>
				<td>
					<c:choose>
						<c:when test="${!empty recruit.addr}">
							<input title="�ּ�" name="addr" type="text" value="${recruit.addr}">
						</c:when>
						<c:otherwise>
							<input title="�ּ�" name="addr" type="text">
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th>����ٹ���</th>
				<td>
					<select title="����ٹ���" name="location" >
						<c:forEach var="local" items="${localList}">
							<option value="${local}"
								<c:if test="${local == recruit.location}">selected</c:if>
							>${local}</option>
						</c:forEach>
					</select>
				</td>
				<th>�ٹ�����</th>
				<td>
					<select title="�ٹ�����" name="workType">
						<option value="�����" 
				        	<c:if test="${recruit.workType == '�����' || recruit.workType == null || recruit.workType == ''}">selected</c:if>
				    	>�����</option>
				    	<option value="������" 
				        	<c:if test="${recruit.workType == '������'}">selected</c:if>
					    >������</option>
						</select>
				</td>
			</tr>
		</table>
		<c:if test="${!empty educationList}">
			<table id="summary" border="" align="center" style="width: 840px;">
				<tr>
					<th>�з»���</th>
					<th>��»���</th>
					<th>�������</th>
					<th>����ٹ���/�ٹ�����</th>
				</tr>
				<tr>
					<td>
						<c:forEach var="education" items="${educationList}">
							<c:choose>
								<c:when test="${fn:contains(education.schoolName,'�ʵ��б�')}">�ʵ��б�(${education.endPeriod} - ${education.startPeriod}��) ${education.division}<br></c:when>
								<c:when test="${fn:contains(education.schoolName,'���б�')}">���б�(${education.endPeriod} - ${education.startPeriod}��) ${education.division}</c:when>
								<c:when test="${fn:contains(education.schoolName,'����б�')}">����б�(${education.endPeriod} - ${education.startPeriod}��) ${education.division}</c:when>
								<c:when test="${fn:contains(education.schoolName,'���б�')}">���б�(${education.endPeriod} - ${education.startPeriod}��) ${education.division}</c:when>
								<c:when test="${fn:contains(education.schoolName,'���п�')}">���п�(${education.endPeriod} - ${education.startPeriod}��) ${education.division}</c:when>
								<c:when test="${education.schoolName == null}"></c:when>
							</c:choose>
						</c:forEach>
					</td>
					<td>��� �� ���� ${career.endPeriod} ~ ${career.startPeriod}</td>
					<td>ȸ�系�Կ� ����</td>
					<td>${recruit.location}��ü<br>${recruit.workType}</td>
				</tr>
			</table>
		</c:if>
		
		
		<h2>�з�</h2>
		<table id="education" border="">
			<div class="btn right">
				<button id="eduAddRow" name="eduAddRow">�߰�</button>
				<button id="eduDeleteRow" name="eduDeleteRow">����</button>
			</div>
			<tr>
				<th></th>
				<th>���бⰣ</th>
				<th>����</th>
				<th>�б���(������)</th>
				<th>����</th>
				<th>����</th>
			</tr>
			<c:forEach var="education" items="${educationList}">
				<tr>
					<td>
						<input type="hidden" name="eduSeq" value="${education.eduSeq}"> 
						<input class="eduChk" name="eduChk" type="checkbox">
					</td>
					<td>
						<input title="���۱Ⱓ" name="startPeriod" type="text" value="${education.startPeriod}"><br>
						 ~ <br>
						<input title="����Ⱓ" name="endPeriod" type="text" value="${education.endPeriod}">
					</td>
					<td>
						<select title="����" name="division">
							<option value="����"
								<c:if test="${education.division eq '����' || empty education.division || education.division eq ''}">selected</c:if>
							>����</option>
							<option value="����"
								<c:if test="${education.division eq '����'}">selected</c:if>
							>����</option>
							<option value="����"
								<c:if test="${education.division eq '����'}">selected</c:if>
							>����</option>
						</select>
					</td>
					<td>
						<input title="�б���" name="schoolName" type="text" value="${education.schoolName}">
						<br>
						<select title="������" name="eduLocation">
							<c:forEach var="local" items="${localList}">
								<option value="${local}"
									<c:if test="${local == education.location}">selected</c:if>
								>${local}</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<input title="����" name="major" type="text" value="${education.major}">
					</td>
					<td>
						<input title="����" name="grade" type="text" value="${education.grade}">
					</td>
				</tr>
			</c:forEach>
			
			<!-- educationList�� ������� �� �⺻ �Է� �� �߰� -->
		    <c:if test="${empty educationList}">
		        <tr>
		            <td>
		            	<input type="hidden" name="eduSeq" value="${education.eduSeq}">
		                <input class="eduChk" name="eduChk" type="checkbox">
		            </td>
		            <td>
		                <input title="���۱Ⱓ" name="startPeriod" type="text"><br>
		                ~ <br>
		                <input title="����Ⱓ" name="endPeriod" type="text">
		            </td>
		            <td>
		                <select title="����" name="division">
		                    <option value="����">����</option>
		                    <option value="����">����</option>
		                    <option value="����">����</option>
		                </select>
		            </td>
		            <td>
		                <input title="�б���" name="schoolName" type="text">
		                <br>
		                <select title="������" name="eduLocation">
		                    <c:forEach var="local" items="${localList}">
		                        <option value="${local}">${local}</option>
		                    </c:forEach>
		                </select>
		            </td>
		            <td>
		                <input title="����" name="major" type="text">
		            </td>
		            <td>
		                <input title="����" name="grade" type="text">
		            </td>
		        </tr>
		    </c:if>
		</table>
		
		<h2>���</h2>
		<table id="career" border="">
			<div class="btn right">
				<button id="careerAddRow" name="careerAddRow">�߰�</button>
				<button id="careerDeleteRow" name="careerDeleteRow">����</button>
			</div>
			<tr>
				<th></th>
				<th>�ٹ��Ⱓ</th>
				<th>ȸ���</th>
				<th>�μ�/����/��å</th>
				<th>����</th>
			</tr>
			<c:forEach var="career" items="${careerList}">
				<tr>
					<td>
						<input type="hidden" name="carSeq" value="${career.carSeq}"> 
						<input class="carChk" name="carChk" type="checkbox">
					</td>
					<td>
						<input title="���۱Ⱓ" name="carStartPeriod" type="text" value="${career.startPeriod}">
						 ~ <br>
						<input title="����Ⱓ" name="carEndPeriod" type="text" value="${career.endPeriod}">
					</td>
					<td>
						<input title="ȸ���" name="compName" type="text" value="${career.compName}">
					</td>
					<td>
						<input title="�μ�/����/��å" name="task" type="text" value="${career.task}">
					</td>
					<td>
						<input title="����" name="carLocation" type="text" value="${career.location}">
					</td>
				</tr>
			</c:forEach>	
		</table>
		
		<h2>�ڰ���</h2>
		<table id="certificate" border="">
			<div class="btn right">
				<button id="certifiAddRow" name="certifiAddRow">�߰�</button>
				<button id="certifiDeleteRow" name="certifiDeleteRow">����</button>
			</div>
			<tr>
				<th></th>
				<th>�ڰ�����</th>
				<th>�����</th>
				<th>����ó</th>
			</tr>
			<c:forEach var="certificate" items="${certiList}">
				<tr>
					<td>
						<input type="hidden" name="certSeq" value="${certificate.certSeq}"> 
						<input class="certChk" name="certChk" type="checkbox">
					</td>
					<td>
						<input title="�ڰ�����" name="qualifiName" type="text" value="${certificate.qualifiName}">
					</td>
					<td>
						<input title="�����" name="acquDate" type="text" value="${certificate.acquDate}">
					</td>
					<td>
						<input title="����ó" name="organizeName" type="text" value="${certificate.organizeName}">
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
		<button id="save" name="resumeSave">����</button>
		<button id="submit" name="resumeSubmit">����</button>
	</div>
</form>	
</body>
</html>