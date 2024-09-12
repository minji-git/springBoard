package com.spring.board.controller;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.boardService;
import com.spring.board.vo.RecruitVo;
import com.spring.common.CommonUtil;

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
	public String loginAction(Locale locale, @RequestBody RecruitVo recruitVo, HttpSession session
							) throws Exception {
		
		System.out.println("recruitVo 이름/번호: " + recruitVo.getName() + recruitVo.getPhone());
		
		int result = boardService.login(recruitVo);
		
		Map<String, String> map = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		map.put("success", (result > 0) ? "Y" : "N");
		String callbackMsg = commonUtil.getJsonCallBackString("", map);
		
		return callbackMsg;
	}
	
}
