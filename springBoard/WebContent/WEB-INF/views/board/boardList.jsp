<%@page import="com.spring.board.vo.UserVo"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>list</title>
</head>
<script type="text/javascript">

	$j(document).ready(function(){
		
		//전체 선택 클릭 여부
		$j('#selectAll').on("click", function(){
			const isChecked = $j('#selectAll').is(':checked');
			if (isChecked) {
				$j('.ele').prop('checked', true);
			} else {
				$j('.ele').prop('checked', false);
			}
		});
		//개별 선택으로 전체 작동
		$j('.ele').on("click", function() {
			var total = $j('.ele').length;
			var checked = $j('.ele:checked').length;
			
			if(total == checked) {
				$j('#selectAll').prop('checked', true);
			} else {
				$j('#selectAll').prop('checked', false);
			}
		});
		
		//board 타입 조회
		$j('#submit').on("click", function(){
			event.preventDefault();
			
			var $frm = $j(".search :input");
			var param = $frm.serialize();
			
			if(param === '') {
				alert("타입을 선택하세요");
				return false;
			}
			
			$j.ajax({
				url: "/board/boardTypeSearch.do",
				dataType : "json",
				type : "POST",
				data : param,
				success : function(data, textStatus, jqXHR) {
					alert("타입별 조회합니다.");
					console.log(data);
					
					let length = Object.keys(data).length;
					console.log(length);
					
					let cnt = '';
					let text = '';
					let boardType;
					for(let board of data){
						
						switch(board.boardType) {
							case 'a01' : 
								boardType = '일반';
								break;
							case 'a02' : 
								boardType = 'Q&A';
								break;
							case 'a03' : 
								boardType = '익명';
								break;
							case 'a04' : 
								boardType = '자유';
								break;
							default : 
								boardType = board.boardType;
						}
						
						cnt = 'total : ' + length;
						text += '<tr><td width="80" align="center">' + boardType + '</td>';
						text += '<td>' + board.boardNum + '</td>';
						text += '<td width="300" align="left"><a href = "/board/' 
								+ board.boardType + '/' + board.boardNum + '/boardView.do?pageNo=1'
								+ '">' + board.boardTitle + '</a></td></tr>';	
					}
 					//alert(boardType + "타입 조회합니다.");
					
					$j('#cnt').html(cnt);
					$j('#boardTable tr:gt(0)').remove();
					$j('#boardTable').append(text);
					
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("실패 : " + textStatus + ", " + errorThrown)
				}
				
			});
		});
		
		//logout
		$j('#logout').on("click", function(){
			
			$j.ajax({
				url: "/board/logout.do",
				dataType : "json",
				type : "POST",
				data : "",
				success : function(data, textStatus, jqXHR) {
					if(data.success) {
						alert(data.msg);
					} else {
						alert(data.msg);
					}
					location.href = "/board/boardList.do";
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("실패 : " + textStatus + ", " + errorThrown)
				}
				
			});
		});
	});

</script>
<body>
<table  align="center" id="table">
	<tr>
		<td align="left">
		<c:choose>
			<c:when test="${empty sessionScope.userVo}">
				<a href="/board/login.do">login</a>
				<a href="/board/join.do">join</a>
			</c:when>
			<c:otherwise>
				${sessionScope.userVo.userName }
			</c:otherwise>
		</c:choose>
		</td>
		<td align="right" id="cnt">
			total : ${totalCnt}
		</td>
	</tr>
	<tr>
		<td>
			<table id="boardTable" border = "1">
				<tr id="row">
					<td width="80" align="center">
						Type
					</td>
					<td width="40" align="center">
						No
					</td>
					<td width="300" align="center">
						Title
					</td>
				</tr>
				<c:forEach items="${boardList}" var="list">
					<tr>
						<td align="center">
							<c:set var="boardType" value="${list.boardType}"></c:set>
							<c:forEach var="code" items="${codeVo}">
								<c:set var="codeId" value="${code.codeId}"></c:set>
								<c:set var="codeName" value="${code.codeName}"></c:set>
								<c:choose>
									<c:when test="${codeId eq boardType}">
										<c:out value="${codeName }"></c:out>
									</c:when>
								</c:choose>
							</c:forEach>
						</td>
						<td>
							${list.boardNum}
						</td>
						<td>
							<a href = "/board/${list.boardType}/${list.boardNum}/boardView.do?pageNo=${pageNo}">${list.boardTitle}</a>
						</td>
					</tr>	
				</c:forEach>
			</table>
		</td>
	</tr>
	<tr>
		<td align="right">
			<a href ="/board/boardWrite.do">글쓰기</a>
			<c:if test="${sessionScope.userVo != null}">
				<input type="button" id="logout" name="logout" value="로그아웃">
<!-- 				<a href = "/board/logout.do">로그아웃</a> -->
			</c:if>
		</td>
	</tr>
</table>
	<form class="search" align="center">
		<input type="checkbox" class="all" id="selectAll" name="selectAll">
		<label for="selectAll">전체</label>
		<c:forEach items="${codeVo}" var="type">
			<input type="checkbox" class="ele" id="${type.codeId}" name="boardType" value="${type.codeId}">
			<label for="${type.codeId}">${type.codeName}</label>
		</c:forEach>

		<input name="submit" id="submit" type="button" value="조회">
	</form>
</body>
</html>