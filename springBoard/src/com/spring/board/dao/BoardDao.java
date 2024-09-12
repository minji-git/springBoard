package com.spring.board.dao;

import java.util.List;
import java.util.Map;

import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CodeVo;
import com.spring.board.vo.RecruitVo;
import com.spring.board.vo.UserVo;

public interface BoardDao {

	public String selectTest() throws Exception;

//	public List<BoardVo> selectBoardList(PageVo pageVo) throws Exception;

	public BoardVo selectBoard(BoardVo boardVo) throws Exception;

	public int selectBoardCnt() throws Exception;

	public int boardInsert(BoardVo boardVo) throws Exception;
	
	public int boardUpdate(BoardVo boardVo) throws Exception;
	
	public int boardDelete(BoardVo boardVo) throws Exception;
	
	public List<BoardVo> boardTypeSearch(Map<String, Object> map) throws Exception;
	
	public List<CodeVo> codeList(CodeVo codeVo) throws Exception; 
	
	public int selectId(UserVo userVo) throws Exception;
	
	public List<CodeVo> phoneList() throws Exception;
	
	public int userInsert(UserVo userVo) throws Exception;
	
	public UserVo userSelect(UserVo userVo) throws Exception;
	//MBTI TEST
	public List<BoardVo> mbtiList(int pageNo) throws Exception;
	//입사지원 로그인
	public int login(RecruitVo recruitVo) throws Exception;
}
