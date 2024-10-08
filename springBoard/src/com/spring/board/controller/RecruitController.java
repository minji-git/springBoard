package com.spring.board.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import org.springframework.web.servlet.ModelAndView;

import com.spring.board.HomeController;
import com.spring.board.service.boardService;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
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
			duplication = boardService.loginChk(recruitVo);
			
			map.put("duplication", "N");
			map.put("success", (resultWrite > 0)? "Y" : "N");
			map.put("recruitVo", duplication);
			
			//session 로그인 정보 저장
			session.setAttribute("recruit", duplication);
		}
		
		return map;
	}


	@RequestMapping(value = "/recruit/main.do", method = RequestMethod.GET)
	public ModelAndView main(Locale locale, Model model
					, HttpSession session
					, RecruitVo recruitVo
					, EducationVo educationVo
					, CareerVo careerVo
					, CertificateVo certificateVo
					) throws Exception {
		
		//session 없으면 login.do로 전환
		if(session.getAttribute("recruit") == null) {
			String message = "세션종료 재로그인";
	        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8.toString());
			return new ModelAndView("redirect:/recruit/login.do?msg=" + encodedMessage);
		}
		
		//위치 리스트
		String[] localList = {"서울", "경기", "인천", "광주", "대전", "부산", "대구", "울산", "강원", "세종", "충북", "충남", "전북", "전남", "경북", "경남", "제주"};
		model.addAttribute("localList", localList);
		
		ModelAndView mav = new ModelAndView();
		
		try {
			//seq로 recruitVo 조회& model 저장
			RecruitVo recruitView = boardService.recruitView(recruitVo.getSeq());
			
			//최초 등록 후, 재로그인 시 학력/경력/자격증 리스트
			educationVo.setSeq(recruitView.getSeq());
			List<EducationVo> educationList = boardService.educationView(educationVo);
			
			//학력 기간 계산
			
			
			if(careerVo != null) {
				careerVo.setSeq(recruitView.getSeq());
				List<CareerVo> careerList = boardService.careerView(careerVo);
				model.addAttribute("careerList", careerList);
			}
			
			if(certificateVo != null) {
				certificateVo.setSeq(recruitView.getSeq());
				List<CertificateVo> certiList = boardService.certificateView(certificateVo);
				model.addAttribute("certiList", certiList);
			}
			
			//신규 recruit 가입한 경우는 바로 main.jsp
			mav = new ModelAndView("recruit/main");
			session.setAttribute("recruit", recruitView);
			mav.addObject("recruit", recruitView);
			mav.addObject("educationList", educationList);
			
		} catch (Exception e) {
		    e.printStackTrace(); // 예외 메시지 출력
		}
		return mav;
	}

	@RequestMapping(value = "/recruit/recruitSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> recruitSave(Locale locale, RecruitVo recruitVo
					, @RequestParam List<String> eduSeq, @RequestParam List<String> startPeriod
					, @RequestParam List<String> endPeriod, @RequestParam List<String> division
					, @RequestParam List<String> schoolName, @RequestParam List<String> eduLocation
					, @RequestParam List<String> major, @RequestParam List<String> grade
					, @RequestParam List<String> carSeq, @RequestParam List<String> carStartPeriod
					, @RequestParam List<String> carEndPeriod, @RequestParam List<String> compName
					, @RequestParam List<String> task, @RequestParam List<String> carLocation
					, @RequestParam List<String> certSeq, @RequestParam List<String> qualifiName
					, @RequestParam List<String> acquDate, @RequestParam List<String> organizeName
					) throws Exception {
		
System.out.println("> recruitSave 컨트롤러 수행~~");
		
		if(recruitVo.getSubmit() == null) {
			recruitVo.setSubmit("");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			// RecruitVo 저장
		    int recruitUpdate = boardService.recruitUpdate(recruitVo);
		    map.put("recruit", (recruitUpdate > 0) ? "Y" : "N");
		    
		    // 기존 학력 데이터 가져오기
		    EducationVo edu = new EducationVo();
		    edu.setSeq(recruitVo.getSeq());
	        ArrayList<EducationVo> existingEduList = boardService.educationView(edu);
System.out.println(">>> 존재하는 eduList 개수: " + existingEduList.size());
	        
	        // 새로운 학력 데이터 저장(insert, update)
	        int insertEdu = 0;
	        int updateEdu = 0;
	        for (int i = 0; i < eduSeq.size(); i++) {
	        	EducationVo newEdu = new EducationVo();
	        	newEdu.setSeq(recruitVo.getSeq());
	        	newEdu.setEduSeq(eduSeq.get(i));
                newEdu.setStartPeriod(startPeriod.get(i));
                newEdu.setEndPeriod(endPeriod.get(i));
                newEdu.setDivision(division.get(i));
                newEdu.setSchoolName(schoolName.get(i));
                newEdu.setLocation(eduLocation.get(i));
                newEdu.setMajor(major.get(i));
                newEdu.setGrade(grade.get(i));
                
	            // 기존 데이터와 비교하여 DB UPDATE 또는 INSERT 처리
	        	boolean exists = false;
	            for (EducationVo existingEdu : existingEduList) {
	            	//기존 eduSeq와 새로운 들어온 eduSeq가 일치하면 UPDATE 
	            	if(existingEdu.getEduSeq() != null 
	            			&& existingEdu.getEduSeq().equals(eduSeq.get(i))
	            			&& existingEdu.getSeq().equals(recruitVo.getSeq())) {
	            		//데이터 비교 후, 업데이트 결정
	            		if (!existingEdu.getSchoolName().equals(schoolName.get(i)) ||
            				!existingEdu.getStartPeriod().equals(startPeriod.get(i)) ||
            				!existingEdu.getEndPeriod().equals(endPeriod.get(i)) ||
            				!existingEdu.getDivision().equals(division.get(i)) ||
            				!existingEdu.getLocation().equals(eduLocation.get(i)) ||
            				!existingEdu.getMajor().equals(major.get(i)) ||
            				!existingEdu.getGrade().equals(grade.get(i))) {
	            			
	            			//데이터 UPDATE 처리
	            			boardService.educationUpdate(newEdu);
	            			updateEdu++;
	            		}
	            		exists = true;
	            		break; // 이미 존재하는 데이터인 경우, 학력 업데이트
	            	}
	            }

	            // 기존 데이터가 없는 경우, 새로운 데이터 삽입
	            if (!exists) {
	                // 학력 데이터 삽입
	                boardService.educationSave(newEdu);
	                insertEdu++;
	            }
	        }
	        if(insertEdu > 0) {
	        	map.put("eduInsert", insertEdu); // 학력 정보 insert 성공
	        }
	        if(updateEdu > 0) {
	        	map.put("eduUpdate", updateEdu); // 학력 정보 update 성공
	        }
	        
	        // 기존 경력 데이터 가져오기
		    CareerVo car = new CareerVo();
		    car.setSeq(recruitVo.getSeq());
	        ArrayList<CareerVo> existingCarList = boardService.careerView(car);
	        
	        // 새로운 경력 데이터 저장
	        int insertCar = 0;
	        for (int i = 0; i < carStartPeriod.size(); i++) {
	            boolean exists = false;
	            
	            // 기존 데이터와 비교
	            for (CareerVo existingCar : existingCarList) {
	                if (existingCar.getStartPeriod().equals(carStartPeriod.get(i)) &&
                		existingCar.getEndPeriod().equals(carEndPeriod.get(i)) &&
                		existingCar.getCompName().equals(compName.get(i)) &&
                		existingCar.getTask().equals(task.get(i)) &&
                		existingCar.getLocation().equals(carLocation.get(i))) {
	                    exists = true;
	                    break; // 이미 존재하는 데이터인 경우
	                }
	            }

	            // 새로운 데이터인 경우에만 삽입
	            if (!exists) {
	                CareerVo newCar = new CareerVo();
	                newCar.setSeq(recruitVo.getSeq());
	                newCar.setStartPeriod(carStartPeriod.get(i));
	                newCar.setEndPeriod(carEndPeriod.get(i));
	                newCar.setCompName(compName.get(i));
	                newCar.setTask(task.get(i));
	                newCar.setLocation(carLocation.get(i));

	                // 경력 데이터 삽입
	                boardService.careerSave(newCar);
	                insertCar++;
	            }
	        }
	        if(insertCar > 0) {
	        	map.put("career", "Y"); // 학력 정보 저장 성공
	        } else {
	        	map.put("career", "0"); // 학력 정보 저장 성공
	        }
	        
	        // 기존 자격증 데이터 가져오기
		    CertificateVo cert = new CertificateVo();
		    cert.setSeq(recruitVo.getSeq());
	        ArrayList<CertificateVo> existingCertList = boardService.certificateView(cert);
	        
	        // 새로운 자격증 데이터 저장
	        int insertCert = 0;
	        for (int i = 0; i < qualifiName.size(); i++) {
	            boolean exists = false;
	            
	            // 기존 데이터와 비교
	            for (CertificateVo existingCert : existingCertList) {
	                if (existingCert.getQualifiName().equals(qualifiName.get(i)) &&
                		existingCert.getAcquDate().equals(acquDate.get(i)) &&
                		existingCert.getOrganizeName().equals(organizeName.get(i))) {
	                    exists = true;
	                    break; // 이미 존재하는 데이터인 경우
	                }
	            }

	            // 새로운 데이터인 경우에만 삽입
	            if (!exists) {
	                CertificateVo newCert = new CertificateVo();
	                newCert.setSeq(recruitVo.getSeq());
	                newCert.setQualifiName(qualifiName.get(i));
	                newCert.setAcquDate(acquDate.get(i));
	                newCert.setOrganizeName(organizeName.get(i));

	                // 자격증 데이터 삽입
	                boardService.certificateSave(newCert);
	                insertCert++;
	            }
	        }
	        if(insertCert > 0) {
	        	map.put("certificate", "Y"); // 자격증 정보 저장 성공
	        } else {
	        	map.put("certificate", 0);
	        }
	        
	        // 저장 성공 시, 리다이렉트할 URL 추가
	        map.put("redirectUrl", "/recruit/main.do?seq=" + recruitVo.getSeq());
	        
		} catch (Exception e) {
		    e.printStackTrace(); // 예외 메시지 출력
		    map.put("error", "업데이트 중 오류 발생" + e.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/recruit/addRow.do", method = RequestMethod.POST)
	@ResponseBody
	public String addRow(Locale locale) throws Exception {
		
		return "recruit/main.do";
	}

	@RequestMapping(value = "/recruit/deleteRow.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteRow(Locale locale, HttpServletRequest request
									, @RequestBody Map<String, List<String>> respData
									) throws Exception {
		
		System.out.println(">> 컨트롤러 deleteRow 시작~!! <<");
		
		Map<String, String> result = new HashMap<>();
		List<String> eduSeqs = respData.get("eduSeqs");
		List<String> carSeqs = respData.get("carSeqs");
		List<String> certSeqs = respData.get("certSeqs");
		
		try {
			HttpSession session = request.getSession();
			RecruitVo recruit = (RecruitVo)session.getAttribute("recruit");
			
			//학력 삭제
			// 1.체크된 eduSeqs 추출하여, DB 데이터 삭제 및 행 삭제
			for(String eduSeq : eduSeqs) {
				EducationVo eduVo = new EducationVo();
				eduVo.setEduSeq(eduSeq);
				eduVo.setSeq(recruit.getSeq());
				System.out.println(":: eduSeq : " + eduSeq + ", seq: " + recruit.getSeq());
				
				// 1-1.체크된 행 중, eduSeq가 없는 행 삭제
                if (eduSeq == null) {
                    // 데이터베이스에서 삭제할 필요 없음
                    result.put("eduDel", "행을 삭제합니다.");
                // 1-2.체크된 eduSeq DB 데이터 삭제 및 행 삭제
                } else {
                    // eduSeq 데이터가 존재하는 경우 DB 삭제
                    int deleteEdu = boardService.educationDelete(eduVo);
                    if (deleteEdu > 0) {
                        result.put("education", "학력 정보가 삭제되었습니다.");
                    }
                }
			}
			
			//경력 삭제
			// 1.체크된 carSeqs 추출하여, DB 데이터 삭제 및 행 삭제
			for(String carSeq : carSeqs) {
				CareerVo carVo = new CareerVo();
				carVo.setCarSeq(carSeq);
				carVo.setSeq(recruit.getSeq());
				
				// 1-1.체크된 행 중, carSeq가 없는 행 삭제
				if(carSeq == null) {
					// 데이터베이스에서 삭제할 필요 없음
                    result.put("carDel", "행을 삭제합니다.");
                // 1-2.체크된 carSeq DB 데이터 삭제 및 행 삭제
				} else {
					// carSeq 데이터가 존재하는 경우 DB 삭제
					int deleteCar = boardService.careerDelete(carVo);
					if(deleteCar > 0) {
						result.put("career", "경력 정보가 삭제되었습니다.");
					}
				}
			}
			
			//자격증 삭제
			// 1.체크된 certSeqs 추출하여, DB 데이터 삭제 및 행 삭제
			for(String certSeq : certSeqs) {
				CertificateVo certVo = new CertificateVo();
				certVo.setCertSeq(certSeq);
				certVo.setSeq(recruit.getSeq());
				
				// 1-1.체크된 행 중, certSeq가 없는 행 삭제
				if(certSeq == null) {
					// 데이터베이스에서 삭제할 필요 없음
					result.put("certDel", "행을 삭제하였습니다.");
				// 1-2.체크된 certSeq DB 데이터 삭제 및 행 삭제
				} else {
					// certSeq 데이터가 존재하는 경우 DB 삭제
					int deleteCert = boardService.certificateDelete(certVo);
					if(deleteCert > 0) {
						result.put("certificate", "자격증 정보가 삭제되었습니다.");
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace(); // 예외 메시지 출력
		    result.put("error", "업데이트 중 오류 발생" + e.getMessage());
		}
		return result;
	}

}
