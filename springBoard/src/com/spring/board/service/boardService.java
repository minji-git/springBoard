package com.spring.board.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.CodeVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.RecruitVo;
import com.spring.board.vo.UserVo;

public interface boardService {

	public String selectTest() throws Exception;

//	public List<BoardVo> SelectBoardList(PageVo pageVo) throws Exception;

	public BoardVo selectBoard(String boardType, int boardNum) throws Exception;

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
	
	//입사지원 중복확인 및 조회
	public RecruitVo loginChk(RecruitVo recruitVo) throws Exception;
	//입사 조회
	public RecruitVo recruitView(String seq) throws Exception;
	//입사지원 로그인
	public int login(RecruitVo recruitVo) throws Exception;
	//지원자 정보 수정
	public int recruitUpdate(RecruitVo recruitVo) throws Exception;
	//학력 조회
	public ArrayList<EducationVo> educationView(EducationVo educationVo) throws Exception;
	//경력 조회
	public ArrayList<CareerVo> careerView(CareerVo careerVo) throws Exception;
	//자격증 조회
	public ArrayList<CertificateVo> certificateView(CertificateVo certificateVo) throws Exception;
	//학력 추가
	public int educationSave(EducationVo educationVo) throws Exception;
	//경력 추가
	public int careerSave(CareerVo careerVo) throws Exception;
	//자격증 추가
	public int certificateSave(CertificateVo certificateVo) throws Exception;
	//학력 수정
	public int educationUpdate(EducationVo educationVo) throws Exception;
	//경력 수정
	
	//자격증 수정	
		
	//학력 삭제
	public int educationDelete(EducationVo educationVo) throws Exception;
	//경력 삭제
	public int careerDelete(CareerVo careerVo) throws Exception;
	//자격증 삭제
	public int certificateDelete(CertificateVo certificateVo) throws Exception;
	
}

