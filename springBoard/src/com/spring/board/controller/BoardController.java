package com.spring.board.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.boardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CodeVo;
import com.spring.board.vo.PageVo;
import com.spring.board.vo.UserVo;
import com.spring.common.CommonUtil;

@Controller
public class BoardController {

	@Autowired
	boardService boardService;

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@RequestMapping(value = "/board/boardList.do", method = RequestMethod.GET)
	public String boardList(Locale locale, Model model, PageVo pageVo, CodeVo codeVo)
			throws Exception {

		List<BoardVo> boardList = new ArrayList<BoardVo>();

		int page = 1;
		int totalCnt = 0;

		if (pageVo.getPageNo() == 0) {
			pageVo.setPageNo(page);
		}
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("boardList", boardList);
		boardList = boardService.boardTypeSearch(map);

		totalCnt = boardService.selectBoardCnt();

		model.addAttribute("boardList", boardList);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("pageNo", page);

		// boardType 불어오기
		List<CodeVo> codeList = new ArrayList<CodeVo>();
		codeList = boardService.codeList(codeVo);

		model.addAttribute("codeVo", codeList);

		return "board/boardList";
	}

	@RequestMapping(value = "/board/{boardType}/{boardNum}/boardView.do", method = RequestMethod.GET)
	public String boardView(Locale locale, Model model, @PathVariable("boardType") String boardType,
			@PathVariable("boardNum") int boardNum) throws Exception {

		BoardVo boardVo = new BoardVo();

		boardVo = boardService.selectBoard(boardType, boardNum);

		model.addAttribute("boardType", boardType);
		model.addAttribute("boardNum", boardNum);
		model.addAttribute("board", boardVo);

		return "board/boardView";
	}

	@RequestMapping(value = "/board/boardWrite.do", method = RequestMethod.GET)
	public String boardWrite(Locale locale, Model model, CodeVo codeVo) throws Exception {
		// boardType 불어오기
		List<CodeVo> codeList = new ArrayList<CodeVo>();
		codeList = boardService.codeList(codeVo);

		model.addAttribute("codeVo", codeList);

		return "board/boardWrite";
	}

	@RequestMapping(value = "/board/boardWriteAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardWriteAction(Locale locale, BoardVo boardVo) throws Exception {

		int resultCnt = boardService.boardInsert(boardVo);

		return createResult(resultCnt);
	}

	@RequestMapping(value = "/board/{boardType}/{boardNum}/boardUpdate.do", method = RequestMethod.GET)
	public String boardUpdate(Locale locale, Model model, @PathVariable(value = "boardType") String boardType,
			@PathVariable(value = "boardNum") int boardNum) throws Exception {
		BoardVo vo = new BoardVo();
		vo = boardService.selectBoard(boardType, boardNum);
		System.out.println("vo : " + vo);
		model.addAttribute("board", vo);

		return "board/boardUpdate";
	}

	@RequestMapping(value = "/board/boardUpdateAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardUpdateAction(Locale locale, BoardVo boardVo) throws Exception {

		int result = boardService.boardUpdate(boardVo);

		return createResult(result);
	}

	@RequestMapping(value = "/board/boardDeleteAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardDeleteAction(Locale locale, BoardVo boardVo) throws Exception {

		int result = boardService.boardDelete(boardVo);

		return createResult(result);
	}

	@RequestMapping(value = "/board/boardTypeSearch.do", method = RequestMethod.POST)
	@ResponseBody
	public List<BoardVo> boardSearchList(Locale locale, BoardVo boardVo, PageVo pageVo,
			@RequestParam(value = "boardType", defaultValue = "false") String boardType) throws Exception {

		System.out.println(">> boardType : " + boardType);

		int page = 1;
		int totalCnt = 0;

		if (pageVo.getPageNo() == 0) {
			pageVo.setPageNo(page);
		}

		System.out.println(">> page : " + page);

		String[] split = boardType.split(",");
		List<String> list = new ArrayList<String>();

		for (int i = 0; i < split.length; i++) {
			list.add(split[i]);
		}

		Map<String, Object> selects = new HashMap<String, Object>();
		selects.put("boardType", list);
		selects.put("pageNo", page);

		List<BoardVo> result = boardService.boardTypeSearch(selects);

		int resultCnt = result.size();
		System.out.println("resultCnt : " + resultCnt);

		createResult(result);

		return result;
	}

	@RequestMapping(value = "/board/join.do", method = RequestMethod.GET)
	public String join(Locale locale, Model model) throws Exception {

		List<CodeVo> phoneList = new ArrayList<CodeVo>();
		phoneList = boardService.phoneList();

		model.addAttribute("phoneList", phoneList);

		return "board/join";
	}

	@RequestMapping(value = "/board/joinAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String joinAction(Locale locale, UserVo userVo
			, @RequestParam(value = "userAddr1", defaultValue = "") String userAddr1
			, @RequestParam(value = "userAddr2", defaultValue = "") String userAddr2
			, @RequestParam(value = "userCompany", defaultValue = "") String userCompany) throws Exception {
		
		String userId = userVo.getUserId();
		System.out.println("id : " + userId);

		int resultCnt = boardService.userInsert(userVo);

		return createResult(resultCnt);
	}

	@RequestMapping(value = "/board/joinChkId.do", method = RequestMethod.POST)
	@ResponseBody
	public int joinChkId(@RequestParam(value = "userId") String userId, UserVo userVo, Model model) throws Exception {

		System.out.println("userId : " + userId);
		userVo.setUserId(userId);

		int resultCnt = boardService.selectId(userVo);
		createResult(resultCnt);

		return resultCnt;
	}

	@RequestMapping(value = "/board/login.do", method = RequestMethod.GET)
	public String login(Locale locale) {

		return "board/login";
	}

	@RequestMapping(value = "/board/loginAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loginAction(Locale locale, UserVo userVo, HttpSession session) throws Exception {

		UserVo user = new UserVo();
		user = boardService.userSelect(userVo);
		//로그인 세션 저장
		session.setAttribute("userVo", user);
		
		Map<String, Object> response = new HashMap<String, Object>();
		
		if(user != null) {
			response.put("success", true);
		} else {
			response.put("success", false);
			response.put("message", "일치하는 ID와 PW가 없습니다.");
		}
		return response;

	}

	@RequestMapping(value = "/board/logout.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> logout(UserVo userVo, HttpSession session) {
		
		System.out.println(session.getAttribute("userVo"));
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		if(userVo != null) {
			session.invalidate();
			
			result.put("success", true);
			result.put("msg", "로그아웃 완료됐습니다.");
		} else {
			result.put("success", false);
			result.put("msg", "로그인 회원이 아닙니다.");
		}
		
		return result;
	}

	
	private String createResult(List<BoardVo> result) throws IOException {

		HashMap<String, String> map = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();

		map.put("success", (result != null) ? "Y" : "N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ", map);

		System.out.println("callbackMsg::" + callbackMsg);

		return callbackMsg;
	}

	private String createResult(int result) throws IOException {

		HashMap<String, String> map = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();

		map.put("success", (result > 0) ? "Y" : "N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ", map);

		System.out.println("callbackMsg::" + callbackMsg);

		return callbackMsg;
	}
}
