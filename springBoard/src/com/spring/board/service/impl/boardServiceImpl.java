package com.spring.board.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.board.dao.BoardDao;
import com.spring.board.service.boardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
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
	//입사 조회
	@Override
	public RecruitVo recruitView(String seq) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.recruitView(seq);
	}
	//입사지원 로그인
	@Override
	public int login(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
	return boardDao.login(recruitVo);
	}
	//지원자 정보 수정
	@Override
	public int recruitUpdate(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.recruitUpdate(recruitVo);
	}
	//학력 조회
	@Override
	public ArrayList<EducationVo> educationView(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.educationView(educationVo);
	}
	//경력 조회
	@Override
	public ArrayList<CareerVo> careerView(CareerVo careerVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.careerView(careerVo);
	}
	//자격증 조회
	@Override
	public ArrayList<CertificateVo> certificateView(CertificateVo certificateVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.certificateView(certificateVo);
	}
	//학력 추가
	@Override
	public int educationSave(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.educationSave(educationVo);
	}
	//경력 추가
	@Override
	public int careerSave(CareerVo careerVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.careerSave(careerVo);
	}
	//자격증 추가
	@Override
	public int certificateSave(CertificateVo certificateVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.certificateSave(certificateVo);
	}
	//학력 수정
	public int educationUpdate(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.educationUpdate(educationVo);
	}
	//경력 수정
	
	//자격증 수정	
		
	//학력 삭제
	@Override
	public int educationDelete(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.educationDelete(educationVo);
	}
	//경력 삭제
	@Override
	public int careerDelete(CareerVo careerVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.careerDelete(careerVo);
	}
	//자격증 삭제
	@Override
	public int certificateDelete(CertificateVo certificateVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.certificateDelete(certificateVo);
	}

}
