//
//  LegalType.swift
//  SnapPop
//
//  Created by 이인호 on 8/20/24.
//

import Foundation

enum LegalType {
    case privacyPolicy
    case dataUsagePolicy
    case termsOfService
    
    var content: String {
        switch self {
        case .privacyPolicy:
            return """
            1. 개인정보의 수집 및 이용 목적
            우리 앱에서는 사용자의 편의를 위해 애플 로그인과 구글 로그인을 허용합니다. 이를 통해 수집된 개인정보는 다음과 같은 목적으로 이용됩니다:
            - 사용자 인증 및 계정 관리
            - 서비스 제공 및 개선
            - 사용자 문의 및 요청에 대한 대응
            - 서비스 이용 통계 및 분석
            
            2. 수집하는 개인정보의 항목
            애플 로그인 및 구글 로그인을 통해 수집되는 개인정보는 다음과 같습니다:
            - 이름
            - 이메일 주소
            - 프로필 사진 (선택 사항)
            - 로그인 관련 정보 (OAuth 토큰 등)
            
            3. 개인정보의 보유 및 이용 기간
            사용자의 개인정보는 서비스 제공을 위해 필요한 기간 동안 보유되며, 이용 목적이 달성된 후에는 관련 법령에 따라 안전하게 파기됩니다. 구체적인 보유 및 이용 기간은 다음과 같습니다:
            - 계정 생성 및 관리: 계정 삭제 요청 시까지
            - 서비스 이용 기록: 3년
            
            4. 개인정보의 제3자 제공
            우리 앱은 사용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 다만, 다음의 경우에는 예외로 합니다:
            - 사용자가 사전에 동의한 경우
            - 법령에 의해 요구되는 경우
            
            5. 개인정보의 보호
            우리 앱은 사용자의 개인정보를 안전하게 보호하기 위해 다음과 같은 조치를 취하고 있습니다:
            - 데이터 암호화
            - 접근 통제 및 인증 절차
            - 정기적인 보안 점검 및 개선
            
            6. 사용자의 권리와 의무
            사용자는 언제든지 자신의 개인정보에 대한 열람, 수정, 삭제를 요청할 수 있습니다. 또한, 사용자는 개인정보 보호와 관련된 법률을 준수하여야 하며, 타인의 개인정보를 침해하지 않을 의무가 있습니다.
            
            7. 개인정보 보호 책임자
            우리 앱은 사용자의 개인정보를 보호하고 관련 불만을 처리하기 위해 아래와 같이 개인정보 보호 책임자를 지정하고 있습니다:
            - 개인정보 보호 책임자: [이름]
            - 연락처: [이메일 주소/전화번호]
            
            8. 정책 변경에 대한 고지
            개인정보 보호 설정 정책이 변경되는 경우, 변경 사항을 시행 최소 7일 전에 앱 내 공지사항을 통해 고지할 것입니다.
            이 정책은 [시행일자]부터 시행됩니다.
            """
        case .dataUsagePolicy:
            return """
            1. 데이터 수집 목적
            우리 앱은 사용자의 편리한 서비스 이용을 위해 다양한 데이터를 수집합니다. 수집된 데이터는 다음과 같은 목적으로 사용됩니다:
            서비스 제공 및 개선
            사용자 경험 개인화
            서비스 관련 정보 제공
            고객 지원 및 문의 응답
            통계 분석 및 연구
            
            2. 수집하는 데이터 항목
            우리 앱에서 수집하는 데이터는 다음과 같습니다:
            개인 식별 정보: 이름, 이메일 주소, 프로필 사진 등
            로그인 정보: 사용자 계정 관련 정보 (애플, 구글 로그인 시 제공되는 정보)
            사용 기록: 앱 이용 내역, 접속 로그, 기기 정보, IP 주소 등
            기타 사용자 제공 정보: 피드백, 설문 응답 등
            
            3. 데이터 수집 방법
            데이터는 다음과 같은 방법을 통해 수집됩니다:
            사용자가 회원가입 또는 로그인 시 제공하는 정보
            서비스 이용 과정에서 자동으로 수집되는 정보
            고객 지원을 위한 문의 시 사용자가 제공하는 정보
            
            4. 데이터 사용 및 처리
            수집된 데이터는 다음과 같은 방식으로 사용 및 처리됩니다:
            사용자 인증 및 계정 관리
            맞춤형 서비스 제공 및 개선
            서비스 이용 통계 분석 및 연구
            고객 지원 및 문제 해결
            법적 요구사항 준수
            
            5. 데이터 공유 및 제공
            우리 앱은 원칙적으로 사용자의 데이터를 외부에 제공하지 않습니다. 다만, 다음의 경우에는 예외로 합니다:
            사용자가 사전에 동의한 경우
            법령에 의해 요구되는 경우
            서비스 제공을 위해 필요한 경우 (예: 서버 호스팅 업체 등)
            
            6. 데이터 보안
            우리 앱은 사용자의 데이터를 안전하게 보호하기 위해 다음과 같은 조치를 취하고 있습니다:
            데이터 암호화
            접근 통제 및 인증 절차
            정기적인 보안 점검 및 개선
            """
        case .termsOfService:
            return """
            제 1 조 (목적)
            본 약관은 [앱 이름] (이하 "앱")이 제공하는 모든 서비스(이하 "서비스")의 이용과 관련하여 앱과 이용자의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.
            
            제 2 조 (정의)
            "앱"이란 [앱 운영 회사명]이 제공하는 모바일 애플리케이션 및 관련 서비스를 의미합니다.
            "이용자"란 본 약관에 따라 앱이 제공하는 서비스를 받는 자를 말합니다.
            "계정"이란 이용자가 앱에 로그인하기 위해 사용하는 이메일 주소 및 비밀번호 등의 정보를 의미합니다.
            
            제 3 조 (약관의 명시와 개정)
            앱은 본 약관의 내용을 이용자가 쉽게 알 수 있도록 앱 내에 게시합니다.
            앱은 관련 법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.
            앱이 약관을 개정할 경우에는 적용 일자 및 개정 사유를 명시하여 현행 약관과 함께 앱 내에 공지합니다.
            이용자는 개정된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다. 개정된 약관의 효력 발생일 이후에도 서비스를 계속 이용할 경우, 이용자는 개정된 약관에 동의한 것으로 간주됩니다.
            
            제 4 조 (서비스의 제공 및 변경)
            앱은 이용자에게 다음과 같은 서비스를 제공합니다:
            계정 생성 및 관리
            콘텐츠 제공
            기타 앱이 자체 개발하거나 다른 회사와의 협력 계약 등을 통해 이용자에게 제공할 일체의 서비스
            앱은 필요한 경우 서비스의 내용을 변경할 수 있습니다. 이 경우 앱은 변경된 내용을 사전에 공지합니다.
            
            제 5 조 (서비스의 중단)
            앱은 시스템 점검, 교체 및 고장 등 불가피한 사유가 있는 경우 서비스의 제공을 일시적으로 중단할 수 있습니다.
            앱은 제1항의 사유로 서비스가 중단되는 경우, 앱은 사전에 이를 공지하며, 불가피한 경우 사후에 공지할 수 있습니다.
            
            제 6 조 (회원가입)
            이용자는 앱이 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의함으로써 회원가입을 신청합니다.
            앱은 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.
            """
        }
    }
}