package com.spring.board.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.boardService;
import com.spring.board.vo.BoardVo;

@Controller
public class MbtiController {

	@Autowired
	boardService boardService;

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@RequestMapping(value = "/mbti/mbtiStart.do", method = RequestMethod.GET)
	public String mbtiMain(Locale locale) {
		
		return "mbti/mbtiStart";
	}
	
	@RequestMapping(value = "/mbti/mbtiTest.do", method = RequestMethod.GET)
	public String mbtiTest(Locale locale, Model model, @Param("currentPage") Integer pageNo
				)
			throws Exception {
		
		if(pageNo == null) {
			pageNo = 1; //기본값, EI/IE 1~5문항
		}
		
		List<BoardVo> boardVo = new ArrayList<BoardVo>();
		boardVo = boardService.mbtiList(pageNo);
		
		model.addAttribute("mbtiList", boardVo);
		model.addAttribute("currentPage", pageNo);

		return "mbti/mbtiTest";
	}

	@RequestMapping(value = "/mbti/mbtiCalculation.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> mbtiCalculation(Locale locale
						, @RequestBody Map<String, String> savedData) {
		
		Map<String, Integer> scores = new HashMap<String, Integer>();
		scores.put("E", 0);
		scores.put("I", 0);
		scores.put("N", 0);
		scores.put("S", 0);
		scores.put("F", 0);
		scores.put("T", 0);
		scores.put("J", 0);
		scores.put("P", 0);
		
		//savedData를 이용하여 name, value 값 추출하여 각 타입별 점수 계산
		//boardType 유형에 따라 점수 계산!
		for(Map.Entry<String, String> entry : savedData.entrySet()) {
			String question = entry.getKey();
			int score = Integer.parseInt(entry.getValue());
			
			String first = question.substring(0, 1);
			String second = question.substring(1, 2);
			
			//각 문항별 radio 선택값에 따른 점수 계산: ex) E문항, 매우 동의(1)->E+3점 <-> 매우 비동의(7)->I+3점
			scoreCal(score, scores, first, second);
//			if(question.contains(first+second)) {
//				scoreCal(score, scores, first, second);
//			}
		}
		System.out.println("점수 계산 : E" + scores.get("E") + ",I" + scores.get("I")
						+ ",N" + scores.get("N") + ",S" + scores.get("S")
						+ ",F" + scores.get("F") + ",T" + scores.get("T")
						+ ",J" + scores.get("J") + ",P" + scores.get("P"));
		
		//점수 비교하여 mbti 판별 결과
		//합산 점수가 같거나 모두 0점인 경우 사전순(E=I, N=S, F=T, J=P or E=I=N=S=F=T=J=P=0)
	    String mbtiType = "";
	    //사전순 정렬
	    String[] ei = {"E", "I"};
	    String[] ns = {"N", "S"};
	    String[] ft = {"F", "T"};
	    String[] jp = {"J", "P"};
	    String msg = "";
	    
	    //모든 점수가 모두 0점인 경우
	    if(scores.get("E") == 0 && scores.get("I") == 0 
    		&& scores.get("N") == 0 && scores.get("S") == 0 
    		&& scores.get("F") == 0 && scores.get("T") == 0
    		&& scores.get("J") == 0 && scores.get("P") == 0) {
	    	//사전순 정렬로 빠른 유형 출력(sort 이용)
	    	Arrays.sort(ei);
	    	mbtiType += ei[0];
	    	Arrays.sort(ns);
	    	mbtiType += ns[0];
	    	Arrays.sort(ft);
	    	mbtiType += ft[0];
	    	Arrays.sort(jp);
	    	mbtiType += jp[0];
	    	msg += "각 지표 점수 모두 0점!";
	    //(E-I, S-N, F-T, J-P) 점수 비교 및 판별	
	    }  else {
	        // E/I 지표 판별
	    	mbtiType = distinguish(scores, mbtiType, msg,"E", "I", ei).get("mbtiType");
	    	msg = distinguish(scores, mbtiType, msg,"E", "I", ei).get("msg");

	        // S/N 지표 판별
	    	mbtiType = distinguish(scores, mbtiType, msg,"S", "N", ns).get("mbtiType");
	    	msg = distinguish(scores, mbtiType, msg,"S", "N", ns).get("msg");
	        
	        // T/F 지표 판별
	    	mbtiType = distinguish(scores, mbtiType, msg,"F", "T", ft).get("mbtiType");
	    	msg = distinguish(scores, mbtiType, msg,"F", "T", ft).get("msg");
	        
	        // J/P 지표 판별
	    	mbtiType = distinguish(scores, mbtiType, msg,"J", "P", jp).get("mbtiType");
	    	msg = distinguish(scores, mbtiType, msg,"J", "P", jp).get("msg");
	    }
	    System.out.println("mbtiType : " + mbtiType);
	    
	    Map<String, Object> result = new HashMap<>();
	    result.put("mbti", mbtiType);
	    result.put("msg", msg);
	    if(msg != null) {
	    	result.put("msg", msg);
	    }
	    
	    return result;
	}
	
	private void scoreCal(int score, Map<String, Integer> scores
							, String first, String second) {
		switch(score) {
			case 1 : scores.put(first, scores.get(first) + 3); break;
			case 2 : scores.put(first, scores.get(first) + 2); break;
			case 3 : scores.put(first, scores.get(first) + 1); break;
			case 5 : scores.put(second, scores.get(second) + 1); break;
			case 6 : scores.put(second, scores.get(second) + 2); break;
			case 7 : scores.put(second, scores.get(second) + 3); break;
		}
	}
	private Map<String, String> distinguish(Map<String, Integer> scores, String mbtiType, String msg
							, String first, String second, String[] boardType) {
		// (E-I, S-N, F-T, J-P)점수 비교 및 판별	
        if (scores.get(first) > scores.get(second)) {
            mbtiType += first;
        } else if (scores.get(first) < scores.get(second)) {
            mbtiType += second;
        //합산 점수가 같을 경우
        } else {
        	Arrays.sort(boardType);
	    	mbtiType += boardType[0];
	    	msg += first + "/" + second + " 동점";
        }
        Map<String, String> end = new HashMap<String, String>();
        end.put("mbtiType", mbtiType);
        if(msg != null) {
        	end.put("msg", msg);
        }
        return end;
	}
	
	@RequestMapping(value = "/mbti/mbtiResult.do", method = RequestMethod.GET)
	public String mbtiResult(Locale locale, Model model
					, @RequestParam String mbti) {
		
		model.addAttribute("mbti", mbti);
		
		return "mbti/mbtiResult";
	}
}
