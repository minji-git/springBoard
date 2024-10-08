package com.spring.board.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.board.dao.BoardDao;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.CodeVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.RecruitVo;
import com.spring.board.vo.UserVo;

@Repository
public class BoardDaoImpl implements BoardDao{
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public String selectTest() throws Exception {
		// TODO Auto-generated method stub
		
		String a = sqlSession.selectOne("board.boardList");
		
		return a;
	}
	/**
	 * 
	 * */
//	@Override
//	public List<BoardVo> selectBoardList(PageVo pageVo) throws Exception {
//		// TODO Auto-generated method stub
//		return sqlSession.selectList("board.boardList",pageVo);
//	}
	
	@Override
	public int selectBoardCnt() throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("board.boardTotal");
	}
	
	@Override
	public BoardVo selectBoard(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("board.boardView", boardVo);
	}
	
	@Override
	public int boardInsert(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("board.boardInsert", boardVo);
	}
	@Override
	public int boardUpdate(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.update("board.boardUpdate", boardVo);
	}
	@Override
	public int boardDelete(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("board.boardDelete", boardVo);
	}
	@Override
	public List<BoardVo> boardTypeSearch(Map<String, Object> map) throws Exception {
		return sqlSession.selectList("board.boardTypeSearch", map);
	}
	@Override
	public List<CodeVo> codeList(CodeVo codeVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("board.codeList", codeVo);
	}
	@Override
	public int selectId(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("user.selectId", userVo);
	}
	@Override
	public List<CodeVo> phoneList() throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("user.phoneList");
	}
	@Override
	public int userInsert(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("user.userInsert", userVo);
	}
	@Override
	public UserVo userSelect(UserVo userVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("user.userSelect", userVo);
	}
	
	//MBTI TEST
	@Override
	public List<BoardVo> mbtiList(int pageNo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("board.mbtiList", pageNo);
	}
	
	//입사지원 중복확인
	@Override
	public RecruitVo loginChk(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("recruit.loginChk", recruitVo);
	}
	//입사 조회
	@Override
	public RecruitVo recruitView(String seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("recruit.recruitView", seq);
	}
	//입사지원 로그인
	@Override
	public int login(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.login", recruitVo);
	}
	//지원자 정보 수정
	@Override
	public int recruitUpdate(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.update("recruit.recruitUpdate", recruitVo);
	}
	//학력 조회
	@Override
	public ArrayList<EducationVo> educationView(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		List<EducationVo> eduList = sqlSession.selectList("recruit.educationView", educationVo);
		return (ArrayList<EducationVo>)eduList;
	}
	//경력 조회
	@Override
	public ArrayList<CareerVo> careerView(CareerVo careerVo) throws Exception {
		// TODO Auto-generated method stub
		List<CareerVo> carList = sqlSession.selectList("recruit.careerView", careerVo);
		return (ArrayList<CareerVo>) carList;
	}
	//자격증 조회
	@Override
	public ArrayList<CertificateVo> certificateView(CertificateVo certificateVo) throws Exception {
		// TODO Auto-generated method stub
		List<CertificateVo> cerList = sqlSession.selectList("recruit.certificateView", certificateVo);
		return (ArrayList<CertificateVo>) cerList;
	}
	//학력 추가
	@Override
	public int educationSave(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.educationSave", educationVo);
	}
	//경력 추가
	@Override
	public int careerSave(CareerVo careerVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.careerSave", careerVo);
	}
	//자격증 추가
	@Override
	public int certificateSave(CertificateVo certificateVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.certificateSave", certificateVo);
	}	
	//학력 수정
	public int educationUpdate(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.update("recruit.educationUpdate", educationVo);
	}
	//경력 수정
	
	//자격증 수정
	
	//학력 삭제
	@Override
	public int educationDelete(EducationVo educationVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.educationDelete", educationVo);
	}
	//경력 삭제
	@Override
	public int careerDelete(CareerVo careerVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.careerDelete", careerVo);
	}
	//자격증 삭제
	@Override
	public int certificateDelete(CertificateVo certificateVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.certificateDelete", certificateVo);
	}
	
}
