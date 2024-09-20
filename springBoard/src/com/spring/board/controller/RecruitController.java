package com.spring.board.controller;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.boardService;
import com.spring.board.vo.RecruitVo;

@Controller
public class RecruitController {

	@Autowired
	boardService boardService;

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/recruit/login.do", method = RequestMethod.GET)
	public String login(Locale locale) throws Exception {
		
		return "recruit/login";
	}
	
	@RequestMapping(value = "/recruit/loginAction.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> loginAction(Locale locale, HttpSession session
							, RecruitVo recruitVo
							) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		//recruitVo 중복확인
		RecruitVo duplication = boardService.loginChk(recruitVo);
		
		if(duplication != null) {
			map.put("duplication", "Y");
			map.put("recruitVo", duplication);
			
			//session 로그인 정보 저장
			session.setAttribute("recruit", duplication);
			
		} else {
			//회원가입
			recruitVo.setBirth("");
			recruitVo.setField3("");
			recruitVo.setEmail("");
			recruitVo.setAddr("");
			recruitVo.setLocation("");
			recruitVo.setWorkType("");
			recruitVo.setSubmit("");
			
			int resultWrite = boardService.login(recruitVo);
			
			map.put("duplication", "N");
			map.put("success", (resultWrite > 0)? "Y" : "N");
			map.put("recruitVo", recruitVo);
			
			//session 로그인 정보 저장
			session.setAttribute("recruit", recruitVo);
		}
		
		return map;
	}
	
	@RequestMapping(value = "/recruit/main.do", method = RequestMethod.GET)
	public String main(Locale locale) {
		
		return "recruit/main";
	}
	
}
