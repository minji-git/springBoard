package com.spring.board.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.board.dao.BoardDao;
import com.spring.board.service.boardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CodeVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.RecruitVo;
import com.spring.board.vo.UserVo;

@Service
public class boardServiceImpl implements boardService{
	
	@Autowired
	BoardDao boardDao;
	
	@Override
	public String selectTest() throws Exception {
		// TODO Auto-generated method stub
		return boardDao.selectTest();
	}
	
//	@Override
//	public List<BoardVo> SelectBoardList(PageVo pageVo) throws Exception {
//		// TODO Auto-generated method stub
//		
//		return boardDao.selectBoardList(pageVo);
//	}
	
	@Override
	public int selectBoardCnt() throws Exception {
		// TODO Auto-generated method stub
		return boardDao.selectBoardCnt();
	}
	
	@Override
	public BoardVo selectBoard(String boardType, int boardNum) throws Exception {
		// TODO Auto-generated method stub
		BoardVo boardVo = new BoardVo();
		
		boardVo.setBoardType(boardType);
		boardVo.setBoardNum(boardNum);
		
		return boardDao.selectBoard(boardVo);
	}
	
	@Override
	public int boardInsert(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.boardInsert(boardVo);
	}

	@Override
	public int boardUpdate(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.boardUpdate(boardVo);
	}

	@Override
	public int boardDelete(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.boardDelete(boardVo);
	}

	@Override
	public List<BoardVo> boardTypeSearch(Map<String, Object> map) throws Exception {
		return boardDao.boardTypeSearch(map);
	}

	@Override
	public List<CodeVo> codeList(CodeVo codeVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.codeList(codeVo);
	}

	@Override
	public int selectId(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.selectId(userVo);
	}

	@Override
	public List<CodeVo> phoneList() throws Exception {
		// TODO Auto-generated method stub
		return boardDao.phoneList();
	}

	@Override
	public int userInsert(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.userInsert(userVo);
	}

	@Override
	public UserVo userSelect(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.userSelect(userVo);
	}
	//MBTI TEST
	@Override
	public List<BoardVo> mbtiList(int pageNo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.mbtiList(pageNo);
	}
	//입사지원 중복확인
	@Override
	public RecruitVo loginChk(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.loginChk(recruitVo);
	}
	//입사지원 로그인
	@Override
	public int login(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
	return boardDao.login(recruitVo);
	}

	@Override
	public int educationSave(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.educationSave(educationVo);
	}
	
}
