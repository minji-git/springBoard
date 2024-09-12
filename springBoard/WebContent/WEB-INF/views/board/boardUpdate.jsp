<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>boardUpdate</title>
</head>
<script src="/resources/js/jquery-1.10.2.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		
		$("#submit").on("click", function(){
			var $frm = $('.boardUpdate :input');
			var param = $frm.serialize();
			console.log("param : " + param);
			
			$.ajax({
				url : "/board/boardUpdateAction.do",
				dataType : "json",
				type : "POST",
				data : param,
				success : function(data, textStatue, jqXHR){
					alert("수정완료");
					alert("메세지:" + data.success);
					location.href="/board/boardList.do";
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert("실패 : " + jqXHR + textStatus + errorThrown);
				}
			});
		});
	});
</script>
<body>
<form class="boardUpdate">
	<input name="boardType" type="hidden" value="${board.boardType }">
	<input name="boardNum" type="hidden" value="${board.boardNum}">
	
	<table align="center">
		<tr>
			<td align="right">
			<input id="submit" type="button" value="수정 완료">
			</td>
		</tr>
		<tr>
			<td>
				<table border ="1"> 
					<tr>
						<td width="120" align="center">
						Title
						</td>
						<td width="400">
						<input name="boardTitle" type="text" size="50" value="${board.boardTitle}"> 
						</td>
					</tr>
					<tr>
						<td height="300" align="center">
						Comment
						</td>
						<td valign="top">
						<textarea name="boardComment"  rows="20" cols="55">${board.boardComment}</textarea>
						</td>
					</tr>
					<tr>
						<td align="center">
						Writer
						</td>
						<td>
						<input name="creator" type="text" value="${sessionScope.userVo.userName}" readonly="readonly">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right">
				<a href="/board/boardList.do">List</a>
			</td>
		</tr>
	</table>
</form>	
</body>
</html>