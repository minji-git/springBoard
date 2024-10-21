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
			
			// 기본값 설정
	        if (recruitView.getSubmit() == null) {
	            recruitView.setSubmit(""); // 기본값 설정
	        }
			
	        //최초 등록 후, 재로그인 시 학력/경력/자격증 리스트
			//학력 가져오기(최종 학력만 표시?)
			educationVo.setSeq(recruitView.getSeq());
			List<EducationVo> educationList = boardService.educationView(educationVo);
			model.addAttribute("educationList", educationList);
			
			//학력 기간 계산
			int totalYearsElementary = 0;
	        int totalYearsMiddle = 0;
	        int totalYearsHigh = 0;
	        int totalYearsUniversity = 0;
	        int totalYearsUniversity2 = 0;

			for (EducationVo education : educationList) {
				// 시작과 종료 기간을 가져옴
			    String startPeriod = education.getStartPeriod(); // 예: "2023.03"
			    String endPeriod = education.getEndPeriod(); // 예: "2025.06"

			    try {
			        // 연도와 월을 분리
			        String[] startParts = startPeriod.split("\\.");
			        String[] endParts = endPeriod.split("\\.");

			        int startYear = Integer.parseInt(startParts[0]);
			        int startMonth = Integer.parseInt(startParts[1]);
			        int endYear = Integer.parseInt(endParts[0]);
			        int endMonth = Integer.parseInt(endParts[1]);

			        // 총 년도 계산
			        int yearDiff = endYear - startYear;
			        int monthDiff = endMonth - startMonth;

			        // 월 차이가 음수일 경우 년도에서 1을 빼고 12를 더함
			        if (monthDiff < 0) {
			            yearDiff--;
			            monthDiff += 12;
			        }

			        // 학력별로 총 년도에 추가
	                if (education.getSchoolName() != null) {
	                    if (education.getSchoolName().contains("초등학교")) {
	                        totalYearsElementary += yearDiff;
	                    } else if (education.getSchoolName().contains("중학교")) {
	                        totalYearsMiddle += yearDiff;
	                    } else if (education.getSchoolName().contains("고등학교")) {
	                        totalYearsHigh += yearDiff;
	                    } else if (education.getSchoolName().contains("대학교")) {
	                        totalYearsUniversity += yearDiff;
	                    } else if (education.getSchoolName().contains("대학원")) {
	                        totalYearsUniversity2 += yearDiff;
	                    }
	                }
			        
			    } catch (Exception e) {
			        System.err.println("잘못된 기간 형식: " + startPeriod + " - " + endPeriod);
			        // 필요에 따라 예외 처리 로직 추가
			    }
			}
			model.addAttribute("totalYearsElementary", totalYearsElementary);
	        model.addAttribute("totalYearsMiddle", totalYearsMiddle);
	        model.addAttribute("totalYearsHigh", totalYearsHigh);
	        model.addAttribute("totalYearsUniversity", totalYearsUniversity);
	        model.addAttribute("totalYearsUniversity2", totalYearsUniversity2);
			
			if(careerVo != null) {
				careerVo.setSeq(recruitView.getSeq());
				List<CareerVo> careerList = boardService.careerView(careerVo);
				model.addAttribute("careerList", careerList);
				
				//경력 총 기간 계산
				int totalCareerYear = 0;
				int totalCareerMonth = 0;
				
				for(CareerVo career : careerList) {
					// 시작과 종료 기간을 가져옴
				    String startPeriod = career.getStartPeriod(); // 예: "2023.03"
				    String endPeriod = career.getEndPeriod(); // 예: "2025.06"
				    
				    try {
				        // 연도와 월을 분리
				        String[] startParts = startPeriod.split("\\.");
				        String[] endParts = endPeriod.split("\\.");

				        int startYear = Integer.parseInt(startParts[0]);
				        int startMonth = Integer.parseInt(startParts[1]);
				        int endYear = Integer.parseInt(endParts[0]);
				        int endMonth = Integer.parseInt(endParts[1]);

				        // 총 년도 계산
				        int yearDiff = endYear - startYear;
				        int monthDiff = endMonth - startMonth;

				        // 월 차이가 음수일 경우 년도에서 1을 빼고 12를 더함
				        if (monthDiff < 0) {
				            yearDiff--;
				            monthDiff += 12;
				        }
				        totalCareerYear += yearDiff;
				        totalCareerMonth += monthDiff;
				    } catch (Exception e) {
				        System.err.println("잘못된 기간 형식: " + startPeriod + " - " + endPeriod);
				        // 필요에 따라 예외 처리 로직 추가
				    }
				}
				if(totalCareerMonth >= 12) {
					totalCareerYear += totalCareerMonth / 12;
					totalCareerMonth = totalCareerMonth % 12;
				}
				model.addAttribute("totalCareerYear", totalCareerYear);
				model.addAttribute("totalCareerMonth", totalCareerMonth);
			}
			
			if(certificateVo != null) {
				certificateVo.setSeq(recruitView.getSeq());
				List<CertificateVo> certiList = boardService.certificateView(certificateVo);
				model.addAttribute("certiList", certiList);
			}
			
			//신규 recruit 가입한 경우는 바로 main.jsp
			mav = new ModelAndView("recruit/main");
			
			session.setAttribute("recruit", recruitView);
			model.addAttribute("recruit", recruitView);
			
		} catch (Exception e) {
		    e.printStackTrace();
		}
		return mav;
	}

	@RequestMapping(value = "/recruit/recruitSave.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> recruitSave(Locale locale, RecruitVo recruitVo
					, EducationVo education
					, @RequestParam List<String> eduSeq, @RequestParam List<String> startPeriod
					, @RequestParam List<String> endPeriod, @RequestParam List<String> division
					, @RequestParam List<String> schoolName, @RequestParam List<String> eduLocation
					, @RequestParam List<String> major, @RequestParam List<String> grade
					, @RequestParam(required = false)  List<String> carSeq, @RequestParam(required = false)  List<String> carStartPeriod
					, @RequestParam(required = false)  List<String> carEndPeriod, @RequestParam(required = false)  List<String> compName
					, @RequestParam(required = false)  List<String> task, @RequestParam(required = false)  List<String> carLocation
					, @RequestParam(required = false)  List<String> certSeq, @RequestParam(required = false)  List<String> qualifiName
					, @RequestParam(required = false)  List<String> acquDate, @RequestParam(required = false)  List<String> organizeName
					) throws Exception {
		
System.out.println("> recruitSave 컨트롤러 수행~~");
		
		if(recruitVo.getSubmit() == null) {
			recruitVo.setSubmit("");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			RecruitVo isRecruit = boardService.loginChk(recruitVo);
			if(isRecruit.getBirth() != null && isRecruit.getField3() != null
				    && isRecruit.getEmail() != null && isRecruit.getAddr() != null
				    && isRecruit.getLocation() != null && isRecruit.getWorkType() != null) {
				//isRecruit 값이 모두 기입됐을 때, 컬럼값 동일한지 확인 후 1)동일하면 저장만! 2)다르다면 UPDATE 처리
				if(isRecruit.getBirth().equals(recruitVo.getBirth()) && isRecruit.getField3().equals(recruitVo.getField3()) 
						&& isRecruit.getEmail().equals(recruitVo.getEmail()) && isRecruit.getAddr().equals(recruitVo.getAddr())
						&& isRecruit.getLocation().equals(recruitVo.getLocation()) && isRecruit.getWorkType().equals(recruitVo.getWorkType())) {
					System.out.println(">> recruitVo 정보가 동일함!!");
					map.put("recruit", "N");
				} else {
					System.out.println(">> recruitVo 정보가 수정됨!!");
					// RecruitVo 저장
					int recruitUpdate = boardService.recruitUpdate(recruitVo);
					map.put("recruit", (recruitUpdate > 0) ? "Y" : "N");
				}
			} else {
				// isRecruit 중 기입하지 않은 컬럼이 존재하면 기존 recruitVo를 update
				System.out.println(">> recruit 처음 입력됨!!");
				int recruitUpdate = boardService.recruitUpdate(recruitVo);
				map.put("recruit", (recruitUpdate > 0) ? "Y" : "N");
			}
		    
		    // 기존 학력 데이터 가져오기
		    EducationVo edu = new EducationVo();
		    edu.setSeq(recruitVo.getSeq());
	        ArrayList<EducationVo> existingEduList = boardService.educationView(edu);
	        
	        // 새로운 학력 데이터 저장(insert, update, unchanged)
	        int insertEduCnt = 0;
	        int updateEduCnt = 0;
	        int unchangedEduCnt = 0;
	        
			for (int i = 0; i < startPeriod.size(); i++) {
				EducationVo newEdu = new EducationVo();
				newEdu.setSeq(recruitVo.getSeq());
				newEdu.setStartPeriod(startPeriod.get(i));
				newEdu.setEndPeriod(endPeriod.get(i));
				newEdu.setDivision(division.get(i));
				newEdu.setSchoolName(schoolName.get(i));
				newEdu.setLocation(eduLocation.get(i));
				newEdu.setMajor(major.get(i));
				newEdu.setGrade(grade.get(i));
				
				//최초 학력 정보 저장
		        if(existingEduList.isEmpty()) {
		        	//eduSeq가 null이거나 비어있는 경우: 새로운 데이터 삽입
		        	System.out.println(":: 기존 학력 데이터 없음, 새로운 데이터 삽입");
	                boardService.educationSave(newEdu);
	                insertEduCnt++;
		        } else if(i >= eduSeq.size()) {
		        	//행 추가하여 새로운 데이터 삽입(기존 데이터 + 행 추가 입력)
		        	System.out.println(":: 기존 학력 데이터 + 새로운 데이터 삽입");
	                boardService.educationSave(newEdu);
	                insertEduCnt++;
		        } else {
	                // eduSeq가 있는 경우, 기존 데이터와 비교하여 업데이트 또는 변경 없음 처리	
					for(EducationVo existingEdu : existingEduList) {
						// eduSeq가 일치하는 eduVo에서
						if(existingEdu.getEduSeq().equals(eduSeq.get(i))) {
							//기존 데이터와 비교하여 UPDATE 여부 결정
							if(!existingEdu.getSchoolName().equals(schoolName.get(i))
									|| !existingEdu.getStartPeriod().equals(startPeriod.get(i))
									|| !existingEdu.getEndPeriod().equals(endPeriod.get(i))
									|| !existingEdu.getDivision().equals(division.get(i))
									|| !existingEdu.getLocation().equals(eduLocation.get(i))
									|| !existingEdu.getMajor().equals(major.get(i))
									|| !existingEdu.getGrade().equals(grade.get(i))) {
								
								System.out.println(":: 기존 학력 업데이트: " + existingEdu.getEduSeq());
	                            newEdu.setEduSeq(existingEdu.getEduSeq());
	                            boardService.educationUpdate(newEdu); // DB UPDATE 메서드 호출
	                            updateEduCnt++;
							//변경되지 않은 데이터
							} else {
								System.out.println(":: 변경 없음, 기존 학력 저장: " + existingEdu.getEduSeq());
	                            unchangedEduCnt++;
							}
							break;
						}
					}
		        }
	        }
			
			// 기존 경력 데이터 가져오기
		    CareerVo car = new CareerVo();
		    car.setSeq(recruitVo.getSeq());
	        ArrayList<CareerVo> existingCarList = boardService.careerView(car);
	        
	        // 새로운 학력 데이터 저장(insert, update, unchanged)
	        int insertCarCnt = 0;
	        int updateCarCnt = 0;
	        int unchangedCarCnt = 0;
	        
	        if(carStartPeriod != null || carEndPeriod != null || compName != null
					|| task != null || carLocation != null) {
	        	for (int i = 0; i < carStartPeriod.size(); i++) {
	        		CareerVo newCar = new CareerVo();
	        		newCar.setSeq(recruitVo.getSeq());
	        		
	        		//input 입력값이 1개라도 없을 경우, 저장X
	        		// 5개 input 모두 null인 경우
	                if (carStartPeriod.get(i) == "" && carEndPeriod.get(i) == "" 
	                        && compName.get(i) == "" && task.get(i) == "" && carLocation.get(i) == "") {
	                    System.out.println("5개 input 모두 \"\"로 저장X");
	                    continue; // 다음 반복으로 넘어감
	                }
	        		//모든 input 값이 존재할 경우,
	        		newCar.setStartPeriod(carStartPeriod.get(i));
	        		newCar.setEndPeriod(carEndPeriod.get(i));
	        		newCar.setCompName(compName.get(i));
	        		newCar.setTask(task.get(i));
	        		newCar.setLocation(carLocation.get(i));
	        		
	        		//최초 경력 정보 저장
	        		if(existingCarList.isEmpty()) {
	        			//carSeq가 null이거나 비어있는 경우: 새로운 데이터 삽입
	        			System.out.println(":: 기존 경력 데이터 없음, 새로운 데이터 삽입");
	        			boardService.careerSave(newCar);
	        			insertCarCnt++;
	        		} else if(i >= carSeq.size()) {
	        			//행 추가하여 새로운 데이터 삽입(기존 데이터 + 행 추가 입력)
	        			System.out.println(":: 기존 경력 데이터 있음 + 새로운 데이터 삽입");
	        			boardService.careerSave(newCar);
	        			insertCarCnt++;
	        		} else {
	        			// carSeq가 있는 경우, 기존 데이터와 비교하여 업데이트 또는 변경 없음 처리	
	        			for(CareerVo existingCar : existingCarList) {
	        				// carSeq가 일치하는 carVo에서
	        				if(existingCar.getCarSeq().equals(carSeq.get(i))) {
	        					//기존 데이터와 비교하여 UPDATE 여부 결정
	        					if(!existingCar.getStartPeriod().equals(carStartPeriod.get(i))
	        							|| !existingCar.getEndPeriod().equals(carEndPeriod.get(i))
	        							|| !existingCar.getCompName().equals(compName.get(i))
	        							|| !existingCar.getTask().equals(task.get(i))
	        							|| !existingCar.getLocation().equals(carLocation.get(i))) {
	        						
	        						System.out.println(":: 기존 경력 업데이트: " + existingCar.getCarSeq());
	        						newCar.setCarSeq(existingCar.getCarSeq());
	        						boardService.careerUpdate(newCar); // DB UPDATE 메서드 호출
	        						updateCarCnt++;
	        						//변경되지 않은 데이터
	        					} else {
	        						System.out.println(":: 변경 없음, 기존 경력 저장: " + existingCar.getCarSeq());
	        						unchangedCarCnt++;
	        					}
	        					break;
	        				}
	        			}
	        		}
	        	}
	        }
			
			// 기존 자격증 데이터 가져오기
		    CertificateVo cert = new CertificateVo();
		    cert.setSeq(recruitVo.getSeq());
	        ArrayList<CertificateVo> existingCertList = boardService.certificateView(cert);
	        
	        // 새로운 자격증 데이터 저장(insert, update, unchanged)
	        int insertCertCnt = 0;
	        int updateCertCnt = 0;
	        int unchangedCertCnt = 0;
	        
	        if(qualifiName != null || acquDate != null || organizeName != null) {
	        	for (int i = 0; i < qualifiName.size(); i++) {
	        		CertificateVo newCert = new CertificateVo();
	        		newCert.setSeq(recruitVo.getSeq());
	        		
	        		//input 입력값이 1개라도 없을 경우, 저장X
	        		// 3개 input 모두 null인 경우
	                if (qualifiName.get(i) == "" && acquDate.get(i) == "" && organizeName.get(i) == "") {
	                    System.out.println("3개 input 모두 \"\"로 저장X");
	                    continue; // 다음 반복으로 넘어감
	                }
	        		
	        		//모든 input 값이 존재할 경우,
	        		newCert.setQualifiName(qualifiName.get(i));
	        		newCert.setAcquDate(acquDate.get(i));
	        		newCert.setOrganizeName(organizeName.get(i));
	        		
	        		//최초 자격증 정보 저장
	        		if(existingCertList.isEmpty()) {
	        			//certSeq가 null이거나 비어있는 경우: 새로운 데이터 삽입
	        			System.out.println(":: 기존 자격증 데이터 없음, 새로운 데이터 삽입");
	        			boardService.certificateSave(newCert);
	        			insertCertCnt++;
	        		} else if(i >= certSeq.size()) {
	        			//행 추가하여 새로운 데이터 삽입(기존 데이터 + 행 추가 입력)
	        			System.out.println(":: 기존 자격증 데이터 + 새로운 데이터 삽입");
	        			boardService.certificateSave(newCert);
	        			insertCertCnt++;
	        		} else {
	        			// certSeq가 있는 경우, 기존 데이터와 비교하여 업데이트 또는 변경 없음 처리	
	        			for(CertificateVo existingCert : existingCertList) {
	        				// certSeq가 일치하는 certVo에서
	        				if(existingCert.getCertSeq().equals(certSeq.get(i))) {
	        					//기존 데이터와 비교하여 UPDATE 여부 결정
	        					if(!existingCert.getQualifiName().equals(qualifiName.get(i))
	        							|| !existingCert.getAcquDate().equals(acquDate.get(i))
	        							|| !existingCert.getOrganizeName().equals(organizeName.get(i))) {
	        						
	        						System.out.println(":: 기존 자격증 업데이트: " + existingCert.getCertSeq());
	        						newCert.setCertSeq(existingCert.getCertSeq());
	        						boardService.certificateUpdate(newCert); // DB UPDATE 메서드 호출
	        						updateCertCnt++;
	        						//변경되지 않은 데이터
	        					} else {
	        						System.out.println(":: 변경 없음, 기존 자격증 저장: " + existingCert.getCertSeq());
	        						unchangedCertCnt++;
	        					}
	        					break;
	        				}
	        			}
	        		}
	        	}
	        }
	        // 결과 기록
	        map.put("insertEduCnt", insertEduCnt);
	        map.put("updateEduCnt", updateEduCnt);
	        map.put("unchangedEduCnt", unchangedEduCnt);
	        
	        map.put("insertCarCnt", insertCarCnt);
	        map.put("updateCarCnt", updateCarCnt);
	        map.put("unchangedCarCnt", unchangedCarCnt);
	        
	        map.put("insertCertCnt", insertCertCnt);
	        map.put("updateCertCnt", updateCertCnt);
	        map.put("unchangedCertCnt", unchangedCertCnt);
	        
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
	
	@RequestMapping(value = "/recruit/recruitSubmit.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> recruitSubmit(Locale locale
											, RecruitVo recruitVo) throws Exception {
		
		Map<String, String> result = new HashMap<String, String>();
		
		//저장된 recruit,education 정보가 있는지 확인 후, 제출 처리
		EducationVo edu = new EducationVo();
		edu.setSeq(recruitVo.getSeq());
		ArrayList<EducationVo> eduList = boardService.educationView(edu);
		int eduCnt = eduList.size();
		if (eduCnt == 0) {
	        result.put("hold", "저장하고 제출해주세요.");
	    } else {
	        // 제출 처리
	        recruitVo.setSubmit("yes");
	        int recruitSubmit = boardService.recruitUpdate(recruitVo);
	        result.put("success", (recruitSubmit > 0 ? "입사 지원서를 제출하였습니다." : null));
	    }
		
		return result;
	}
}
